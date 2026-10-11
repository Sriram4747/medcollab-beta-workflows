import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { profiles, catalogFor, adaptSecurity, jobEvidence } from './workflow-adapters.mjs';
import { summary, junit, sanitize } from './report.mjs';
import { execFileSync } from 'node:child_process';

test('included workflow inventory excludes Security Environment Test',()=>{
  assert.equal(Object.keys(profiles).length,6);
  assert(!profiles['vocle-security-environment-test.yml']);
});
for(const [file,fixture,count,pass,observations] of [
  ['vocle-backend-environment-test.yml','37361855710',691,611,80],
  ['vocle-media-security.yml','37361859575',97,62,35],
  ['vocle-data-security.yml','37361864154',31,22,9],
])test('real recorded '+file+' outcomes remain observations, not passes/failures',async()=>{
  const input=JSON.parse(await readFile(`docs/security-evidence/${fixture}/results.json`));
  const profile=profiles[file],catalog=await catalogFor(profile),report=adaptSecurity(input,catalog,profile,{sha:'a'.repeat(40),gate:'SUCCESS'});
  assert.equal(report.results.length,count);if(input.results[0].module)assert.equal(report.results[0].module,input.results[0].module);assert.equal(report.counts.PASS,pass);assert.equal(report.counts.OBSERVATION,observations);assert.equal(report.counts.FAIL,0);assert.equal(report.originalGate,'SUCCESS');
  assert(report.results.every(r=>typeof r.expected==='string'&&typeof r.actual==='string'&&r.steps.length));
  assert(summary(report).includes('OBSERVATION'));assert(junit(report).includes('message="OBSERVATION"'));assert(junit(report).includes('failures="0"'));
  const missing=adaptSecurity({},catalog,profile,{sha:'a'.repeat(40),gate:'FAILURE'});assert.equal(missing.attempted,0);assert.equal(missing.counts.ERROR,count);assert.equal(missing.counts.PASS,0);
  const malformed=structuredClone(input);malformed.passed=999;assert.throws(()=>adaptSecurity(malformed,catalog,profile),/tally/);
});
test('Cloudinary adapter handles recorded observations and cleanup infrastructure distinctly without provider access',async()=>{
  const profile=profiles['vocle-cloudinary-security.yml'],catalog=await catalogFor(profile);
  const input={source:'a'.repeat(40),cases:[{...catalog[0],status:'OBSERVATION',actual:{status:400}},{...catalog.at(-1),status:'INFRASTRUCTURE_FAILURE',actual:{proven:false}}],failure:'CLEANUP_FAILED'};
  const report=adaptSecurity(input,catalog,profile,{sha:'b'.repeat(40),gate:'FAILURE'});
  assert.equal(report.counts.OBSERVATION,1);assert.equal(report.counts.ERROR,catalog.length-1);assert.equal(report.attempted,2);assert.equal(report.originalGate,'FAILURE');assert(report.infrastructure.some(r=>r.category==='ORIGINAL_INFRASTRUCTURE'));
});
test('scanner job evidence never claims testcase or secret match coverage',()=>{
 const report=jobEvidence([{id:1,name:'Scan',steps:[{number:1,name:'Run Gitleaks',conclusion:'failure',started_at:'2026-10-11T00:00:00Z',completed_at:'2026-10-11T00:00:02Z'},{number:2,name:'Later step',conclusion:'skipped'}]}],{sha:'a'.repeat(40),gate:'FAILURE',title:'Secret scan'});
 assert.equal(report.inventoryKind,'workflow checks');assert.equal(report.counts.FAIL,1);assert.equal(report.counts.SKIP,1);assert.equal(report.results[0].durationMs,2000);assert.equal(report.results[0].category,'WORKFLOW_STEP');assert(!report.note.includes('confirmed vulnerability'));
});
test('every included workflow keeps its original jobs and adds always reporting/downloads',async()=>{
 for(const name of Object.keys(profiles)){const text=await readFile('.github/workflows/'+name,'utf8');assert(text.includes('uses: ./.github/workflows/vocle-reporting.yml'),name);assert(text.includes('if: always()'),name);assert(text.includes('original_jobs: ${{ toJSON(needs) }}'),name);}
 const excluded=await readFile('.github/workflows/vocle-security-environment-test.yml','utf8');assert(!excluded.includes('vocle-reporting.yml'));
 const shared=await readFile('.github/workflows/vocle-reporting.yml','utf8');assert(shared.includes('steps.dashboard_upload.outputs.artifact-url'));assert(!shared.includes('secrets: inherit'));
});

test('expanded security reports redact device token arrays, cookies and OTP hashes',()=>{const r=sanitize({fcmTokens:['opaque-sensitive'],cookie:'opaque-cookie',otpHash:'opaque-hash',log:'fcmTokens=opaque-log'});assert(!JSON.stringify(r).includes('opaque'));});

test('publication audit accepts escaped mask markers and still rejects exposed bearer values',()=>{
 const code = `import ast,re,sys
tree=ast.parse(open(sys.argv[1],encoding='utf-8').read())
patterns=[n.args[0].value for n in ast.walk(tree) if isinstance(n,ast.Call) and isinstance(n.func,ast.Attribute) and n.func.attr=='search' and n.args and isinstance(n.args[0],ast.Constant) and isinstance(n.args[0].value,str) and n.args[0].value.startswith('Bearer')]
assert len(patterns)==1
p=patterns[0]
for value in ['Bearer [REDACTED]',r'Bearer \\[REDACTED\\]','Bearer ***']: assert not re.search(p,value)
for value in ['Bearer synthetic-unmasked-value',r'Bearer \\[not-a-mask\\]']: assert re.search(p,value)
print('PASS')`;
 assert.equal(execFileSync(process.platform==='win32'?'python':'python3',['-c',code,'tests/reporting/verify-artifacts.py'],{encoding:'utf8',windowsHide:true}).trim(),'PASS');
});
