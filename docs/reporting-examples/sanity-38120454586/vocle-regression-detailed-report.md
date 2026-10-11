# Vocle regression report

Artifact: **Vocle report artifact**. Download and extract it, then open `vocle-regression-dashboard.html` locally.

[GitHub Actions run](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38120454586)

Suite: sanity; scope: sanity; original gate: **failed**.

Source: `da2baff621fe03b21e614965bdb77510f32a62b9`; harness: `7c969b33068f811e006aac4cd130d5d95f0777f0`.

| PASS | FAIL | ERROR | BLOCKED | NEEDS_DECISION | SKIP |
| --- | --- | --- | --- | --- | --- |
| 42 | 2 | 0 | 4 | 0 | 0 |

Selected 48; recorded rows 48; attempted 44. Missing evidence never means PASS.



No compatible normalized baseline among the three most recent matching artifacts. This does not change existing workflow history/skip behavior.

Reporting does not change test exit codes, success-history evidence, assertions or original classifications. Definition/procedure text is not a per-step execution trace. Ownership requires an approved mapping. Procedure metadata was read from the reporter checkout 7c969b33068f811e006aac4cd130d5d95f0777f0; recorded execution revisions remain separate. Older evidence does not prove newly changed definitions passed.

## authentication-and-profiles-01 — Request OTP

**PASS**; module AUTH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 185 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor signs in or restores a session. Scenario: Request OTP; inspect hashed record; verify captured code; assert new verified user, access/refresh tokens and persisted identity..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Request OTP
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. inspect hashed record
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. verify captured code
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
4. assert new verified user, access/refresh tokens and persisted identity.
   Expected: Request OTP; inspect hashed record; verify captured code; assert new verified user, access/refresh tokens and persisted identity.

### Expected and observed results

Contract: Request OTP; inspect hashed record; verify captured code; assert new verified user, access/refresh tokens and persisted identity.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:36; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-01&#39;, async () =&gt; {
      await requestOtp(users.A);
      const stored = await newestOtp(users.A);
      assert(stored?.otpHash &amp;&amp; !/^\d{6}$/.test(stored.otpHash), &#39;OTP was not stored as a hash.&#39;);
      firstOtp = [REDACTED] latestOtp(users.A);
      firstAuth = await verifyOtp(users.A, firstOtp);
      assert(firstAuth.accessToken &amp;&amp; firstAuth.refreshToken &amp;&amp; firstAuth.isNewUser === true, &#39;First verification did not create usable tokens.&#39;);
      const persisted = await userByPhone(users.A);
      assert(persisted?.isVerified === true, &#39;Verified user was not persisted.&#39;);
    });</pre>

## authentication-and-profiles-02 — Request/verify again for same phone

**PASS**; module AUTH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 117 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor signs in or restores a session. Scenario: Request/verify again for same phone; assert same user ID and isNewUser=false..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Request/verify again for same phone
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. assert same user ID and isNewUser=false.
   Expected: Request/verify again for same phone; assert same user ID and isNewUser=false.

### Expected and observed results

Contract: Request/verify again for same phone; assert same user ID and isNewUser=false.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:47; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-02&#39;, async () =&gt; {
      await requestOtp(users.A);
      const auth = await verifyOtp(users.A, await latestOtp(users.A));
      assert(auth.isNewUser === false &amp;&amp; auth.user._id === firstAuth.user._id, &#39;Returning login did not preserve identity.&#39;);
    });</pre>

## authentication-and-profiles-03 — Submit wrong code then correct captured code

**PASS**; module AUTH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 173 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor signs in or restores a session. Scenario: Submit wrong code then correct captured code; first rejects, second yields token..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Submit wrong code then correct captured code
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. first rejects, second yields token.
   Expected: Submit wrong code then correct captured code; first rejects, second yields token.

### Expected and observed results

Contract: Submit wrong code then correct captured code; first rejects, second yields token.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:53; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-03&#39;, async () =&gt; {
      await requestOtp(users.B);
      const otp = [REDACTED] latestOtp(users.B);
      await verifyOtp(users.B, &#39;[SIX-DIGIT CODE REDACTED]&#39;, 400);
      const auth = await verifyOtp(users.B, otp);
      assert(auth.accessToken, &#39;Correct OTP did not work after an incorrect attempt.&#39;);
    });</pre>

## authentication-and-profiles-04 — Reuse consumed code

**PASS**; module AUTH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 4 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor signs in or restores a session. Scenario: Reuse consumed code; reject and do not create another user..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Reuse consumed code
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. reject and do not create another user.
   Expected: Reuse consumed code; reject and do not create another user.

### Expected and observed results

Contract: Reuse consumed code; reject and do not create another user.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:61; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-04&#39;, async () =&gt; {
      await verifyOtp(users.A, firstOtp, 400);
    });</pre>

## authentication-and-profiles-05 — Update onboarding name/institution

**PASS**; module PRO; tier B; priority P0; owner UNASSIGNED; attempted true; duration 11 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor edits their profile and preferences. Scenario: Update onboarding name/institution; GET me; assert onboarded and exact profile values..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Update onboarding name/institution
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. GET me
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. assert onboarded and exact profile values.
   Expected: Update onboarding name/institution; GET me; assert onboarded and exact profile values.

### Expected and observed results

