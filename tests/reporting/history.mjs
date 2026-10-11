// Optional read-only baseline lookup. It never supplies workflow skip/success evidence.
import { execFileSync } from 'node:child_process';
import { mkdtemp, writeFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { compare } from './report.mjs';

export async function api(path, token = process.env.GITHUB_TOKEN) {
  const response = await fetch('https://api.github.com/repos/Sriram4747/medcollab-beta-workflows' + path, { headers: { Accept: 'application/vnd.github+json', ...(token ? { Authorization: `Bearer ${token}` } : {}), 'X-GitHub-Api-Version': '2022-11-28' }, signal: AbortSignal.timeout(15000), redirect: 'manual' });
  if (!response.ok) throw new Error(`GitHub read-only API returned ${response.status}`);
  return response.json();
}
export async function artifactReports(id) {
  const response = await fetch(`https://api.github.com/repos/Sriram4747/medcollab-beta-workflows/actions/artifacts/${id}/zip`, { headers: { Authorization: `Bearer ${process.env.GITHUB_TOKEN}` }, redirect: 'manual', signal: AbortSignal.timeout(15000) });
  if (response.status !== 302) throw new Error(`Artifact read returned ${response.status}`);
  const url = new URL(response.headers.get('location'));
  if (url.protocol !== 'https:') throw new Error('Unsafe artifact redirect');
  const archive = await fetch(url, { signal: AbortSignal.timeout(30000) });
  if (!archive.ok) throw new Error(`Artifact storage returned ${archive.status}`);
  const dir = await mkdtemp(join(tmpdir(), 'vocle-report-'));
  try {
    const zip = join(dir, 'report.zip');
    await writeFile(zip, Buffer.from(await archive.arrayBuffer()));
    // Read exact JSON members, never extract arbitrary ZIP paths or execute content.
    const code = "import zipfile,json,sys\nwith zipfile.ZipFile(sys.argv[1]) as z:\n members=[n for n in z.namelist() if n.endswith('vocle-regression-results.json')]\n if len(members)>4: raise ValueError('Too many reports')\n print(json.dumps([json.loads(z.read(n)) for n in members if z.getinfo(n).file_size<30000000]))";
    return JSON.parse(execFileSync(process.platform === 'win32' ? 'python' : 'python3', ['-c', code, zip], { encoding: 'utf8', maxBuffer: 32 * 1024 * 1024, windowsHide: true }));
  } finally { await rm(dir, { recursive: true, force: true }); }
}
export async function priorCompatible(current) {
  if (!process.env.GITHUB_TOKEN || !process.env.GITHUB_RUN_ID) return null;
  const artifacts = await api('/actions/artifacts?per_page=100');
  const prefix = current.suite === 'sanity' ? 'vocle-sanity-diagnostics-' : current.suite === 'flutter' ? 'vocle-flutter-report-' : 'vocle-functional-report-';
  const candidates = artifacts.artifacts.filter(a => !a.expired && a.workflow_run?.id !== Number(process.env.GITHUB_RUN_ID) && a.name.startsWith(prefix)).slice(0, 3);
  for (const a of candidates) {
    const reports = await artifactReports(a.id);
    for (const p of reports) if (compare(current, p).available) return { report: p, artifactId: a.id, runId: a.workflow_run.id };
  }
  return null;
}