Contract: Update onboarding name/institution; GET me; assert onboarded and exact profile values.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:65; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-05&#39;, async () =&gt; {
      const update = expectSuccess(await request(&#39;/api/users/me&#39;, {
        method: &#39;PUT&#39;, token: [REDACTED],
        body: { name: &#39;Dr Sanity A&#39;, institution: &#39;Vocle Sanity Institute&#39;, speciality: &#39;Sanity Medicine&#39; },
      }), &#39;onboard profile&#39;);
      assert(update.user.isOnboarded === true, &#39;Profile update did not unlock onboarding.&#39;);
      const me = expectSuccess(await request(&#39;/api/users/me&#39;, { token: [REDACTED] }), &#39;read updated profile&#39;);
      assert(me.user.name === &#39;Dr Sanity A&#39; &amp;&amp; me.user.institution === &#39;Vocle Sanity Institute&#39;, &#39;Profile changes did not persist.&#39;);
    });</pre>

## authentication-and-profiles-06 — Refresh with missing token then valid token

**PASS**; module AUTH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 7 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor signs in or restores a session. Scenario: Refresh with missing token then valid token; missing gives 401; use returned access token on me..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Refresh with missing token then valid token
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. missing gives 401
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. use returned access token on me.
   Expected: Refresh with missing token then valid token; missing gives 401; use returned access token on me.

### Expected and observed results

Contract: Refresh with missing token then valid token; missing gives 401; use returned access token on me.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:75; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-06&#39;, async () =&gt; {
      await request(&#39;/api/auth/refresh&#39;, { method: &#39;POST&#39;, body: {}, expectedStatus: 401 });
      const refreshed = expectSuccess(await request(&#39;/api/auth/refresh&#39;, { method: &#39;POST&#39;, body: { refreshToken: [REDACTED] } }), &#39;refresh token&#39;);
      assert(refreshed.accessToken, &#39;Refresh did not issue an access token.&#39;);
      expectSuccess(await request(&#39;/api/users/me&#39;, { token: [REDACTED] }), &#39;use refreshed access token&#39;);
    });</pre>

## authentication-and-profiles-07 — Register device twice

**PASS**; module AUTH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 18 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor signs in or restores a session. Scenario: Register device twice; DB has one token; logout removes it; fake widget-token exchange returns access token..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Register device twice
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. DB has one token
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. logout removes it
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
4. fake widget-token exchange returns access token.
   Expected: Register device twice; DB has one token; logout removes it; fake widget-token exchange returns access token.

### Expected and observed results

Contract: Register device twice; DB has one token; logout removes it; fake widget-token exchange returns access token.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/authentication-scenarios.js:82; SHA-256 e3a9913b3f2780f15bf6b4ef3840b9f1658b7f23df86a15ac44f7b8500e736dd

<pre>    await scenario(&#39;authentication-and-profiles-07&#39;, async () =&gt; {
      const device = &#39;[SYNTHETIC CREDENTIAL REDACTED]&#39;;
      await request(&#39;/api/users/me/fcm-token&#39;, { method: &#39;PUT&#39;, token: [REDACTED], body: { token: [REDACTED] } });
      await request(&#39;/api/users/me/fcm-token&#39;, { method: &#39;PUT&#39;, token: [REDACTED], body: { token: [REDACTED] } });
      assert((await userByPhone(users.A)).fcmTokens.filter((value) =&gt; value === device).length === 1, &#39;FCM registration was not deduplicated.&#39;);
      await request(&#39;/api/auth/logout&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { fcmToken: [REDACTED] } });
      assert(!(await userByPhone(users.A)).fcmTokens.includes(device), &#39;Logout did not remove the registered device.&#39;);
      const widget = expectSuccess(await request(&#39;/api/auth/verify-msg91-token&#39;, {
        method: &#39;POST&#39;, body: { phone: users.E, accessToken: [REDACTED];[REDACTED]&#39; },
      }), &#39;widget verification&#39;);
      assert(widget.accessToken, &#39;Widget verification did not issue an access token.&#39;);
    });
  } finally {
    await closeDatabase();
  }
  const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;);
  await mkdir(output, { recursive: true });
  await writeFile(resolve(output, &#39;authentication-results.json&#39;), `${JSON.stringify({ expected: 7, results }, null, 2)}\n`);
  console.log(&#39;Authentication scenarios passed: 7/7.&#39;);
}

run().catch(async (error) =&gt; {
  console.error(error.stack || error.message);
  await closeDatabase();
  process.exitCode = [REDACTED];
});
</pre>

## spaces-and-invitations-01 — Create department space

**PASS**; module SPC; tier B; priority P0; owner UNASSIGNED; attempted true; duration 10 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors create and manage membership in a department space. Scenario: Create department space; assert owner membership and general/emergency/academics defaults..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Create department space
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. assert owner membership and general/emergency/academics defaults.
   Expected: Create department space; assert owner membership and general/emergency/academics defaults.

### Expected and observed results

Contract: Create department space; assert owner membership and general/emergency/academics defaults.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:22; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;spaces-and-invitations-01&#39;, async () =&gt; {
      const data = expectSuccess(await request(&#39;/api/spaces&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { name: &#39;Sanity Main Space&#39;, type: &#39;department&#39;, description: &#39;Synthetic suite space&#39; }, expectedStatus: 201 }), &#39;create space&#39;);
      space = data.space;
      assert(data.channels.length === 3 &amp;&amp; data.channels.map((channel) =&gt; channel.name).join(&#39;,&#39;) === &#39;general,emergency,academics&#39;, &#39;New space did not contain exactly the three default channels.&#39;);
      general = data.channels.find((channel) =&gt; channel.name === &#39;general&#39;);
    });</pre>

## spaces-and-invitations-02 — Preview invite as B

**PASS**; module SPC; tier B; priority P0; owner UNASSIGNED; attempted true; duration 24 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors create and manage membership in a department space. Scenario: Preview invite as B; join; GET spaces/detail/members; assert B membership and returned channels..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Preview invite as B
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. join
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. GET spaces/detail/members
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
4. assert B membership and returned channels.
   Expected: Preview invite as B; join; GET spaces/detail/members; assert B membership and returned channels.

### Expected and observed results

Contract: Preview invite as B; join; GET spaces/detail/members; assert B membership and returned channels.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:28; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;spaces-and-invitations-02&#39;, async () =&gt; {
      const preview = expectSuccess(await request(`/api/spaces/invite/${space.inviteCode}`, { token: [REDACTED] }), &#39;preview invitation&#39;);
      assert(preview.invite.name === space.name &amp;&amp; preview.invite.alreadyMember === false, &#39;Invitation preview was incorrect.&#39;);
      await request(&#39;/api/spaces/join&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { inviteCode: [REDACTED] } });
      const [list, detail, members] = await Promise.all([
        request(&#39;/api/spaces&#39;, { token: [REDACTED] }), request(`/api/spaces/${space._id}`, { token: [REDACTED] }), request(`/api/spaces/${space._id}/members`, { token: [REDACTED] }),
      ]);
      assert(expectSuccess(list, &#39;space list&#39;).spaces.some((item) =&gt; item._id === space._id), &#39;Joined space missing from list.&#39;);
      assert(expectSuccess(detail, &#39;space detail&#39;).space._id === space._id, &#39;Joined space detail missing.&#39;);
      assert(expectSuccess(members, &#39;members&#39;).members.length === 2, &#39;Member list did not reflect invitation join.&#39;);
    });</pre>

## spaces-and-invitations-03 — Repeat B join

**PASS**; module SPC; tier B; priority P0; owner UNASSIGNED; attempted true; duration 7 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors create and manage membership in a department space. Scenario: Repeat B join; expect 409 without duplicate membership..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Repeat B join
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. expect 409 without duplicate membership.
   Expected: Repeat B join; expect 409 without duplicate membership.

### Expected and observed results

Contract: Repeat B join; expect 409 without duplicate membership.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:39; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;spaces-and-invitations-03&#39;, async () =&gt; {
      await request(&#39;/api/spaces/join&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { inviteCode: [REDACTED] }, expectedStatus: 409 });
      const members = expectSuccess(await request(`/api/spaces/${space._id}/members`, { token: [REDACTED] }), &#39;members after duplicate join&#39;);
      assert(members.members.length === 2, &#39;Duplicate join created another membership.&#39;);
    });</pre>

## spaces-and-invitations-04 — Rename S2 and rotate invite

**PASS**; module SPC; tier B; priority P0; owner UNASSIGNED; attempted true; duration 12 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors create and manage membership in a department space. Scenario: Rename S2 and rotate invite; reread name/new code; old invite preview gives 404..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Rename S2 and rotate invite
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. reread name/new code
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. old invite preview gives 404.
   Expected: Rename S2 and rotate invite; reread name/new code; old invite preview gives 404.

### Expected and observed results

Contract: Rename S2 and rotate invite; reread name/new code; old invite preview gives 404.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:44; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;spaces-and-invitations-04&#39;, async () =&gt; {
      const renamed = expectSuccess(await request(`/api/spaces/${space._id}`, { method: &#39;PUT&#39;, token: [REDACTED], body: { name: &#39;Sanity Renamed Space&#39; } }), &#39;rename space&#39;);
      const oldCode = [REDACTED];
      const regenerated = expectSuccess(await request(`/api/spaces/${space._id}/invite`, { method: &#39;POST&#39;, token: [REDACTED] }), &#39;regenerate invite&#39;);
      assert(renamed.space.name === &#39;Sanity Renamed Space&#39; &amp;&amp; regenerated.inviteCode !== oldCode, &#39;Space rename or invitation regeneration did not persist.&#39;);
      await request(`/api/spaces/invite/${oldCode}`, { token: [REDACTED], expectedStatus: 404 });
      space = { ...space, inviteCode: [REDACTED] };
    });</pre>

## spaces-and-invitations-05 — B leaves, owner removes C, owner tries leaving

**PASS**; module SPC; tier B; priority P0; owner UNASSIGNED; attempted true; duration 22 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors create and manage membership in a department space. Scenario: B leaves, owner removes C, owner tries leaving; final list only A, owner leave gives 400..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. B leaves, owner removes C, owner tries leaving
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. final list only A, owner leave gives 400.
   Expected: B leaves, owner removes C, owner tries leaving; final list only A, owner leave gives 400.

### Expected and observed results

Contract: B leaves, owner removes C, owner tries leaving; final list only A, owner leave gives 400.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:52; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;spaces-and-invitations-05&#39;, async () =&gt; {
      await request(&#39;/api/spaces/join&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { inviteCode: [REDACTED] } });
      await request(`/api/spaces/${space._id}/leave`, { method: &#39;POST&#39;, token: [REDACTED] });
      await request(`/api/spaces/${space._id}/members/${people.B.userId}`, { method: &#39;DELETE&#39;, token: [REDACTED] });
      await request(`/api/spaces/${space._id}/leave`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 400 });
      assert(expectSuccess(await request(`/api/spaces/${space._id}/members`, { token: [REDACTED] }), &#39;members after leave/remove&#39;).members.length === 1, &#39;Membership lifecycle did not persist.&#39;);
    });</pre>

## channels-01 — Create public channel, duplicate create gives 409, rename

**PASS**; module CH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 16 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors access and manage the channels they are permitted to use. Scenario: Create public channel, duplicate create gives 409, rename; mutation response contains new name..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Create public channel, duplicate create gives 409, rename
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. mutation response contains new name.
   Expected: Create public channel, duplicate create gives 409, rename; mutation response contains new name.

### Expected and observed results

Contract: Create public channel, duplicate create gives 409, rename; mutation response contains new name.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:59; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;channels-01&#39;, async () =&gt; {
      custom = expectSuccess(await request(`/api/spaces/${space._id}/channels`, { method: &#39;POST&#39;, token: [REDACTED], body: { name: &#39;sanity-rounds&#39;, description: &#39;Synthetic channel&#39; }, expectedStatus: 201 }), &#39;create public channel&#39;).channel;
      await request(`/api/spaces/${space._id}/channels`, { method: &#39;POST&#39;, token: [REDACTED], body: { name: &#39;sanity-rounds&#39; }, expectedStatus: 409 });
      const updated = expectSuccess(await request(`/api/channels/${custom._id}`, { method: &#39;PUT&#39;, token: [REDACTED], body: { name: &#39;sanity-updated&#39; } }), &#39;update public channel&#39;);
      assert(updated.channel.name === &#39;sanity-updated&#39;, &#39;Public channel update did not persist.&#39;);
    });</pre>

## channels-02 — Create private channel as A

**PASS**; module CH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 11 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors access and manage the channels they are permitted to use. Scenario: Create private channel as A; GET creator detail returns same ID..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Create private channel as A
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. GET creator detail returns same ID.
   Expected: Create private channel as A; GET creator detail returns same ID.

### Expected and observed results

Contract: Create private channel as A; GET creator detail returns same ID.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:65; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;channels-02&#39;, async () =&gt; {
      const privateChannel = expectSuccess(await request(`/api/spaces/${space._id}/channels`, { method: &#39;POST&#39;, token: [REDACTED], body: { name: &#39;sanity-private&#39;, isPrivate: true }, expectedStatus: 201 }), &#39;create private channel&#39;).channel;
      assert(expectSuccess(await request(`/api/channels/${privateChannel._id}`, { token: [REDACTED] }), &#39;read private channel&#39;).channel._id === privateChannel._id, &#39;Private creator access failed.&#39;);
    });</pre>

## channels-03 — Send in custom channel, archive

**PASS**; module CH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 31 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors access and manage the channels they are permitted to use. Scenario: Send in custom channel, archive; messages retained in DB, message GET gives 403, active list excludes channel; default archive gives 400..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Send in custom channel, archive
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. messages retained in DB, message GET gives 403, active list excludes channel
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. default archive gives 400.
   Expected: Send in custom channel, archive; messages retained in DB, message GET gives 403, active list excludes channel; default archive gives 400.

### Expected and observed results

Contract: Send in custom channel, archive; messages retained in DB, message GET gives 403, active list excludes channel; default archive gives 400.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/spaces-and-channels-scenarios.js:69; SHA-256 dc2dec587c32d3f89ad0c6918e170caa8b06d809edef8548a999ef9c442e4dd1

<pre>    await scenario(&#39;channels-03&#39;, async () =&gt; {
      const message = expectSuccess(await request(`/api/channels/${custom._id}/messages`, { method: &#39;POST&#39;, token: [REDACTED], body: { type: &#39;text&#39;, content: { text: &#39;archive retention marker&#39; } }, expectedStatus: 201 }), &#39;send retained channel message&#39;).message;
      await request(`/api/channels/${custom._id}`, { method: &#39;DELETE&#39;, token: [REDACTED] });
      await request(`/api/channels/${custom._id}/messages`, { token: [REDACTED], expectedStatus: 403 });
      assert((await messageById(message._id))?.content?.text === &#39;archive retention marker&#39;, &#39;Archiving removed stored channel messages.&#39;);
      const listed = expectSuccess(await request(`/api/spaces/${space._id}/channels`, { token: [REDACTED] }), &#39;list active channels&#39;);
      assert(!listed.channels.some((item) =&gt; item._id === custom._id), &#39;Archived channel remains in active lists.&#39;);
      await request(`/api/channels/${general._id}`, { method: &#39;DELETE&#39;, token: [REDACTED], expectedStatus: 400 });
    });
  } finally {
    await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;);
    await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;spaces-and-channels-results.json&#39;), `${JSON.stringify({ expected: 8, results }, null, 2)}\n`);
  }
  console.log(&#39;Spaces and channel scenarios passed: 8/8.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## messaging-and-needl-01 — Send text A→general

**PASS**; module MSG; tier B; priority P0; owner UNASSIGNED; attempted true; duration 30 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor sends or changes a channel message. Scenario: Send text A→general; B reads text/sender; detail contains matching lastMessage preview..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Send text A→general
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. B reads text/sender
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. detail contains matching lastMessage preview.
   Expected: Send text A→general; B reads text/sender; detail contains matching lastMessage preview.

### Expected and observed results

Contract: Send text A→general; B reads text/sender; detail contains matching lastMessage preview.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:39; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-01&#39;, async () =&gt; {
      const event = clientB.waitFor(&#39;new_message&#39;, (payload) =&gt; payload?.content?.text === marker(&#39;text&#39;));
      const message = await send(general._id, people.A.token, marker(&#39;text&#39;));
      root = message;
      const delivered = await event;
      const listing = expectSuccess(await request(`/api/channels/${general._id}/messages`, { token: [REDACTED] }), &#39;read text message&#39;);
      const sidebar = expectSuccess(await request(&#39;/api/spaces&#39;, { token: [REDACTED] }), &#39;read sidebar&#39;);
      const listedChannel = sidebar.spaces.flatMap((item) =&gt; item.channels || []).find((channel) =&gt; channel._id === general._id);
      assert(message.senderId._id === people.A.userId &amp;&amp; delivered._id === message._id, &#39;Text message sender or socket payload was incorrect.&#39;);
      assert(listing.messages.some((item) =&gt; item._id === message._id), &#39;Sent text was not readable.&#39;);
      assert(listedChannel?.lastMessage?.text === marker(&#39;text&#39;), &#39;Sidebar preview did not persist.&#39;);
    });</pre>

## messaging-and-needl-02 — Send three roots

**PASS**; module MSG; tier B; priority P0; owner UNASSIGNED; attempted true; duration 51 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor sends or changes a channel message. Scenario: Send three roots; page limit=2 then before cursor; ordered roots have no overlap..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Send three roots
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. page limit=2 then before cursor
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. ordered roots have no overlap.
   Expected: Send three roots; page limit=2 then before cursor; ordered roots have no overlap.

### Expected and observed results

Contract: Send three roots; page limit=2 then before cursor; ordered roots have no overlap.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:52; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-02&#39;, async () =&gt; {
      await send(general._id, people.A.token, marker(&#39;page-one&#39;));
      await send(general._id, people.A.token, marker(&#39;page-two&#39;));
      await send(general._id, people.A.token, marker(&#39;page-three&#39;));
      const newest = expectSuccess(await request(`/api/channels/${general._id}/messages?limit=2`, { token: [REDACTED] }), &#39;first pagination page&#39;);
      const older = expectSuccess(await request(`/api/channels/${general._id}/messages?limit=2&amp;before=${newest.messages[0]._id}`, { token: [REDACTED] }), &#39;older pagination page&#39;);
      const combined = [...older.messages, ...newest.messages];
      assert(newest.messages.length === 2 &amp;&amp; older.messages.length &gt; 0, &#39;Pagination did not produce two pages.&#39;);
      assert(new Set(combined.map((item) =&gt; item._id)).size === combined.length, &#39;Pagination pages overlapped.&#39;);
      assert(combined.every((item, index) =&gt; index === 0 || item._id &gt; combined[index - 1]._id), &#39;Paginated roots were not ascending.&#39;);
    });</pre>

## messaging-and-needl-03 — Quote prior message via replyToId

**PASS**; module MSG; tier B; priority P0; owner UNASSIGNED; attempted true; duration 8 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor sends or changes a channel message. Scenario: Quote prior message via replyToId; assert mutation response replyTo ID/text; independent persistence is added in FR-MSG-03..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Quote prior message via replyToId
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. assert mutation response replyTo ID/text
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. independent persistence is added in FR-MSG-03.
   Expected: Quote prior message via replyToId; assert mutation response replyTo ID/text; independent persistence is added in FR-MSG-03.

### Expected and observed results

Contract: Quote prior message via replyToId; assert mutation response replyTo ID/text; independent persistence is added in FR-MSG-03.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:64; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-03&#39;, async () =&gt; {
      const quoted = await send(general._id, people.B.token, marker(&#39;quote&#39;), { replyToId: root._id });
      assert(quoted.replyTo?.messageId === root._id &amp;&amp; quoted.replyTo?.text === marker(&#39;text&#39;), &#39;Quote metadata was not retained.&#39;);
    });</pre>

## messaging-and-needl-04 — Reply to root

**PASS**; module THR; tier B; priority P0; owner UNASSIGNED; attempted true; duration 33 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors follow replies to a message and find them in Needl. Scenario: Reply to root; immediately read root count/lastReply, thread and Needl; assert root/reply. This immediate read can race asynchronous updates..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Reply to root
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. immediately read root count/lastReply, thread and Needl
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. assert root/reply. This immediate read can race asynchronous updates.
   Expected: Reply to root; immediately read root count/lastReply, thread and Needl; assert root/reply. This immediate read can race asynchronous updates.

### Expected and observed results

Contract: Reply to root; immediately read root count/lastReply, thread and Needl; assert root/reply. This immediate read can race asynchronous updates.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:69; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-04&#39;, async () =&gt; {
      const reply = expectSuccess(await request(`/api/channels/${general._id}/messages/${root._id}/reply`, {
        method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: { type: &#39;text&#39;, content: { text: marker(&#39;thread-reply&#39;) } },
      }), &#39;reply to thread&#39;).message;
      const thread = expectSuccess(await request(`/api/channels/${general._id}/messages/${root._id}/thread`, { token: [REDACTED] }), &#39;read thread&#39;);
      const needl = expectSuccess(await request(&#39;/api/users/me/needl&#39;, { token: [REDACTED] }), &#39;read Needl&#39;);
      const refreshed = (await request(`/api/channels/${general._id}/messages?limit=100`, { token: [REDACTED] }));
      const refreshedRoot = expectSuccess(refreshed, &#39;read refreshed roots&#39;).messages.find((item) =&gt; item._id === root._id);
      assert(reply.threadId === root._id &amp;&amp; thread.replies.some((item) =&gt; item._id === reply._id), &#39;Thread reply was not returned by thread endpoint.&#39;);
      assert(refreshedRoot?.replyCount === 1 &amp;&amp; refreshedRoot.lastReply?.text === marker(&#39;thread-reply&#39;), &#39;Thread root preview did not update.&#39;);
      assert(needl.threads.some((item) =&gt; item.rootMessageId === root._id), &#39;Needl omitted the relevant thread root.&#39;);
    });</pre>

## messaging-and-needl-05 — Subscribe, edit text, delete it

**PASS**; module MSG; tier B; priority P0; owner UNASSIGNED; attempted true; duration 32 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor sends or changes a channel message. Scenario: Subscribe, edit text, delete it; assert update/delete events and soft-deleted DB state..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Subscribe, edit text, delete it
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. assert update/delete events and soft-deleted DB state.
   Expected: Subscribe, edit text, delete it; assert update/delete events and soft-deleted DB state.

### Expected and observed results

Contract: Subscribe, edit text, delete it; assert update/delete events and soft-deleted DB state.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:82; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-05&#39;, async () =&gt; {
      const editable = await send(general._id, people.A.token, marker(&#39;before-edit&#39;));
      const updatedEvent = clientB.waitFor(&#39;message_updated&#39;, (payload) =&gt; payload?.messageId === editable._id &amp;&amp; payload?.isEdited === true);
      const edited = expectSuccess(await request(`/api/channels/${general._id}/messages/${editable._id}`, {
        method: &#39;PUT&#39;, token: [REDACTED], body: { content: { text: marker(&#39;after-edit&#39;) } },
      }), &#39;edit message&#39;).message;
      await updatedEvent;
      const deletedEvent = clientB.waitFor(&#39;message_deleted&#39;, (payload) =&gt; payload?.messageId === editable._id);
      await request(`/api/channels/${general._id}/messages/${editable._id}`, { method: &#39;DELETE&#39;, token: [REDACTED] });
      await deletedEvent;
      const stored = await messageById(editable._id);
      assert(edited.isEdited === true &amp;&amp; edited.content.text === marker(&#39;after-edit&#39;), &#39;Edit was not persisted.&#39;);
      assert(stored?.isDeleted === true, &#39;Delete was not a persisted soft deletion.&#39;);
    });</pre>

## messaging-and-needl-06 — Toggle reaction on/off

**PASS**; module SOC; tier B; priority P0; owner UNASSIGNED; attempted true; duration 36 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors react, pin or acknowledge reading messages. Scenario: Toggle reaction on/off; pin/unpin; assert response reaction and pin arrays; independent persistence added under FR-SOC..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Toggle reaction on/off
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. pin/unpin
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. assert response reaction and pin arrays
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
4. independent persistence added under FR-SOC.
   Expected: Toggle reaction on/off; pin/unpin; assert response reaction and pin arrays; independent persistence added under FR-SOC.

### Expected and observed results

Contract: Toggle reaction on/off; pin/unpin; assert response reaction and pin arrays; independent persistence added under FR-SOC.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:97; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-06&#39;, async () =&gt; {
      const reacted = await send(general._id, people.A.token, marker(&#39;react&#39;));
      const first = expectSuccess(await request(`/api/channels/${general._id}/messages/${reacted._id}/react`, { method: &#39;POST&#39;, token: [REDACTED], body: { emoji: &#39;👍&#39; } }), &#39;add reaction&#39;);
      const second = expectSuccess(await request(`/api/channels/${general._id}/messages/${reacted._id}/react`, { method: &#39;POST&#39;, token: [REDACTED], body: { emoji: &#39;👍&#39; } }), &#39;remove reaction&#39;);
      const pinned = expectSuccess(await request(`/api/channels/${general._id}/pin/${reacted._id}`, { method: &#39;POST&#39;, token: [REDACTED] }), &#39;pin message&#39;);
      const unpinned = expectSuccess(await request(`/api/channels/${general._id}/pin/${reacted._id}`, { method: &#39;DELETE&#39;, token: [REDACTED] }), &#39;unpin message&#39;);
      assert(first.reactions.some((reaction) =&gt; reaction.emoji === &#39;👍&#39;), &#39;Reaction was not added.&#39;);
      assert(!second.reactions.some((reaction) =&gt; reaction.emoji === &#39;👍&#39;) &amp;&amp; pinned.pinnedMessages.length === 1 &amp;&amp; unpinned.pinnedMessages.length === 0, &#39;Reaction toggle or pin lifecycle did not persist.&#39;);
    });</pre>

## messaging-and-needl-07 — Empty text fails

**PASS**; module MSG; tier B; priority P0; owner UNASSIGNED; attempted true; duration 12 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor sends or changes a channel message. Scenario: Empty text fails; send normal-priority text in emergency channel; stored priority is emergency..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Empty text fails
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. send normal-priority text in emergency channel
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. stored priority is emergency.
   Expected: Empty text fails; send normal-priority text in emergency channel; stored priority is emergency.

### Expected and observed results

Contract: Empty text fails; send normal-priority text in emergency channel; stored priority is emergency.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/messaging-scenarios.js:107; SHA-256 3eb085c0c81eb2d9baf64fcfa6353a4a2777caa5a1e8ed333e8370c135e021cc

<pre>    await scenario(&#39;messaging-and-needl-07&#39;, async () =&gt; {
      await request(`/api/channels/${general._id}/messages`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 400, body: { type: &#39;text&#39;, content: { text: &#39;&#39; } } });
      const message = await send(emergency._id, people.A.token, marker(&#39;emergency&#39;), { priority: &#39;normal&#39; });
      assert(message.priority === &#39;emergency&#39;, &#39;Emergency channel did not override message priority.&#39;);
    });
  } finally {
    closeRealtime(clientA); closeRealtime(clientB); await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;);
    await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;messaging-results.json&#39;), `${JSON.stringify({ expected: 7, results }, null, 2)}\n`);
  }
  console.log(&#39;Messaging scenarios passed: 7/7.&#39;);
}

run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## message-requests-01 — Enable D requests

**FAIL**; module REQ; tier B; priority P0; owner UNASSIGNED; attempted true; duration 5108 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors request permission to start a private conversation. Scenario: Enable D requests; lookup, create/repeat A→D, read both directions/count; same request ID and recipient notification. Historical FAIL..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Enable D requests
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. lookup, create/repeat A→D, read both directions/count
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. same request ID and recipient notification. Historical FAIL.
   Expected: Enable D requests; lookup, create/repeat A→D, read both directions/count; same request ID and recipient notification. Historical FAIL.

### Expected and observed results

Contract: Enable D requests; lookup, create/repeat A→D, read both directions/count; same request ID and recipient notification. Historical FAIL.

Observed: Recipient message-request notification was not persisted within 5 seconds (request state was persisted).

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: APPLICATION_DEFECT_RECORDED

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described Message requests/consent scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>Recipient message-request notification was not persisted within 5 seconds (request state was persisted).</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:45; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;message-requests-01&#39;, async () =&gt; {
      const lookup = expectSuccess(await request(`/api/users/lookup?phone=${encodeURIComponent(people.D.phone)}`, { token: [REDACTED] }), &#39;lookup eligible peer&#39;);
      assert(lookup.canRequest === true &amp;&amp; lookup.canMessage === false, &#39;Lookup did not identify a request-eligible peer.&#39;);
      const created = expectSuccess(await request(&#39;/api/message-requests&#39;, {
        method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: { toUserId: people.D.userId, introMessage: marker(&#39;intro&#39;) },
      }), &#39;create message request&#39;);
      acceptedRequest = created.request;
      const duplicate = expectSuccess(await request(&#39;/api/message-requests&#39;, {
        method: &#39;POST&#39;, token: [REDACTED], body: { toUserId: people.D.userId, introMessage: marker(&#39;intro&#39;) },
      }), &#39;repeat message request&#39;);
      const [sent, received, pending] = await Promise.all([
        request(&#39;/api/message-requests?direction=sent&#39;, { token: [REDACTED] }),
        request(&#39;/api/message-requests?direction=received&#39;, { token: [REDACTED] }),
        request(&#39;/api/message-requests/pending-count&#39;, { token: [REDACTED] }),
      ]);
      const notification = await eventuallyNotification(&#39;Recipient message-request notification&#39;, people.D.userId, acceptedRequest.id);
      assert(duplicate.request.id === acceptedRequest.id, &#39;Duplicate request was not stable.&#39;);
      assert(expectSuccess(sent, &#39;sent requests&#39;).requests.some((item) =&gt; item.id === acceptedRequest.id), &#39;Sent request was missing.&#39;);
      assert(expectSuccess(received, &#39;received requests&#39;).requests.some((item) =&gt; item.id === acceptedRequest.id), &#39;Received request was missing.&#39;);
      assert(expectSuccess(pending, &#39;pending count&#39;).count === 1, &#39;Pending request count was incorrect.&#39;);
      assert(notification?.type === &#39;message_request&#39; &amp;&amp; notification.referenceType === &#39;MessageRequest&#39;, &#39;Recipient notification was not persisted.&#39;);
    });</pre>

## message-requests-02 — D accepts preceding request

**FAIL**; module REQ; tier B; priority P0; owner UNASSIGNED; attempted true; duration 10 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctor A sends a request to fictional Doctor D, who has opted in. Doctor D accepts it. Both doctors should see the same private conversation, and Doctor A should receive an acceptance notification naming that conversation.

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. D accepts preceding request
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. assert accepted, DM listed for both, peer=A, sender acceptance notification names channel. Historical FAIL.
   Expected: D accepts preceding request; assert accepted, DM listed for both, peer=A, sender acceptance notification names channel. Historical FAIL.

### Expected and observed results

Contract: D accepts preceding request; assert accepted, DM listed for both, peer=A, sender acceptance notification names channel. Historical FAIL.

Observed: POST /api/message-requests/6acb369ddf5ac528c1440e7d/accept expected 200, received 500: {&quot;success&quot;:false,&quot;message&quot;:&quot;Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path &#39;members&#39; is matched twice&quot;,&quot;errors&quot;:[]}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: APPLICATION_DEFECT_RECORDED

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described Message requests/consent scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>POST /api/message-requests/6acb369ddf5ac528c1440e7d/accept expected 200, received 500: {&quot;success&quot;:false,&quot;message&quot;:&quot;Plan executor error during findAndModify :: caused by :: cannot infer query fields to set, path &#39;members&#39; is matched twice&quot;,&quot;errors&quot;:[]}</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:68; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;message-requests-02&#39;, async () =&gt; {
      const accepted = expectSuccess(await request(`/api/message-requests/${acceptedRequest.id}/accept`, { method: &#39;POST&#39;, token: [REDACTED] }), &#39;accept request&#39;);
      dm = accepted.channel;
      const [fromList, toList] = await Promise.all([
        request(&#39;/api/channels/dm&#39;, { token: [REDACTED] }), request(&#39;/api/channels/dm&#39;, { token: [REDACTED] }),
      ]);
      const notification = await eventuallyNotification(&#39;Sender request-acceptance notification&#39;, people.A.userId, acceptedRequest.id);
      assert(accepted.request.status === &#39;accepted&#39; &amp;&amp; dm?.peer?._id === people.A.userId, &#39;Accepted request did not create the expected DM.&#39;);
      assert(expectSuccess(fromList, &#39;sender DM list&#39;).channels.some((channel) =&gt; channel._id === dm._id), &#39;Accepted DM missing for sender.&#39;);
      assert(expectSuccess(toList, &#39;recipient DM list&#39;).channels.some((channel) =&gt; channel._id === dm._id), &#39;Accepted DM missing for recipient.&#39;);
      assert(notification?.metadata?.channelId?.toString() === dm._id, &#39;Acceptance notification was not persisted for sender.&#39;);
    }, Boolean(acceptedRequest));</pre>

## message-requests-03 — Create separate A→E eligible request

**PASS**; module REQ; tier B; priority P0; owner UNASSIGNED; attempted true; duration 22 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors request permission to start a private conversation. Scenario: Create separate A→E eligible request; E declines; count decreases and repeated terminal action rejects..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Create separate A→E eligible request
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. E declines
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. count decreases and repeated terminal action rejects.
   Expected: Create separate A→E eligible request; E declines; count decreases and repeated terminal action rejects.

### Expected and observed results

Contract: Create separate A→E eligible request; E declines; count decreases and repeated terminal action rejects.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:81; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;message-requests-03&#39;, async () =&gt; {
      const declined = expectSuccess(await request(&#39;/api/message-requests&#39;, {
        method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: { toUserId: people.E.userId, introMessage: marker(&#39;decline&#39;) },
      }), &#39;create disposable request&#39;).request;
      const declinedResult = expectSuccess(await request(`/api/message-requests/${declined.id}/decline`, { method: &#39;POST&#39;, token: [REDACTED] }), &#39;decline request&#39;);
      await request(`/api/message-requests/${declined.id}/decline`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 400 });
      const count = expectSuccess(await request(&#39;/api/message-requests/pending-count&#39;, { token: [REDACTED] }), &#39;pending count after decline&#39;);
      assert(declinedResult.request.status === &#39;declined&#39; &amp;&amp; count.count === 0, &#39;Declining a request did not finish its lifecycle.&#39;);
    });</pre>

## direct-and-group-conversations-01 — Reopen accepted A/D DM from both sides

**BLOCKED**; module DM; tier B; priority P0; owner UNASSIGNED; attempted false; duration 0 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors exchange private or group conversations. Scenario: Reopen accepted A/D DM from both sides; IDs identical. Historical BLOCKED by accept..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Reopen accepted A/D DM from both sides
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. IDs identical. Historical BLOCKED by accept.
   Expected: Reopen accepted A/D DM from both sides; IDs identical. Historical BLOCKED by accept.

### Expected and observed results

Contract: Reopen accepted A/D DM from both sides; IDs identical. Historical BLOCKED by accept.

Observed: Required request, conversation, or message fixture was not created.

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: BLOCKED_DEPENDENCY

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

No execution is claimed. Resolve the missing evidence or prerequisite before judging application behavior.

Inferred consequence, not an observed production/UI incident: the described Direct/group conversations scenario is not fully verified. Missing execution cannot establish an application defect.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>Required request, conversation, or message fixture was not created.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:91; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;direct-and-group-conversations-01&#39;, async () =&gt; {
      const [fromA, fromD] = await Promise.all([
        request(&#39;/api/channels/dm&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { userId: people.D.userId } }),
        request(&#39;/api/channels/dm&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { userId: people.A.userId } }),
      ]);
      assert(expectSuccess(fromA, &#39;reopen sender DM&#39;).channel._id === dm._id &amp;&amp; expectSuccess(fromD, &#39;reopen recipient DM&#39;).channel._id === dm._id, &#39;Accepted DM did not reopen to one stable ID.&#39;);
    }, Boolean(dm));</pre>

## direct-and-group-conversations-02 — Send in accepted DM

**BLOCKED**; module DM; tier B; priority P0; owner UNASSIGNED; attempted false; duration 0 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors exchange private or group conversations. Scenario: Send in accepted DM; recipient reads sender and lists peer/lastMessage. Historical BLOCKED..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Send in accepted DM
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. recipient reads sender and lists peer/lastMessage. Historical BLOCKED.
   Expected: Send in accepted DM; recipient reads sender and lists peer/lastMessage. Historical BLOCKED.

### Expected and observed results

Contract: Send in accepted DM; recipient reads sender and lists peer/lastMessage. Historical BLOCKED.

Observed: Required request, conversation, or message fixture was not created.

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: BLOCKED_DEPENDENCY

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

No execution is claimed. Resolve the missing evidence or prerequisite before judging application behavior.

Inferred consequence, not an observed production/UI incident: the described Direct/group conversations scenario is not fully verified. Missing execution cannot establish an application defect.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>Required request, conversation, or message fixture was not created.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:99; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;direct-and-group-conversations-02&#39;, async () =&gt; {
      dmMessage = await send(dm._id, people.A.token, marker(&#39;dm-message&#39;));
      const [detail, messages, sidebar] = await Promise.all([
        request(`/api/channels/${dm._id}`, { token: [REDACTED] }), request(`/api/channels/${dm._id}/messages`, { token: [REDACTED] }), request(&#39;/api/channels/dm&#39;, { token: [REDACTED] }),
      ]);
      assert(expectSuccess(detail, &#39;DM detail&#39;).channel.peer?._id === people.A.userId, &#39;DM peer details were incorrect.&#39;);
      assert(expectSuccess(messages, &#39;DM messages&#39;).messages.some((message) =&gt; message._id === dmMessage._id), &#39;DM message was not readable.&#39;);
      assert(expectSuccess(sidebar, &#39;DM sidebar&#39;).channels.find((channel) =&gt; channel._id === dm._id)?.lastMessage?.text === marker(&#39;dm-message&#39;), &#39;DM last-message preview was incorrect.&#39;);
    }, Boolean(dm));</pre>

## direct-and-group-conversations-03 — Mark peer message read twice

**BLOCKED**; module DM; tier B; priority P0; owner UNASSIGNED; attempted false; duration 0 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors exchange private or group conversations. Scenario: Mark peer message read twice; one readBy; disable receipts and mark another; no new receipt. Historical BLOCKED..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Mark peer message read twice
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. one readBy
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. disable receipts and mark another
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
4. no new receipt. Historical BLOCKED.
   Expected: Mark peer message read twice; one readBy; disable receipts and mark another; no new receipt. Historical BLOCKED.

### Expected and observed results

Contract: Mark peer message read twice; one readBy; disable receipts and mark another; no new receipt. Historical BLOCKED.

Observed: Required request, conversation, or message fixture was not created.

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: BLOCKED_DEPENDENCY

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

No execution is claimed. Resolve the missing evidence or prerequisite before judging application behavior.

Inferred consequence, not an observed production/UI incident: the described Direct/group conversations scenario is not fully verified. Missing execution cannot establish an application defect.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>Required request, conversation, or message fixture was not created.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:109; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;direct-and-group-conversations-03&#39;, async () =&gt; {
      await request(`/api/channels/${dm._id}/messages/read`, { method: &#39;POST&#39;, token: [REDACTED], body: { messageIds: [dmMessage._id] } });
      await request(`/api/channels/${dm._id}/messages/read`, { method: &#39;POST&#39;, token: [REDACTED], body: { messageIds: [dmMessage._id] } });
      const read = await messageById(dmMessage._id);
      await request(&#39;/api/users/me&#39;, { method: &#39;PUT&#39;, token: [REDACTED], body: { notifications: { readReceiptsEnabled: false } } });
      const privateMessage = await send(dm._id, people.A.token, marker(&#39;private-read&#39;));
      await request(`/api/channels/${dm._id}/messages/read`, { method: &#39;POST&#39;, token: [REDACTED], body: { messageIds: [privateMessage._id] } });
      const privateRead = await messageById(privateMessage._id);
      assert((read.readBy || []).filter((entry) =&gt; entry.userId.toString() === people.D.userId).length === 1, &#39;DM read receipt was not deduplicated.&#39;);
      assert(!(privateRead.readBy || []).some((entry) =&gt; entry.userId.toString() === people.D.userId), &#39;Read receipt was added despite disabled preference.&#39;);
    }, Boolean(dm &amp;&amp; dmMessage));</pre>

## direct-and-group-conversations-04 — Open self notes and send

**PASS**; module DM; tier B; priority P0; owner UNASSIGNED; attempted true; duration 43 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors exchange private or group conversations. Scenario: Open self notes and send; create/reopen group with exact members; rename and assert membership/name..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Open self notes and send
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. create/reopen group with exact members
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. rename and assert membership/name.
   Expected: Open self notes and send; create/reopen group with exact members; rename and assert membership/name.

### Expected and observed results

Contract: Open self notes and send; create/reopen group with exact members; rename and assert membership/name.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:121; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;direct-and-group-conversations-04&#39;, async () =&gt; {
      const notes = expectSuccess(await request(&#39;/api/channels/dm&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { userId: people.A.userId } }), &#39;open self notes&#39;).channel;
      await send(notes._id, people.A.token, marker(&#39;note&#39;));
      const group = expectSuccess(await request(&#39;/api/channels/dm/group&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { userIds: [people.B.userId, people.C.userId] } }), &#39;create group DM&#39;).channel;
      const reopened = expectSuccess(await request(&#39;/api/channels/dm/group&#39;, { method: &#39;POST&#39;, token: [REDACTED], body: { userIds: [people.C.userId, people.B.userId] } }), &#39;reopen group DM&#39;).channel;
      const renamed = expectSuccess(await request(`/api/channels/${group._id}`, { method: &#39;PUT&#39;, token: [REDACTED], body: { name: &#39;Sanity group renamed&#39; } }), &#39;rename group DM&#39;).channel;
      const storedNotes = expectSuccess(await request(`/api/channels/${notes._id}/messages`, { token: [REDACTED] }), &#39;read self note&#39;);
      assert(notes.isSelfNotes === true &amp;&amp; storedNotes.messages.some((message) =&gt; message.content.text === marker(&#39;note&#39;)), &#39;Notes to self were not persistent.&#39;);
      assert(reopened._id === group._id &amp;&amp; renamed.name === &#39;Sanity group renamed&#39; &amp;&amp; renamed.members.length === 3, &#39;Group DM did not preserve membership or rename.&#39;);
    });</pre>

## direct-and-group-conversations-05 — Expand independent source DMs with none/all

**BLOCKED**; module DM; tier B; priority P0; owner UNASSIGNED; attempted false; duration 0 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors exchange private or group conversations. Scenario: Expand independent source DMs with none/all; verify new membership, zero/copied history and unchanged sources. Historical BLOCKED..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Expand independent source DMs with none/all
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. verify new membership, zero/copied history and unchanged sources. Historical BLOCKED.
   Expected: Expand independent source DMs with none/all; verify new membership, zero/copied history and unchanged sources. Historical BLOCKED.

### Expected and observed results

Contract: Expand independent source DMs with none/all; verify new membership, zero/copied history and unchanged sources. Historical BLOCKED.

Observed: Required request, conversation, or message fixture was not created.

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: BLOCKED_DEPENDENCY

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

No execution is claimed. Resolve the missing evidence or prerequisite before judging application behavior.

Inferred consequence, not an observed production/UI incident: the described Direct/group conversations scenario is not fully verified. Missing execution cannot establish an application defect.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>Required request, conversation, or message fixture was not created.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/message-requests-and-conversations-scenarios.js:132; SHA-256 993cf1ba6f2b73f432eb0ac4bc2eb4c3ec376f4c9a8272c66d80e89a6704e8be

<pre>    await scenario(&#39;direct-and-group-conversations-05&#39;, async () =&gt; {
      const sourceMessage = await send(dm._id, people.A.token, marker(&#39;expansion-source&#39;));
      const none = expectSuccess(await request(`/api/channels/${dm._id}/expand`, { method: &#39;POST&#39;, token: [REDACTED], body: { userIds: [people.B.userId], history: &#39;none&#39; } }), &#39;expand without history&#39;).channel;
      const all = expectSuccess(await request(`/api/channels/${dm._id}/expand`, { method: &#39;POST&#39;, token: [REDACTED], body: { userIds: [people.C.userId], history: &#39;all&#39; } }), &#39;expand with history&#39;).channel;
      const [noneMessages, allMessages, sourceMessages] = await Promise.all([
        request(`/api/channels/${none._id}/messages`, { token: [REDACTED] }), request(`/api/channels/${all._id}/messages`, { token: [REDACTED] }), request(`/api/channels/${dm._id}/messages`, { token: [REDACTED] }),
      ]);
      assert(none.members.length === 3 &amp;&amp; expectSuccess(noneMessages, &#39;no-history results&#39;).messages.length === 0, &#39;No-history expansion copied messages.&#39;);
      assert(all.members.length === 3 &amp;&amp; expectSuccess(allMessages, &#39;all-history results&#39;).messages.some((message) =&gt; message.content.text === marker(&#39;expansion-source&#39;)), &#39;All-history expansion did not copy source content.&#39;);
      assert(expectSuccess(sourceMessages, &#39;source history&#39;).messages.some((message) =&gt; message._id === sourceMessage._id), &#39;Expansion changed source conversation history.&#39;);
    }, Boolean(dm));
  } finally {
    await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;);
    await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;message-requests-and-conversations-results.json&#39;), `${JSON.stringify({ expected: 8, results }, null, 2)}\n`);
  }
  const passed = results.filter((result) =&gt; result.status === &#39;passed&#39;).length;
  console.log(`Message-request and conversation scenarios passed: ${passed}/8.`);
  if (passed !== 8) process.exitCode = [REDACTED];
}

run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## handoffs-01 — Create draft patient+attachment, edit summary, read

**PASS**; module HOF; tier B; priority P0; owner UNASSIGNED; attempted true; duration 21 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

One doctor hands a synthetic patient case to another doctor. Scenario: Create draft patient+attachment, edit summary, read; draft and attachment filename survive..

### Prerequisites and reproduction

Use U+C. Create a synthetic A→B handoff in S/general for 2030-01-02 night shift. Patient T1/Synthetic/Case Alpha, stable, review marker, pending check marker; preserve returned patient and handoff IDs. No real patient data.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Create draft patient+attachment, edit summary, read
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. draft and attachment filename survive.
   Expected: Create draft patient+attachment, edit summary, read; draft and attachment filename survive.

### Expected and observed results

Contract: Create draft patient+attachment, edit summary, read; draft and attachment filename survive.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/handoff-scenarios.js:35; SHA-256 8221f8058018fff503c94bc039aac13ff470690e20f7df97b0413006c01c6348

<pre>    await scenario(&#39;handoffs-01&#39;, async () =&gt; {
      const createdDraft = expectSuccess(await request(&#39;/api/handoffs&#39;, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: base(people.B.userId, [patient([{ url: &#39;https://res.cloudinary.com/sanity/image/upload/handoff.png&#39;, fileName: &#39;handoff.png&#39;, mimeType: &#39;image/png&#39; }])]) }), &#39;create handoff draft&#39;).handoff;
      const updated = expectSuccess(await request(`/api/handoffs/${createdDraft._id}`, { method: &#39;PUT&#39;, token: [REDACTED], body: { shiftSummary: marker(&#39;updated-summary&#39;) } }), &#39;edit handoff draft&#39;).handoff;
      const detail = expectSuccess(await request(`/api/handoffs/${createdDraft._id}`, { token: [REDACTED] }), &#39;read handoff draft&#39;).handoff;
      assert(updated.status === &#39;draft&#39; &amp;&amp; detail.patients[0].attachments[0].fileName === &#39;handoff.png&#39; &amp;&amp; detail.shiftSummary === marker(&#39;updated-summary&#39;), &#39;Draft handoff edit/read did not preserve patient attachment data.&#39;);
    });</pre>

## handoffs-02 — Empty draft submit gives 400

**PASS**; module HOF; tier B; priority P0; owner UNASSIGNED; attempted true; duration 18 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

One doctor hands a synthetic patient case to another doctor. Scenario: Empty draft submit gives 400; delete disposable draft; subsequent detail gives 404..

### Prerequisites and reproduction

Use U+C. Create a synthetic A→B handoff in S/general for 2030-01-02 night shift. Patient T1/Synthetic/Case Alpha, stable, review marker, pending check marker; preserve returned patient and handoff IDs. No real patient data.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Empty draft submit gives 400
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. delete disposable draft
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. subsequent detail gives 404.
   Expected: Empty draft submit gives 400; delete disposable draft; subsequent detail gives 404.

### Expected and observed results

Contract: Empty draft submit gives 400; delete disposable draft; subsequent detail gives 404.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/handoff-scenarios.js:42; SHA-256 8221f8058018fff503c94bc039aac13ff470690e20f7df97b0413006c01c6348

<pre>    await scenario(&#39;handoffs-02&#39;, async () =&gt; {
      const empty = expectSuccess(await request(&#39;/api/handoffs&#39;, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: base(people.B.userId, []) }), &#39;create empty handoff&#39;).handoff;
      await request(`/api/handoffs/${empty._id}/submit`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 400 });
      await request(`/api/handoffs/${empty._id}`, { method: &#39;DELETE&#39;, token: [REDACTED] });
      await request(`/api/handoffs/${empty._id}`, { token: [REDACTED], expectedStatus: 404 });
    });</pre>

## handoffs-03 — Submit populated draft

**PASS**; module HOF; tier B; priority P0; owner UNASSIGNED; attempted true; duration 37 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

One doctor hands a synthetic patient case to another doctor. Scenario: Submit populated draft; verify received list/space history, notification and submitted event; update/delete give 400..

### Prerequisites and reproduction

Use U+C. Create a synthetic A→B handoff in S/general for 2030-01-02 night shift. Patient T1/Synthetic/Case Alpha, stable, review marker, pending check marker; preserve returned patient and handoff IDs. No real patient data.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Submit populated draft
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. verify received list/space history, notification and submitted event
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. update/delete give 400.
   Expected: Submit populated draft; verify received list/space history, notification and submitted event; update/delete give 400.

### Expected and observed results

Contract: Submit populated draft; verify received list/space history, notification and submitted event; update/delete give 400.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/handoff-scenarios.js:49; SHA-256 8221f8058018fff503c94bc039aac13ff470690e20f7df97b0413006c01c6348

<pre>    await scenario(&#39;handoffs-03&#39;, async () =&gt; {
      handoff = expectSuccess(await request(&#39;/api/handoffs&#39;, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: base(people.B.userId) }), &#39;create populated handoff&#39;).handoff;
      const event = waitFor(clientB.socket, &#39;handoff_submitted&#39;, (payload) =&gt; payload?.handoffId === handoff._id);
      const submitted = expectSuccess(await request(`/api/handoffs/${handoff._id}/submit`, { method: &#39;POST&#39;, token: [REDACTED] }), &#39;submit handoff&#39;).handoff;
      await event;
      const [inbox, history] = await Promise.all([request(&#39;/api/handoffs?type=received&#39;, { token: [REDACTED] }), request(`/api/spaces/${space._id}/handoffs`, { token: [REDACTED] })]);
      const notification = await eventually(&#39;handoff recipient notification&#39;, () =&gt; notificationFor(people.B.userId, handoff._id));
      await request(`/api/handoffs/${handoff._id}`, { method: &#39;PUT&#39;, token: [REDACTED], expectedStatus: 400, body: { shiftSummary: marker(&#39;forbidden-edit&#39;) } });
      await request(`/api/handoffs/${handoff._id}`, { method: &#39;DELETE&#39;, token: [REDACTED], expectedStatus: 400 });
      assert(submitted.status === &#39;submitted&#39; &amp;&amp; expectSuccess(inbox, &#39;handoff inbox&#39;).handoffs.some((item) =&gt; item._id === handoff._id), &#39;Submitted handoff was absent from recipient inbox.&#39;);
      assert(expectSuccess(history, &#39;handoff history&#39;).handoffs.some((item) =&gt; item._id === handoff._id) &amp;&amp; notification.type === &#39;handoff_received&#39;, &#39;Submitted handoff history or notification was missing.&#39;);
    });</pre>

## handoffs-04 — B acknowledges with note

**PASS**; module HOF; tier B; priority P0; owner UNASSIGNED; attempted true; duration 10 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

One doctor hands a synthetic patient case to another doctor. Scenario: B acknowledges with note; verify status/time/note, sender notification and event; duplicate acknowledgement rejects..

### Prerequisites and reproduction

Use U+C. Create a synthetic A→B handoff in S/general for 2030-01-02 night shift. Patient T1/Synthetic/Case Alpha, stable, review marker, pending check marker; preserve returned patient and handoff IDs. No real patient data.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. B acknowledges with note
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. verify status/time/note, sender notification and event
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. duplicate acknowledgement rejects.
   Expected: B acknowledges with note; verify status/time/note, sender notification and event; duplicate acknowledgement rejects.

### Expected and observed results

Contract: B acknowledges with note; verify status/time/note, sender notification and event; duplicate acknowledgement rejects.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/handoff-scenarios.js:62; SHA-256 8221f8058018fff503c94bc039aac13ff470690e20f7df97b0413006c01c6348

<pre>    await scenario(&#39;handoffs-04&#39;, async () =&gt; {
      const event = waitFor(clientA.socket, &#39;handoff_acknowledged&#39;, (payload) =&gt; payload?.handoffId === handoff._id);
      const acknowledged = expectSuccess(await request(`/api/handoffs/${handoff._id}/acknowledge`, { method: &#39;POST&#39;, token: [REDACTED], body: { note: marker(&#39;acknowledged&#39;) } }), &#39;acknowledge handoff&#39;).handoff;
      await event;
      const notification = await eventually(&#39;handoff sender acknowledgement notification&#39;, () =&gt; notificationFor(people.A.userId, handoff._id));
      await request(`/api/handoffs/${handoff._id}/acknowledge`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 400, body: { note: marker(&#39;duplicate&#39;) } });
      assert(acknowledged.status === &#39;acknowledged&#39; &amp;&amp; acknowledged.acknowledgedAt &amp;&amp; acknowledged.acknowledgementNote === marker(&#39;acknowledged&#39;) &amp;&amp; notification.type === &#39;handoff_acknowledged&#39;, &#39;Acknowledgement did not persist expected state or notification.&#39;);
    });</pre>

## handoffs-05 — B adds note then reassigns to C

**PASS**; module HOF; tier B; priority P0; owner UNASSIGNED; attempted true; duration 25 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

One doctor hands a synthetic patient case to another doctor. Scenario: B adds note then reassigns to C; DB history has one entry and resets acknowledgement; C can acknowledge..

### Prerequisites and reproduction

Use U+C. Create a synthetic A→B handoff in S/general for 2030-01-02 night shift. Patient T1/Synthetic/Case Alpha, stable, review marker, pending check marker; preserve returned patient and handoff IDs. No real patient data.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. B adds note then reassigns to C
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. DB history has one entry and resets acknowledgement
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. C can acknowledge.
   Expected: B adds note then reassigns to C; DB history has one entry and resets acknowledgement; C can acknowledge.

### Expected and observed results

Contract: B adds note then reassigns to C; DB history has one entry and resets acknowledgement; C can acknowledge.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/handoff-scenarios.js:71; SHA-256 8221f8058018fff503c94bc039aac13ff470690e20f7df97b0413006c01c6348

<pre>    await scenario(&#39;handoffs-05&#39;, async () =&gt; {
      const noted = expectSuccess(await request(`/api/handoffs/${handoff._id}/notes`, { method: &#39;POST&#39;, token: [REDACTED], body: { text: marker(&#39;write-back&#39;), kind: &#39;note&#39; } }), &#39;add write-back note&#39;).handoff;
      const reassigned = expectSuccess(await request(`/api/handoffs/${handoff._id}/reassign`, { method: &#39;POST&#39;, token: [REDACTED], body: { toUserId: people.C.userId, note: marker(&#39;reassign&#39;) } }), &#39;reassign handoff&#39;).handoff;
      const stored = await handoffById(handoff._id);
      const acknowledged = expectSuccess(await request(`/api/handoffs/${handoff._id}/acknowledge`, { method: &#39;POST&#39;, token: [REDACTED], body: { note: marker(&#39;new-assignee-ack&#39;) } }), &#39;acknowledge reassigned handoff&#39;).handoff;
      assert(noted.writeBackNotes.some((note) =&gt; note.text === marker(&#39;write-back&#39;)) &amp;&amp; reassigned.toUserId._id === people.C.userId, &#39;Write-back or reassignment was not persisted.&#39;);
      assert(stored.assignmentHistory.length === 1 &amp;&amp; stored.status === &#39;submitted&#39; &amp;&amp; stored.acknowledgedAt === null, &#39;Reassignment did not reset acknowledgement or record history.&#39;);
      assert(acknowledged.status === &#39;acknowledged&#39; &amp;&amp; String(acknowledged.toUserId) === people.C.userId, &#39;New assignee could not acknowledge the handoff.&#39;);
    });
  } finally {
    closeRealtime(clientA); closeRealtime(clientB); closeRealtime(clientC); await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;); await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;handoff-results.json&#39;), `${JSON.stringify({ expected: 5, results }, null, 2)}\n`);
  }
  console.log(&#39;Handoff scenarios passed: 5/5.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## media-01 — Upload PNG, download exact bytes, delete, subsequent retrieval 404.

**PASS**; module MED; tier B; priority P0; owner UNASSIGNED; attempted true; duration 23 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor attaches, views or removes a synthetic file. Scenario: Upload PNG, download exact bytes, delete, subsequent retrieval 404..

### Prerequisites and reproduction

Use U and valid tiny PNG/PDF/MP4 bytes with unique filenames and SHA-256. Use local storage and test-owned provider transport with no egress. Inert external URLs are metadata; do not retrieve them.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Upload PNG, download exact bytes, delete, subsequent retrieval 404.
   Expected: Upload PNG, download exact bytes, delete, subsequent retrieval 404.

### Expected and observed results

Contract: Upload PNG, download exact bytes, delete, subsequent retrieval 404.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/media-scenarios.js:36; SHA-256 ef1d1141d0896c8d7160e6a2589c7abb589edc15137d8ae487965096def9e848

<pre>    await scenario(&#39;media-01&#39;, async () =&gt; {
      const png = bytes([137, 80, 78, 71, 13, 10, 26, 10, 0, 1, 2, 3]);
      const uploaded = await upload(people.A.token, &#39;sanity.png&#39;, &#39;image/png&#39;, png);
      const downloaded = await download(localPath(uploaded.url), people.A.token);
      assert(uploaded.storage === &#39;local&#39; &amp;&amp; downloaded.length === png.length &amp;&amp; downloaded.every((value, index) =&gt; value === png[index]), &#39;PNG upload/download bytes were not exact.&#39;);
      await request(`/api/media/${encodeURIComponent(uploaded.publicId)}`, { method: &#39;DELETE&#39;, token: [REDACTED] });
      await request(localPath(uploaded.url), { token: [REDACTED], expectedStatus: 404 });
    });</pre>

## media-02 — Upload PDF, compare downloaded bytes

**PASS**; module MED; tier B; priority P0; owner UNASSIGNED; attempted true; duration 27 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor attaches, views or removes a synthetic file. Scenario: Upload PDF, compare downloaded bytes; create handoff attachment and reread filename/MIME..

### Prerequisites and reproduction

Use U and valid tiny PNG/PDF/MP4 bytes with unique filenames and SHA-256. Use local storage and test-owned provider transport with no egress. Inert external URLs are metadata; do not retrieve them.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Upload PDF, compare downloaded bytes
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. create handoff attachment and reread filename/MIME.
   Expected: Upload PDF, compare downloaded bytes; create handoff attachment and reread filename/MIME.

### Expected and observed results

Contract: Upload PDF, compare downloaded bytes; create handoff attachment and reread filename/MIME.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/media-scenarios.js:45; SHA-256 ef1d1141d0896c8d7160e6a2589c7abb589edc15137d8ae487965096def9e848

<pre>    await scenario(&#39;media-02&#39;, async () =&gt; {
      const pdf = bytes([37, 80, 68, 70, 45, 49, 46, 52, 10, 37, 0, 1, 2]);
      const uploaded = await upload(people.A.token, &#39;sanity.pdf&#39;, &#39;application/pdf&#39;, pdf, &#39;message&#39;);
      const downloaded = await download(localPath(uploaded.url), people.A.token);
      const handoff = expectSuccess(await request(&#39;/api/handoffs&#39;, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: {
        spaceId: space._id, channelId: channel._id, toUserId: people.B.userId, shiftDate: &#39;2030-01-15T00:00:00.000Z&#39;, shiftType: &#39;night&#39;, shiftSummary: &#39;media attachment fixture&#39;,
        patients: [{ bedNumber: &#39;M-01&#39;, clinicalAlias: &#39;Synthetic media patient&#39;, attachments: [{ url: uploaded.url, thumbnailUrl: uploaded.thumbnailUrl, fileName: uploaded.fileName, mimeType: uploaded.mimeType }] }],
      } }), &#39;create PDF handoff&#39;).handoff;
      const detail = expectSuccess(await request(`/api/handoffs/${handoff._id}`, { token: [REDACTED] }), &#39;read PDF handoff&#39;).handoff;
      assert(downloaded.length === pdf.length &amp;&amp; downloaded.every((value, index) =&gt; value === pdf[index]), &#39;PDF upload/download bytes were not exact.&#39;);
      assert(detail.patients[0].attachments[0].fileName === &#39;sanity.pdf&#39; &amp;&amp; detail.patients[0].attachments[0].mimeType === &#39;application/pdf&#39;, &#39;PDF attachment metadata was not persisted in handoff.&#39;);
    });</pre>

## media-03 — Send inert image/ECG/document URL metadata

**PASS**; module MED; tier B; priority P0; owner UNASSIGNED; attempted true; duration 37 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor attaches, views or removes a synthetic file. Scenario: Send inert image/ECG/document URL metadata; GET same URL/filename; final document sidebar label matches. No provider retrieval proof..

### Prerequisites and reproduction

Use U and valid tiny PNG/PDF/MP4 bytes with unique filenames and SHA-256. Use local storage and test-owned provider transport with no egress. Inert external URLs are metadata; do not retrieve them.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Send inert image/ECG/document URL metadata
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. GET same URL/filename
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
3. final document sidebar label matches. No provider retrieval proof.
   Expected: Send inert image/ECG/document URL metadata; GET same URL/filename; final document sidebar label matches. No provider retrieval proof.

### Expected and observed results

Contract: Send inert image/ECG/document URL metadata; GET same URL/filename; final document sidebar label matches. No provider retrieval proof.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/media-scenarios.js:58; SHA-256 ef1d1141d0896c8d7160e6a2589c7abb589edc15137d8ae487965096def9e848

<pre>    await scenario(&#39;media-03&#39;, async () =&gt; {
      const media = [
        [&#39;image&#39;, &#39;https://res.cloudinary.com/sanity/image/upload/sanity-image.png&#39;, &#39;sanity-image.png&#39;, &#39;image/png&#39;],
        [&#39;ecg&#39;, &#39;https://res.cloudinary.com/sanity/image/upload/sanity-ecg.png&#39;, &#39;sanity-ecg.png&#39;, &#39;image/png&#39;],
        [&#39;document&#39;, &#39;https://res.cloudinary.com/sanity/raw/upload/sanity-document.pdf&#39;, &#39;sanity-document.pdf&#39;, &#39;application/pdf&#39;],
      ];
      const sent = [];
      for (const [type, mediaUrl, fileName, mimeType] of media) {
        sent.push(expectSuccess(await request(`/api/channels/${channel._id}/messages`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: { type, content: { mediaUrl, fileName, mimeType, fileSize: 42 } } }), `send inert ${type}`).message);
      }
      const messages = expectSuccess(await request(`/api/channels/${channel._id}/messages?limit=20`, { token: [REDACTED] }), &#39;read media messages&#39;).messages;
      for (const message of sent) {
        const persisted = messages.find((item) =&gt; item._id === message._id);
        assert(persisted?.content?.mediaUrl === message.content.mediaUrl &amp;&amp; persisted.content.fileName === message.content.fileName, `Media metadata did not persist for ${message.type}.`);
      }
      const detail = expectSuccess(await request(`/api/channels/${channel._id}`, { token: [REDACTED] }), &#39;read media sidebar preview&#39;).channel;
      assert(detail.lastMessage?.text === &#39;📎 Document&#39;, &#39;Document message did not produce the expected sidebar preview.&#39;);
    });
  } finally {
    await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;); await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;media-results.json&#39;), `${JSON.stringify({ expected: 3, results }, null, 2)}\n`);
  }
  console.log(&#39;Media scenarios passed: 3/3.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## notifications-01 — Send ordinary message to non-viewing B

**PASS**; module NOT; tier B; priority P0; owner UNASSIGNED; attempted true; duration 21 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor receives and manages personal notifications. Scenario: Send ordinary message to non-viewing B; poll inbox/count, reference metadata and personal socket event..

### Prerequisites and reproduction

Use C with A/B sockets and captured fake push transport. B is outside the channel unless specified. Clear notifications only during fixture setup. Use dated synthetic entries for pagination.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Send ordinary message to non-viewing B
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. poll inbox/count, reference metadata and personal socket event.
   Expected: Send ordinary message to non-viewing B; poll inbox/count, reference metadata and personal socket event.

### Expected and observed results

Contract: Send ordinary message to non-viewing B; poll inbox/count, reference metadata and personal socket event.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/notification-scenarios.js:37; SHA-256 cc3723c5c0db649f81d5b16310d761f8e0d139e6888c2fe8e65a8b6457937431

<pre>    await scenario(&#39;notifications-01&#39;, async () =&gt; {
      const event = waitFor(clientB.socket, &#39;new_notification&#39;, (payload) =&gt; payload?.type === &#39;new_message&#39;);
      const message = await send(general._id, people.A.token, marker(&#39;ordinary&#39;));
      const delivered = await event;
      const current = await eventually(&#39;ordinary notification persistence&#39;, async () =&gt; (await inbox(people.B.token)).notifications.find((item) =&gt; String(item.referenceId) === message._id));
      const count = expectSuccess(await request(&#39;/api/notifications/unread-count&#39;, { token: [REDACTED] }), &#39;read notification count&#39;);
      assert(delivered.referenceId === message._id &amp;&amp; current.type === &#39;new_message&#39; &amp;&amp; String(current.metadata?.channelId) === general._id, &#39;Ordinary message notification metadata or socket delivery was incorrect.&#39;);
      assert(count.count &gt;= 1, &#39;Unread notification count did not include ordinary message.&#39;);
    });</pre>

## notifications-02 — Mention B then emergency message

**PASS**; module NOT; tier B; priority P0; owner UNASSIGNED; attempted true; duration 24 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor receives and manages personal notifications. Scenario: Mention B then emergency message; persisted type/priority match mention/emergency..

### Prerequisites and reproduction

Use C with A/B sockets and captured fake push transport. B is outside the channel unless specified. Clear notifications only during fixture setup. Use dated synthetic entries for pagination.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Mention B then emergency message
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. persisted type/priority match mention/emergency.
   Expected: Mention B then emergency message; persisted type/priority match mention/emergency.

### Expected and observed results

Contract: Mention B then emergency message; persisted type/priority match mention/emergency.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/notification-scenarios.js:47; SHA-256 cc3723c5c0db649f81d5b16310d761f8e0d139e6888c2fe8e65a8b6457937431

<pre>    await scenario(&#39;notifications-02&#39;, async () =&gt; {
      const mentionEvent = waitFor(clientB.socket, &#39;new_notification&#39;, (payload) =&gt; payload?.type === &#39;mention&#39;);
      const mention = await send(general._id, people.A.token, marker(&#39;mention&#39;), { mentions: [people.B.userId] });
      await mentionEvent;
      const emergencyEvent = waitFor(clientB.socket, &#39;new_notification&#39;, (payload) =&gt; payload?.type === &#39;emergency_alert&#39;);
      const emergencyMessage = await send(emergency._id, people.A.token, marker(&#39;emergency&#39;));
      await emergencyEvent;
      const current = await eventually(&#39;mention and emergency persistence&#39;, async () =&gt; {
        const entries = (await inbox(people.B.token)).notifications;
        return entries.some((item) =&gt; item.type === &#39;mention&#39; &amp;&amp; String(item.referenceId) === mention._id) &amp;&amp; entries.some((item) =&gt; item.type === &#39;emergency_alert&#39; &amp;&amp; String(item.referenceId) === emergencyMessage._id) ? entries : null;
      });
      const emergencyNotification = current.find((item) =&gt; item.type === &#39;emergency_alert&#39; &amp;&amp; String(item.referenceId) === emergencyMessage._id);
      assert(emergencyNotification.priority === &#39;emergency&#39;, &#39;Emergency notification priority was incorrect.&#39;);
    });</pre>

## notifications-03 — Mark one read/unread, channel read, all read, delete

**PASS**; module NOT; tier B; priority P0; owner UNASSIGNED; attempted true; duration 31 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor receives and manages personal notifications. Scenario: Mark one read/unread, channel read, all read, delete; lists/counts match changes..

### Prerequisites and reproduction

Use C with A/B sockets and captured fake push transport. B is outside the channel unless specified. Clear notifications only during fixture setup. Use dated synthetic entries for pagination.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Mark one read/unread, channel read, all read, delete
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. lists/counts match changes.
   Expected: Mark one read/unread, channel read, all read, delete; lists/counts match changes.

### Expected and observed results

Contract: Mark one read/unread, channel read, all read, delete; lists/counts match changes.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/notification-scenarios.js:62; SHA-256 cc3723c5c0db649f81d5b16310d761f8e0d139e6888c2fe8e65a8b6457937431

<pre>    await scenario(&#39;notifications-03&#39;, async () =&gt; {
      const initial = await inbox(people.B.token);
      const first = initial.notifications.find((item) =&gt; !item.read);
      assert(first, &#39;No unread notification was available for lifecycle checks.&#39;);
      await request(`/api/notifications/${first._id}/read`, { method: &#39;PUT&#39;, token: [REDACTED] });
      await request(`/api/notifications/${first._id}/unread`, { method: &#39;PUT&#39;, token: [REDACTED] });
      const channelRead = expectSuccess(await request(`/api/notifications/read-by-channel/${general._id}`, { method: &#39;PUT&#39;, token: [REDACTED] }), &#39;mark channel notifications read&#39;);
      const allRead = expectSuccess(await request(&#39;/api/notifications/read-all&#39;, { method: &#39;PUT&#39;, token: [REDACTED] }), &#39;mark all notifications read&#39;);
      const afterRead = await inbox(people.B.token);
      const deleted = afterRead.notifications[0];
      await request(`/api/notifications/${deleted._id}`, { method: &#39;DELETE&#39;, token: [REDACTED] });
      const final = await inbox(people.B.token);
      const count = expectSuccess(await request(&#39;/api/notifications/unread-count&#39;, { token: [REDACTED] }), &#39;read final notification count&#39;);
      assert(channelRead.unreadCount &gt;= 0 &amp;&amp; allRead.modifiedCount &gt;= 0, &#39;Notification batch read endpoints returned invalid results.&#39;);
      assert(!final.notifications.some((item) =&gt; item._id === deleted._id) &amp;&amp; count.count === 0, &#39;Notification delete/read state did not leave a consistent inbox.&#39;);
    });
  } finally {
    closeRealtime(clientB); await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;); await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;notification-results.json&#39;), `${JSON.stringify({ expected: 3, results }, null, 2)}\n`);
  }
  console.log(&#39;Notification scenarios passed: 3/3.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## realtime-and-availability-01 — Authenticate two sockets, join, REST send, receive

**PASS**; module RT; tier B; priority P0; owner UNASSIGNED; attempted true; duration 47 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors communicate while connections and presence change. Scenario: Authenticate two sockets, join, REST send, receive; disconnect/reconnect/rejoin. No second-message assertion exists in this retained case..

### Prerequisites and reproduction

Use C with A/B sockets and captured fake push transport. B is outside the channel unless specified. Clear notifications only during fixture setup. Use dated synthetic entries for pagination.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Authenticate two sockets, join, REST send, receive
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. disconnect/reconnect/rejoin. No second-message assertion exists in this retained case.
   Expected: Authenticate two sockets, join, REST send, receive; disconnect/reconnect/rejoin. No second-message assertion exists in this retained case.

### Expected and observed results

Contract: Authenticate two sockets, join, REST send, receive; disconnect/reconnect/rejoin. No second-message assertion exists in this retained case.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/realtime-availability-scenarios.js:26; SHA-256 f4a0dcc6d9cd160a5f375c87645cd7d263fa5846e42bdee12d11d5bd9fb2b84a

<pre>    await scenario(&#39;realtime-and-availability-01&#39;, async () =&gt; {
      clientA = await connectRealtime(people.A.token); clientB = await connectRealtime(people.B.token);
      assert(clientA.authenticated.userId === people.A.userId &amp;&amp; clientB.authenticated.userId === people.B.userId, &#39;Socket authentication did not return the authenticated identities.&#39;);
      await Promise.all([joinChannel(clientA, general._id), joinChannel(clientB, general._id)]);
      const received = waitFor(clientB.socket, &#39;new_message&#39;, (payload) =&gt; payload?.content?.text === marker(&#39;rest-message&#39;));
      await request(`/api/channels/${general._id}/messages`, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: { type: &#39;text&#39;, content: { text: marker(&#39;rest-message&#39;) } } });
      await received;
      closeRealtime(clientA);
      clientA = await connectRealtime(people.A.token);
      await joinChannel(clientA, general._id);
    });</pre>

## realtime-and-availability-02 — Start/stop typing

**PASS**; module RT; tier B; priority P0; owner UNASSIGNED; attempted true; duration 2 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors communicate while connections and presence change. Scenario: Start/stop typing; peer receives channel/user IDs..

### Prerequisites and reproduction

Use C with A/B sockets and captured fake push transport. B is outside the channel unless specified. Clear notifications only during fixture setup. Use dated synthetic entries for pagination.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Start/stop typing
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. peer receives channel/user IDs.
   Expected: Start/stop typing; peer receives channel/user IDs.

### Expected and observed results

Contract: Start/stop typing; peer receives channel/user IDs.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/realtime-availability-scenarios.js:38; SHA-256 f4a0dcc6d9cd160a5f375c87645cd7d263fa5846e42bdee12d11d5bd9fb2b84a

<pre>    await scenario(&#39;realtime-and-availability-02&#39;, async () =&gt; {
      const started = waitFor(clientB.socket, &#39;user_typing&#39;, (payload) =&gt; payload?.channelId === general._id &amp;&amp; payload?.userId === people.A.userId);
      clientA.socket.emit(&#39;typing_start&#39;, { channelId: general._id });
      await started;
      const stopped = waitFor(clientB.socket, &#39;user_stopped_typing&#39;, (payload) =&gt; payload?.channelId === general._id &amp;&amp; payload?.userId === people.A.userId);
      clientA.socket.emit(&#39;typing_stop&#39;, { channelId: general._id });
      await stopped;
    });</pre>

## realtime-and-availability-03 — REST/socket availability, room sync, final disconnect

**PASS**; module RT; tier B; priority P0; owner UNASSIGNED; attempted true; duration 18 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

Doctors communicate while connections and presence change. Scenario: REST/socket availability, room sync, final disconnect; assert stored state, broadcasts and offline presence..

### Prerequisites and reproduction

Use C with A/B sockets and captured fake push transport. B is outside the channel unless specified. Clear notifications only during fixture setup. Use dated synthetic entries for pagination.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. REST/socket availability, room sync, final disconnect
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. assert stored state, broadcasts and offline presence.
   Expected: REST/socket availability, room sync, final disconnect; assert stored state, broadcasts and offline presence.

### Expected and observed results

Contract: REST/socket availability, room sync, final disconnect; assert stored state, broadcasts and offline presence.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/realtime-availability-scenarios.js:47; SHA-256 f4a0dcc6d9cd160a5f375c87645cd7d263fa5846e42bdee12d11d5bd9fb2b84a

<pre>    await scenario(&#39;realtime-and-availability-03&#39;, async () =&gt; {
      const restBroadcast = waitFor(clientB.socket, &#39;presence_update&#39;, (payload) =&gt; payload?.userId === people.A.userId &amp;&amp; payload?.availability?.status === &#39;on_call&#39;);
      await request(&#39;/api/users/me/availability&#39;, { method: &#39;PUT&#39;, token: [REDACTED], body: { status: &#39;on_call&#39;, note: marker(&#39;rest-note&#39;) } });
      await restBroadcast;
      const socketBroadcast = waitFor(clientB.socket, &#39;presence_update&#39;, (payload) =&gt; payload?.userId === people.A.userId &amp;&amp; payload?.availability?.status === &#39;in_ot&#39;);
      clientA.socket.emit(&#39;update_availability&#39;, { status: &#39;in_ot&#39;, note: marker(&#39;socket-note&#39;) });
      await socketBroadcast;
      const sync = waitFor(clientA.socket, &#39;sync_space_rooms&#39;, (payload) =&gt; payload?.success === true &amp;&amp; payload?.spaceCount &gt;= 1);
      clientA.socket.emit(&#39;sync_space_rooms&#39;);
      await sync;
      assert((await userByPhone(people.A.phone)).availability.status === &#39;in_ot&#39;, &#39;Socket availability update was not persisted.&#39;);
      const offline = waitFor(clientB.socket, &#39;presence_update&#39;, (payload) =&gt; payload?.userId === people.A.userId &amp;&amp; payload?.isOnline === false);
      closeRealtime(clientA); clientA = undefined;
      await offline;
    });
  } finally {
    closeRealtime(clientA); closeRealtime(clientB); await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;); await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;realtime-availability-results.json&#39;), `${JSON.stringify({ expected: 3, results }, null, 2)}\n`);
  }
  console.log(&#39;Realtime and availability scenarios passed: 3/3.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## search-01 — Known-user name query and phone lookup return intended colleague.

**PASS**; module SRCH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 16 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor searches for accessible colleagues and clinical collaboration resources. Scenario: Known-user name query and phone lookup return intended colleague..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Known-user name query and phone lookup return intended colleague.
   Expected: Known-user name query and phone lookup return intended colleague.

### Expected and observed results

Contract: Known-user name query and phone lookup return intended colleague.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/search-scenarios.js:29; SHA-256 85107ce9e7cf889019d5b9ac1f378cc8df2919e22060b84f4757bfb90401ee04

<pre>    await scenario(&#39;search-01&#39;, async () =&gt; {
      const [users, lookup] = await Promise.all([request(`/api/users/search?q=${term}`, { token: [REDACTED] }), request(`/api/users/lookup?phone=${encodeURIComponent(people.B.phone)}`, { token: [REDACTED] })]);
      assert(expectSuccess(users, &#39;known-user search&#39;).users.some((user) =&gt; user._id === people.B.userId), &#39;Known-user search did not return the synthetic colleague.&#39;);
      assert(expectSuccess(lookup, &#39;phone lookup&#39;).user._id === people.B.userId, &#39;Phone lookup did not return the synthetic colleague.&#39;);
    });</pre>

## search-02 — Global marker search finds message/doctor/channel/attachment/handoff

**PASS**; module SRCH; tier B; priority P0; owner UNASSIGNED; attempted true; duration 25 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor searches for accessible colleagues and clinical collaboration resources. Scenario: Global marker search finds message/doctor/channel/attachment/handoff; nonmatching marker returns empty arrays..

### Prerequisites and reproduction

Use U, default general/emergency/academics channels, public X and private Y (A only), accepted A/B DM, A/B/C group, distinct roots r1/r2 and reply t1. Component prerequisites may be seeded; journey steps must use application APIs.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Global marker search finds message/doctor/channel/attachment/handoff
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. nonmatching marker returns empty arrays.
   Expected: Global marker search finds message/doctor/channel/attachment/handoff; nonmatching marker returns empty arrays.

### Expected and observed results

Contract: Global marker search finds message/doctor/channel/attachment/handoff; nonmatching marker returns empty arrays.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/search-scenarios.js:35; SHA-256 85107ce9e7cf889019d5b9ac1f378cc8df2919e22060b84f4757bfb90401ee04

<pre>    await scenario(&#39;search-02&#39;, async () =&gt; {
      const found = expectSuccess(await request(`/api/search?q=${term}`, { token: [REDACTED] }), &#39;global search&#39;);
      const empty = expectSuccess(await request(&#39;/api/search?q=zzzz-no-sanity-match&#39;, { token: [REDACTED] }), &#39;empty global search&#39;);
      assert(found.messages.length &gt;= 1 &amp;&amp; found.doctors.some((user) =&gt; user._id === people.B.userId) &amp;&amp; found.channels.some((item) =&gt; item._id === channel._id) &amp;&amp; found.attachments.length &gt;= 1 &amp;&amp; found.handoffs.length &gt;= 1, &#39;Global search did not return each required result class.&#39;);
      assert(Object.values(empty).filter(Array.isArray).every((items) =&gt; items.length === 0), &#39;Nonmatching global search was not empty.&#39;);
    });
  } finally {
    await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;); await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;search-results.json&#39;), `${JSON.stringify({ expected: 2, results }, null, 2)}\n`);
  }
  console.log(&#39;Search scenarios passed: 2/2.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## support-01 — Submit bug, inspect ticket ID/author/type/title/description

**PASS**; module SUP; tier B; priority P0; owner UNASSIGNED; attempted true; duration 41 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

A doctor submits support information or a synthetic developer tool is exercised. Scenario: Submit bug, inspect ticket ID/author/type/title/description; missing title fails..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. Submit bug, inspect ticket ID/author/type/title/description
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. missing title fails.
   Expected: Submit bug, inspect ticket ID/author/type/title/description; missing title fails.

### Expected and observed results

Contract: Submit bug, inspect ticket ID/author/type/title/description; missing title fails.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/support-scenarios.js:18; SHA-256 ae10b31b33955e14e214fe72232d5e36300056c5344f9c269d63e1b67178e218

<pre>    await scenario(&#39;support-01&#39;, async () =&gt; {
      const title = &#39;Sanity synthetic bug report&#39;; const description = &#39;Synthetic test data only; no clinical information.&#39;;
      const created = expectSuccess(await request(&#39;/api/support/bug&#39;, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 201, body: { title, description, steps: &#39;Open synthetic fixture.&#39; } }), &#39;submit bug report&#39;);
      const ticket = await supportTicketById(created.ticketId);
      await request(&#39;/api/support/bug&#39;, { method: &#39;POST&#39;, token: [REDACTED], expectedStatus: 400, body: { description } });
      assert(ticket?.userId.toString() === people.A.userId &amp;&amp; ticket.type === &#39;bug&#39; &amp;&amp; ticket.title === title &amp;&amp; ticket.description === description, &#39;Stored support ticket did not preserve expected fields.&#39;);
    });
  } finally {
    await closeDatabase();
    const output = resolve(process.env.SANITY_OUTPUT_DIR || &#39;output&#39;); await mkdir(output, { recursive: true });
    await writeFile(resolve(output, &#39;support-results.json&#39;), `${JSON.stringify({ expected: 1, results }, null, 2)}\n`);
  }
  console.log(&#39;Support scenario passed: 1/1.&#39;);
}
run().catch(async (error) =&gt; { console.error(error.stack || error.message); await closeDatabase(); process.exitCode = [REDACTED]; });
</pre>

## startup-01 — GET health

**PASS**; module RUN; tier B; priority P0; owner UNASSIGNED; attempted true; duration 0 ms.

Source da2baff621fe03b21e614965bdb77510f32a62b9; harness 7c969b33068f811e006aac4cd130d5d95f0777f0.

### Real-life scenario

The application recovers from a controlled runtime failure. Scenario: GET health; connected test DB and disabled Firebase/Cloudinary reported..

### Prerequisites and reproduction

Disposable loopback MongoDB; fictional doctors A–E. A owns space S, B/C are members, D is unrelated and opts into requests only when specified, E defaults to opt-out. Create fresh phones for authentication boundaries. Use captured test-owned OTP/provider responses, never a real SMS service.

API/environment reproduction, not an observed UI journey. Run the owning module or retained sanity runner against a disposable target; literal routes, payloads, roles, boundary variants and DB/socket assertions appear in the definition below. Subscribe before triggering socket events. Do not replay mutations until green.

1. GET health
   Expected: Check the relevant constraint in the expected-result specification and executable definition below; the legacy runner does not emit per-step observations.
2. connected test DB and disabled Firebase/Cloudinary reported.
   Expected: GET health; connected test DB and disabled Firebase/Cloudinary reported.

### Expected and observed results

Contract: GET health; connected test DB and disabled Firebase/Cloudinary reported.

Observed: The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

Failing step: None reported

Assertion expected: Individual assertion expected value not captured; use the case contract and definition.

Assertion actual: Individual actual value not captured beyond the diagnostic above.

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: []

Scope/limitations: HTTP/MongoDB/Socket.IO scope only; no rendered Flutter UI, physical device or real provider delivery is proved. A failed assertion may stop later steps.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>No additional diagnostic recorded.</pre>

### Executable definition (procedure, not execution log)

tests/sanity/src/live-runner.js:16; SHA-256 d815200f48d37c2dadf72f741023aa9a5af2f92b56f05f9bc5c37545fc739ce4

<pre>        scenario: &#39;startup-01&#39;, result: &#39;passed&#39;, health, checkedAt: new Date().toISOString(),
      }, null, 2)}\n`);
      console.log(&#39;Startup scenario passed: isolated backend reports connected MongoDB and disabled Firebase/Cloudinary.&#39;);
      process.exit(0);
    }
    lastFailure = `unexpected health response: ${JSON.stringify(health)}`;
  } catch (error) {
    lastFailure = error.message;
  }
  await new Promise((resolveDelay) =&gt; setTimeout(resolveDelay, 1_000));
}

throw new Error(`Startup scenario failed before its deadline: ${lastFailure}`);
</pre>

tests/sanity/src/runner.js:43; SHA-256 5709d1f7eba4dd1407aaa92ca517c207cc6f3acebc36b0bb1420402e66d86ef6

<pre>  if (startup.result) results.push({ id: &#39;startup-01&#39;, status: startup.result, durationMs: 0 });
  const report = await writeExecutionReports({ outputDirectory, scenarioGroups, results, metadata: { upstreamSha: process.env.SANITY_UPSTREAM_SHA, harnessSha: process.env.SANITY_HARNESS_SHA, modules: outcomes } });
  if (report.result !== &#39;passed&#39; || outcomes.some((outcome) =&gt; outcome.code !== 0)) process.exitCode = [REDACTED];
}

main().catch((error) =&gt; {
  console.error(error.stack || error.message);
  process.exitCode = [REDACTED];
});
</pre>
