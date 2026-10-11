# Vocle regression report

Artifact: **Vocle report artifact**. Download and extract it, then open `vocle-regression-dashboard.html` locally.

[GitHub Actions run](https://github.com/Sriram4747/medcollab-beta-workflows/actions/runs/38131356746)

Suite: security; scope: cloudinary; original gate: **SUCCESS**.

Source: `b0471ba76f8efc28f3ee9add87cda0a12ec26526`; harness: `b0471ba76f8efc28f3ee9add87cda0a12ec26526`.

| PASS | FAIL | ERROR | BLOCKED | NEEDS_DECISION | SKIP | OBSERVATION |
| --- | --- | --- | --- | --- | --- | --- |
| 26 | 0 | 0 | 0 | 0 | 0 | 8 |

Selected 34; recorded rows 34; attempted 34. Missing evidence never means PASS.



No compatible baseline was supplied.

OBSERVATION preserves the original security outcome; it is neither an accepted expectation nor a confirmed vulnerability. Original non-blocking security gate behavior is unchanged. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage. Presentation refreshed without a new test execution.

## VOCLE-752 — Positive test-cloud binding and signed synthetic smoke

**PASS**; module configuration; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Positive test-cloud binding and signed synthetic smoke. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Positive test-cloud binding and signed synthetic smoke
   Expected: Exact positive allowlist match and signed PNG accepted only within this run
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Exact positive allowlist match and signed PNG accepted only within this run

Observed: \{
  &quot;allowlistMatched&quot;: true,
  &quot;signedUploadAccepted&quot;: true,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-001/file\_qzfvnq&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \}
\}

Failing step: None reported

Assertion expected: Exact positive allowlist match and signed PNG accepted only within this run

Assertion actual: \{
  &quot;allowlistMatched&quot;: true,
  &quot;signedUploadAccepted&quot;: true,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-001/file\_qzfvnq&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \}
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;allowlistMatched&quot;: true,
  &quot;signedUploadAccepted&quot;: true,
  &quot;identity&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-001/file_qzfvnq&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  }
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-753 — Application PNG upload resource identity

**PASS**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application PNG upload resource identity. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application PNG upload resource identity
   Expected: Real controller PNG stored as image/upload under broker run namespace
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Real controller PNG stored as image/upload under broker run namespace

Observed: \{
  &quot;status&quot;: 200,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-2/medcollab/messages/7ec000000000000000000001/synthetic\_e6jal9&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;brokerFolderAdaptation&quot;: true
\}

Failing step: None reported

Assertion expected: Real controller PNG stored as image/upload under broker run namespace

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-2/medcollab/messages/7ec000000000000000000001/synthetic\_e6jal9&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;brokerFolderAdaptation&quot;: true
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;identity&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-2/medcollab/messages/7ec000000000000000000001/synthetic_e6jal9&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  },
  &quot;brokerFolderAdaptation&quot;: true
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-754 — Image exact authenticated resource read

**PASS**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Image exact authenticated resource read. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Image exact authenticated resource read
   Expected: Exact provider metadata matches recorded public ID, asset ID and resource type
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Exact provider metadata matches recorded public ID, asset ID and resource type

Observed: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;
\}

Failing step: None reported

Assertion expected: Exact provider metadata matches recorded public ID, asset ID and resource type

Assertion actual: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-755 — Image HTTPS original retrieval

**PASS**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Image HTTPS original retrieval. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Image HTTPS original retrieval
   Expected: Approved-cloud HTTPS original returns image bytes
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Approved-cloud HTTPS original returns image bytes

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/png&quot;,
  &quot;bytes&quot;: 70,
  &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
  &quot;redirected&quot;: false
\}

Failing step: None reported

Assertion expected: Approved-cloud HTTPS original returns image bytes

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/png&quot;,
  &quot;bytes&quot;: 70,
  &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
  &quot;redirected&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/png&quot;,
  &quot;bytes&quot;: 70,
  &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
  &quot;redirected&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-756 — Application safe image thumbnail transformation

**PASS**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application safe image thumbnail transformation. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application safe image thumbnail transformation
   Expected: Controller 400x400 limit WebP thumbnail retrieves successfully
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Controller 400x400 limit WebP thumbnail retrieves successfully

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/webp&quot;,
  &quot;bytes&quot;: 44,
  &quot;sha256&quot;: &quot;83e0c98111545b7c1ab12c028c63b12f2785c917c75e10bf75077e329633cd43&quot;,
  &quot;redirected&quot;: false
\}

Failing step: None reported

Assertion expected: Controller 400x400 limit WebP thumbnail retrieves successfully

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/webp&quot;,
  &quot;bytes&quot;: 44,
  &quot;sha256&quot;: &quot;83e0c98111545b7c1ab12c028c63b12f2785c917c75e10bf75077e329633cd43&quot;,
  &quot;redirected&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/webp&quot;,
  &quot;bytes&quot;: 44,
  &quot;sha256&quot;: &quot;83e0c98111545b7c1ab12c028c63b12f2785c917c75e10bf75077e329633cd43&quot;,
  &quot;redirected&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-757 — Image anonymous delivery characterization

**PASS**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Image anonymous delivery characterization. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Image anonymous delivery characterization
   Expected: Measure unsigned synthetic delivery; public access does not establish clinical policy
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Measure unsigned synthetic delivery; public access does not establish clinical policy

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/png&quot;,
  &quot;bytes&quot;: 70,
  &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
  &quot;redirected&quot;: false,
  &quot;unsignedDelivery&quot;: true,
  &quot;anonymouslyRetrievable&quot;: true,
  &quot;policyApproval&quot;: false
\}

Failing step: None reported

Assertion expected: Measure unsigned synthetic delivery; public access does not establish clinical policy

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/png&quot;,
  &quot;bytes&quot;: 70,
  &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
  &quot;redirected&quot;: false,
  &quot;unsignedDelivery&quot;: true,
  &quot;anonymouslyRetrievable&quot;: true,
  &quot;policyApproval&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/png&quot;,
  &quot;bytes&quot;: 70,
  &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
  &quot;redirected&quot;: false,
  &quot;unsignedDelivery&quot;: true,
  &quot;anonymouslyRetrievable&quot;: true,
  &quot;policyApproval&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-758 — Application MP4 upload resource identity

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application MP4 upload resource identity. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application MP4 upload resource identity
   Expected: Real controller synthetic MP4 stored as video/upload
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Real controller synthetic MP4 stored as video/upload

Observed: \{
  &quot;status&quot;: 200,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-3/medcollab/messages/7ec000000000000000000001/synthetic\_qugpiq&quot;,
    &quot;resourceType&quot;: &quot;video&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;mp4&quot;,
    &quot;bytes&quot;: 1509,
    &quot;width&quot;: 16,
    &quot;height&quot;: 16,
    &quot;secureURLApproved&quot;: true
  \}
\}

Failing step: None reported

Assertion expected: Real controller synthetic MP4 stored as video/upload

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-3/medcollab/messages/7ec000000000000000000001/synthetic\_qugpiq&quot;,
    &quot;resourceType&quot;: &quot;video&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;mp4&quot;,
    &quot;bytes&quot;: 1509,
    &quot;width&quot;: 16,
    &quot;height&quot;: 16,
    &quot;secureURLApproved&quot;: true
  \}
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;identity&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-3/medcollab/messages/7ec000000000000000000001/synthetic_qugpiq&quot;,
    &quot;resourceType&quot;: &quot;video&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;mp4&quot;,
    &quot;bytes&quot;: 1509,
    &quot;width&quot;: 16,
    &quot;height&quot;: 16,
    &quot;secureURLApproved&quot;: true
  }
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-759 — Video exact authenticated resource read

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Video exact authenticated resource read. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Video exact authenticated resource read
   Expected: Exact video metadata exists and matches this run
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Exact video metadata exists and matches this run

Observed: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 1509,
  &quot;format&quot;: &quot;mp4&quot;
\}

Failing step: None reported

Assertion expected: Exact video metadata exists and matches this run

Assertion actual: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 1509,
  &quot;format&quot;: &quot;mp4&quot;
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 1509,
  &quot;format&quot;: &quot;mp4&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-760 — Video HTTPS original retrieval

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Video HTTPS original retrieval. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Video HTTPS original retrieval
   Expected: Synthetic video delivery returns video bytes
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Synthetic video delivery returns video bytes

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;video/mp4&quot;,
  &quot;bytes&quot;: 1509,
  &quot;sha256&quot;: &quot;d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7&quot;,
  &quot;redirected&quot;: false
\}

Failing step: None reported

Assertion expected: Synthetic video delivery returns video bytes

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;video/mp4&quot;,
  &quot;bytes&quot;: 1509,
  &quot;sha256&quot;: &quot;d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7&quot;,
  &quot;redirected&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;video/mp4&quot;,
  &quot;bytes&quot;: 1509,
  &quot;sha256&quot;: &quot;d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7&quot;,
  &quot;redirected&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-761 — Application video JPG thumbnail transformation

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application video JPG thumbnail transformation. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application video JPG thumbnail transformation
   Expected: Controller video frame transformation retrieves image bytes
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Controller video frame transformation retrieves image bytes

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/jpeg&quot;,
  &quot;bytes&quot;: 158,
  &quot;sha256&quot;: &quot;63927fcaf17b5ebee9ae1991c0fdeaf8d69bec0440a4456ff7cd010e47361f9f&quot;,
  &quot;redirected&quot;: false
\}

Failing step: None reported

Assertion expected: Controller video frame transformation retrieves image bytes

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/jpeg&quot;,
  &quot;bytes&quot;: 158,
  &quot;sha256&quot;: &quot;63927fcaf17b5ebee9ae1991c0fdeaf8d69bec0440a4456ff7cd010e47361f9f&quot;,
  &quot;redirected&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;image/jpeg&quot;,
  &quot;bytes&quot;: 158,
  &quot;sha256&quot;: &quot;63927fcaf17b5ebee9ae1991c0fdeaf8d69bec0440a4456ff7cd010e47361f9f&quot;,
  &quot;redirected&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-762 — Application owner video deletion limitation

**OBSERVATION**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application owner video deletion limitation. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application owner video deletion limitation
   Expected: Owner deletion should remove video; preserve existing VOCLE-736 finding if retained
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Owner deletion should remove video; preserve existing VOCLE-736 finding if retained

Observed: \{
  &quot;status&quot;: 403,
  &quot;videoRetained&quot;: true,
  &quot;dispatch&quot;: \[\]
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Owner deletion should remove video; preserve existing VOCLE-736 finding if retained

Assertion actual: \{
  &quot;status&quot;: 403,
  &quot;videoRetained&quot;: true,
  &quot;dispatch&quot;: \[\]
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described video scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 403,
  &quot;videoRetained&quot;: true,
  &quot;dispatch&quot;: []
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-763 — Independent explicit video deletion

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Independent explicit video deletion. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Independent explicit video deletion
   Expected: Correct video resource type destroy returns ok
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Correct video resource type destroy returns ok

Observed: \{
  &quot;result&quot;: &quot;ok&quot;
\}

Failing step: None reported

Assertion expected: Correct video resource type destroy returns ok

Assertion actual: \{
  &quot;result&quot;: &quot;ok&quot;
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;result&quot;: &quot;ok&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-764 — Video origin disappearance

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Video origin disappearance. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Video origin disappearance
   Expected: Exact authenticated video lookup returns 404 after deletion
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Exact authenticated video lookup returns 404 after deletion

Observed: \{
  &quot;exists&quot;: false
\}

Failing step: None reported

Assertion expected: Exact authenticated video lookup returns 404 after deletion

Assertion actual: \{
  &quot;exists&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;exists&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-765 — Video post-delete delivery behavior

**OBSERVATION**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Video post-delete delivery behavior. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Video post-delete delivery behavior
   Expected: Fresh original delivery should stop; report CDN persistence separately from origin absence
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Fresh original delivery should stop; report CDN persistence separately from origin absence

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;video/mp4&quot;,
  &quot;bytes&quot;: 1509,
  &quot;sha256&quot;: &quot;d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7&quot;,
  &quot;redirected&quot;: false,
  &quot;appInvalidateOmitted&quot;: true,
  &quot;independentTestDeletionInvalidate&quot;: false
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Fresh original delivery should stop; report CDN persistence separately from origin absence

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;video/mp4&quot;,
  &quot;bytes&quot;: 1509,
  &quot;sha256&quot;: &quot;d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7&quot;,
  &quot;redirected&quot;: false,
  &quot;appInvalidateOmitted&quot;: true,
  &quot;independentTestDeletionInvalidate&quot;: false
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described video scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;video/mp4&quot;,
  &quot;bytes&quot;: 1509,
  &quot;sha256&quot;: &quot;d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7&quot;,
  &quot;redirected&quot;: false,
  &quot;appInvalidateOmitted&quot;: true,
  &quot;independentTestDeletionInvalidate&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-766 — Repeated video deletion semantics

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Repeated video deletion semantics. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Repeated video deletion semantics
   Expected: Repeated exact video destroy returns not found
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Repeated exact video destroy returns not found

Observed: \{
  &quot;result&quot;: &quot;not found&quot;
\}

Failing step: None reported

Assertion expected: Repeated exact video destroy returns not found

Assertion actual: \{
  &quot;result&quot;: &quot;not found&quot;
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;result&quot;: &quot;not found&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-767 — Application PDF raw upload resource identity

**PASS**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application PDF raw upload resource identity. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application PDF raw upload resource identity
   Expected: Real controller synthetic PDF stored as raw/upload
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Real controller synthetic PDF stored as raw/upload

Observed: \{
  &quot;status&quot;: 200,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-4/medcollab/messages/7ec000000000000000000001/synthetic\_kpweul&quot;,
    &quot;resourceType&quot;: &quot;raw&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: null,
    &quot;bytes&quot;: 344,
    &quot;width&quot;: null,
    &quot;height&quot;: null,
    &quot;secureURLApproved&quot;: true
  \}
\}

Failing step: None reported

Assertion expected: Real controller synthetic PDF stored as raw/upload

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-4/medcollab/messages/7ec000000000000000000001/synthetic\_kpweul&quot;,
    &quot;resourceType&quot;: &quot;raw&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: null,
    &quot;bytes&quot;: 344,
    &quot;width&quot;: null,
    &quot;height&quot;: null,
    &quot;secureURLApproved&quot;: true
  \}
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;identity&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-4/medcollab/messages/7ec000000000000000000001/synthetic_kpweul&quot;,
    &quot;resourceType&quot;: &quot;raw&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: null,
    &quot;bytes&quot;: 344,
    &quot;width&quot;: null,
    &quot;height&quot;: null,
    &quot;secureURLApproved&quot;: true
  }
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-768 — Raw PDF exact authenticated resource read

**PASS**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Raw PDF exact authenticated resource read. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Raw PDF exact authenticated resource read
   Expected: Exact raw PDF metadata exists and matches this run
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Exact raw PDF metadata exists and matches this run

Observed: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null
\}

Failing step: None reported

Assertion expected: Exact raw PDF metadata exists and matches this run

Assertion actual: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-769 — Raw PDF HTTPS original delivery

**PASS**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Raw PDF HTTPS original delivery. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Raw PDF HTTPS original delivery
   Expected: Original synthetic PDF delivery returns exact fixture bytes
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Original synthetic PDF delivery returns exact fixture bytes

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;application/octet-stream&quot;,
  &quot;bytes&quot;: 344,
  &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
  &quot;redirected&quot;: false
\}

Failing step: None reported

Assertion expected: Original synthetic PDF delivery returns exact fixture bytes

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;application/octet-stream&quot;,
  &quot;bytes&quot;: 344,
  &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
  &quot;redirected&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;application/octet-stream&quot;,
  &quot;bytes&quot;: 344,
  &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
  &quot;redirected&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-770 — Application raw PDF attachment delivery

**PASS**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application raw PDF attachment delivery. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application raw PDF attachment delivery
   Expected: Controller attachment URL returns exact PDF bytes where account allows delivery
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Controller attachment URL returns exact PDF bytes where account allows delivery

Observed: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;application/octet-stream&quot;,
  &quot;bytes&quot;: 344,
  &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
  &quot;redirected&quot;: false,
  &quot;plainAttachmentControl&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;application/octet-stream&quot;,
    &quot;bytes&quot;: 344,
    &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;plainAttachmentSupported&quot;: true
\}

Failing step: None reported

Assertion expected: Controller attachment URL returns exact PDF bytes where account allows delivery

Assertion actual: \{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;application/octet-stream&quot;,
  &quot;bytes&quot;: 344,
  &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
  &quot;redirected&quot;: false,
  &quot;plainAttachmentControl&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;application/octet-stream&quot;,
    &quot;bytes&quot;: 344,
    &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;plainAttachmentSupported&quot;: true
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 200,
  &quot;contentType&quot;: &quot;application/octet-stream&quot;,
  &quot;bytes&quot;: 344,
  &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
  &quot;redirected&quot;: false,
  &quot;plainAttachmentControl&quot;: {
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;application/octet-stream&quot;,
    &quot;bytes&quot;: 344,
    &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
    &quot;redirected&quot;: false
  },
  &quot;plainAttachmentSupported&quot;: true
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-771 — Application raw PDF image preview compatibility

**PASS**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application raw PDF image preview compatibility. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application raw PDF image preview compatibility
   Expected: Measure actual image preview; URL construction alone cannot establish support
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Measure actual image preview; URL construction alone cannot establish support

Observed: \{
  &quot;appThumbnailProvided&quot;: false,
  &quot;appPreview&quot;: null,
  &quot;uploadedResourceType&quot;: &quot;raw&quot;,
  &quot;previewResourceType&quot;: &quot;image&quot;,
  &quot;previewSupported&quot;: false,
  &quot;imagePDFControl&quot;: \{
    &quot;identity&quot;: \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-005/file\_vyeuwm&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;deliveryType&quot;: &quot;upload&quot;,
      &quot;format&quot;: &quot;pdf&quot;,
      &quot;bytes&quot;: 344,
      &quot;width&quot;: 10,
      &quot;height&quot;: 10,
      &quot;secureURLApproved&quot;: true
    \},
    &quot;metadata&quot;: \{
      &quot;exists&quot;: true,
      &quot;identityMatched&quot;: true,
      &quot;bytes&quot;: 344,
      &quot;format&quot;: &quot;pdf&quot;
    \},
    &quot;preview&quot;: \{
      &quot;status&quot;: 200,
      &quot;contentType&quot;: &quot;image/webp&quot;,
      &quot;bytes&quot;: 38,
      &quot;sha256&quot;: &quot;a1e2f6dbda847380d13af6bd388778fe2d5c2a3b127c38a3924cbe31e1dd8de2&quot;,
      &quot;redirected&quot;: false
    \},
    &quot;previewSupported&quot;: true
  \}
\}

Failing step: None reported

Assertion expected: Measure actual image preview; URL construction alone cannot establish support

Assertion actual: \{
  &quot;appThumbnailProvided&quot;: false,
  &quot;appPreview&quot;: null,
  &quot;uploadedResourceType&quot;: &quot;raw&quot;,
  &quot;previewResourceType&quot;: &quot;image&quot;,
  &quot;previewSupported&quot;: false,
  &quot;imagePDFControl&quot;: \{
    &quot;identity&quot;: \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-005/file\_vyeuwm&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;deliveryType&quot;: &quot;upload&quot;,
      &quot;format&quot;: &quot;pdf&quot;,
      &quot;bytes&quot;: 344,
      &quot;width&quot;: 10,
      &quot;height&quot;: 10,
      &quot;secureURLApproved&quot;: true
    \},
    &quot;metadata&quot;: \{
      &quot;exists&quot;: true,
      &quot;identityMatched&quot;: true,
      &quot;bytes&quot;: 344,
      &quot;format&quot;: &quot;pdf&quot;
    \},
    &quot;preview&quot;: \{
      &quot;status&quot;: 200,
      &quot;contentType&quot;: &quot;image/webp&quot;,
      &quot;bytes&quot;: 38,
      &quot;sha256&quot;: &quot;a1e2f6dbda847380d13af6bd388778fe2d5c2a3b127c38a3924cbe31e1dd8de2&quot;,
      &quot;redirected&quot;: false
    \},
    &quot;previewSupported&quot;: true
  \}
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;appThumbnailProvided&quot;: false,
  &quot;appPreview&quot;: null,
  &quot;uploadedResourceType&quot;: &quot;raw&quot;,
  &quot;previewResourceType&quot;: &quot;image&quot;,
  &quot;previewSupported&quot;: false,
  &quot;imagePDFControl&quot;: {
    &quot;identity&quot;: {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-005/file_vyeuwm&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;deliveryType&quot;: &quot;upload&quot;,
      &quot;format&quot;: &quot;pdf&quot;,
      &quot;bytes&quot;: 344,
      &quot;width&quot;: 10,
      &quot;height&quot;: 10,
      &quot;secureURLApproved&quot;: true
    },
    &quot;metadata&quot;: {
      &quot;exists&quot;: true,
      &quot;identityMatched&quot;: true,
      &quot;bytes&quot;: 344,
      &quot;format&quot;: &quot;pdf&quot;
    },
    &quot;preview&quot;: {
      &quot;status&quot;: 200,
      &quot;contentType&quot;: &quot;image/webp&quot;,
      &quot;bytes&quot;: 38,
      &quot;sha256&quot;: &quot;a1e2f6dbda847380d13af6bd388778fe2d5c2a3b127c38a3924cbe31e1dd8de2&quot;,
      &quot;redirected&quot;: false
    },
    &quot;previewSupported&quot;: true
  }
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-772 — Application owner raw deletion

**OBSERVATION**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application owner raw deletion. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application owner raw deletion
   Expected: Unchanged controller image-then-raw deletion removes owned PDF
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Unchanged controller image-then-raw deletion removes owned PDF

Observed: \{
  &quot;status&quot;: 403,
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Unchanged controller image-then-raw deletion removes owned PDF

Assertion actual: \{
  &quot;status&quot;: 403,
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described raw scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 403,
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-773 — Raw origin disappearance and post-delete retrieval

**OBSERVATION**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Raw origin disappearance and post-delete retrieval. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Raw origin disappearance and post-delete retrieval
   Expected: Exact authenticated raw lookup returns 404; measure original delivery separately for cache persistence
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Exact authenticated raw lookup returns 404; measure original delivery separately for cache persistence

Observed: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;application/octet-stream&quot;,
    &quot;bytes&quot;: 344,
    &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;originAbsenceIndependentOfCDN&quot;: true
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Exact authenticated raw lookup returns 404; measure original delivery separately for cache persistence

Assertion actual: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;application/octet-stream&quot;,
    &quot;bytes&quot;: 344,
    &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;originAbsenceIndependentOfCDN&quot;: true
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described raw scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 344,
  &quot;format&quot;: null,
  &quot;delivery&quot;: {
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;application/octet-stream&quot;,
    &quot;bytes&quot;: 344,
    &quot;sha256&quot;: &quot;b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78&quot;,
    &quot;redirected&quot;: false
  },
  &quot;originAbsenceIndependentOfCDN&quot;: true
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-774 — Repeated raw deletion semantics

**OBSERVATION**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Repeated raw deletion semantics. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Repeated raw deletion semantics
   Expected: Repeated exact raw destroy returns not found
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Repeated exact raw destroy returns not found

Observed: \{
  &quot;result&quot;: &quot;ok&quot;
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Repeated exact raw destroy returns not found

Assertion actual: \{
  &quot;result&quot;: &quot;ok&quot;
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described raw scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;result&quot;: &quot;ok&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-775 — Application owner image deletion

**OBSERVATION**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application owner image deletion. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application owner image deletion
   Expected: Unchanged controller removes owned image
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Unchanged controller removes owned image

Observed: \{
  &quot;status&quot;: 403,
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Unchanged controller removes owned image

Assertion actual: \{
  &quot;status&quot;: 403,
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described image scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 403,
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-776 — Image origin disappearance, retrieval and repeated deletion

**OBSERVATION**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Image origin disappearance, retrieval and repeated deletion. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Image origin disappearance, retrieval and repeated deletion
   Expected: Image exact lookup absent, repeated destroy not found; measure original delivery separately
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Image exact lookup absent, repeated destroy not found; measure original delivery separately

Observed: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;,
  &quot;result&quot;: &quot;ok&quot;,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;originAbsenceIndependentOfCDN&quot;: true
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Image exact lookup absent, repeated destroy not found; measure original delivery separately

Assertion actual: \{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;,
  &quot;result&quot;: &quot;ok&quot;,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;originAbsenceIndependentOfCDN&quot;: true
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described image scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;exists&quot;: true,
  &quot;identityMatched&quot;: true,
  &quot;bytes&quot;: 70,
  &quot;format&quot;: &quot;png&quot;,
  &quot;result&quot;: &quot;ok&quot;,
  &quot;delivery&quot;: {
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
    &quot;redirected&quot;: false
  },
  &quot;originAbsenceIndependentOfCDN&quot;: true
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-777 — Same-folder duplicate filenames and generated IDs

**PASS**; module naming; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Same-folder duplicate filenames and generated IDs. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Same-folder duplicate filenames and generated IDs
   Expected: Provider generates distinct IDs for duplicate synthetic filenames without overwriting
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Provider generates distinct IDs for duplicate synthetic filenames without overwriting

Observed: \{
  &quot;distinctIds&quot;: true,
  &quot;first&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_bhemsa&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;second&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_tw74iz&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;filenameOverrideControlsID&quot;: true
\}

Failing step: None reported

Assertion expected: Provider generates distinct IDs for duplicate synthetic filenames without overwriting

Assertion actual: \{
  &quot;distinctIds&quot;: true,
  &quot;first&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_bhemsa&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;second&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_tw74iz&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;filenameOverrideControlsID&quot;: true
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;distinctIds&quot;: true,
  &quot;first&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate_bhemsa&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  },
  &quot;second&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate_tw74iz&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  },
  &quot;filenameOverrideControlsID&quot;: true
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-778 — Explicit overwrite false preserves original

**PASS**; module naming; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Explicit overwrite false preserves original. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Explicit overwrite false preserves original
   Expected: Second same-ID upload with overwrite false preserves original exact resource
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Second same-ID upload with overwrite false preserves original exact resource

Observed: \{
  &quot;secondRejected&quot;: false,
  &quot;existingReturned&quot;: true,
  &quot;identityPreserved&quot;: true,
  &quot;versionPreserved&quot;: true,
  &quot;differentSyntheticBytesAttempted&quot;: true,
  &quot;originalBytesPreserved&quot;: true,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
    &quot;redirected&quot;: false
  \}
\}

Failing step: None reported

Assertion expected: Second same-ID upload with overwrite false preserves original exact resource

Assertion actual: \{
  &quot;secondRejected&quot;: false,
  &quot;existingReturned&quot;: true,
  &quot;identityPreserved&quot;: true,
  &quot;versionPreserved&quot;: true,
  &quot;differentSyntheticBytesAttempted&quot;: true,
  &quot;originalBytesPreserved&quot;: true,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
    &quot;redirected&quot;: false
  \}
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;secondRejected&quot;: false,
  &quot;existingReturned&quot;: true,
  &quot;identityPreserved&quot;: true,
  &quot;versionPreserved&quot;: true,
  &quot;differentSyntheticBytesAttempted&quot;: true,
  &quot;originalBytesPreserved&quot;: true,
  &quot;delivery&quot;: {
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f&quot;,
    &quot;redirected&quot;: false
  }
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-779 — Explicit overwrite true characterization

**PASS**; module naming; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Explicit overwrite true characterization. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Explicit overwrite true characterization
   Expected: Bounded owned same-ID overwrite is accepted; record actual version and bytes
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Bounded owned same-ID overwrite is accepted; record actual version and bytes

Observed: \{
  &quot;accepted&quot;: true,
  &quot;previousVersion&quot;: 1791713807,
  &quot;returnedVersion&quot;: 1791713808,
  &quot;differentSyntheticBytesOnly&quot;: true,
  &quot;replacementBytesVerified&quot;: true,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;d5a51b6aed15684ec8c123e30fe5703155359d6543b6d7b47cb5766ef44939de&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;productionOverwritePolicyVerified&quot;: false
\}

Failing step: None reported

Assertion expected: Bounded owned same-ID overwrite is accepted; record actual version and bytes

Assertion actual: \{
  &quot;accepted&quot;: true,
  &quot;previousVersion&quot;: 1791713807,
  &quot;returnedVersion&quot;: 1791713808,
  &quot;differentSyntheticBytesOnly&quot;: true,
  &quot;replacementBytesVerified&quot;: true,
  &quot;delivery&quot;: \{
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;d5a51b6aed15684ec8c123e30fe5703155359d6543b6d7b47cb5766ef44939de&quot;,
    &quot;redirected&quot;: false
  \},
  &quot;productionOverwritePolicyVerified&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;accepted&quot;: true,
  &quot;previousVersion&quot;: 1791713807,
  &quot;returnedVersion&quot;: 1791713808,
  &quot;differentSyntheticBytesOnly&quot;: true,
  &quot;replacementBytesVerified&quot;: true,
  &quot;delivery&quot;: {
    &quot;status&quot;: 200,
    &quot;contentType&quot;: &quot;image/png&quot;,
    &quot;bytes&quot;: 70,
    &quot;sha256&quot;: &quot;d5a51b6aed15684ec8c123e30fe5703155359d6543b6d7b47cb5766ef44939de&quot;,
    &quot;redirected&quot;: false
  },
  &quot;productionOverwritePolicyVerified&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-780 — Same public ID resource-type separation

**PASS**; module naming; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Same public ID resource-type separation. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Same public ID resource-type separation
   Expected: Image/raw same public ID remain independently typed resources
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Image/raw same public ID remain independently typed resources

Observed: \{
  &quot;samePublicId&quot;: true,
  &quot;independentResourceTypes&quot;: \[
    &quot;image&quot;,
    &quot;raw&quot;
  \]
\}

Failing step: None reported

Assertion expected: Image/raw same public ID remain independently typed resources

Assertion actual: \{
  &quot;samePublicId&quot;: true,
  &quot;independentResourceTypes&quot;: \[
    &quot;image&quot;,
    &quot;raw&quot;
  \]
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;samePublicId&quot;: true,
  &quot;independentResourceTypes&quot;: [
    &quot;image&quot;,
    &quot;raw&quot;
  ]
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-781 — Namespace and forged filename isolation

**PASS**; module naming; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Namespace and forged filename isolation. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Namespace and forged filename isolation
   Expected: Controller unsafe original filename cannot escape the broker run namespace
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Controller unsafe original filename cannot escape the broker run namespace

Observed: \{
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-13/medcollab/messages/7ec000000000000000000001/..\_.\_fjzll2&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;originalFilenameSanitized&quot;: &quot;..\_..\_synthetic-\(canary\)&quot;,
  &quot;normalAppFolderPreservedUnderRunRoot&quot;: true,
  &quot;expectedFolderMatched&quot;: true,
  &quot;canonicalSegmentsSafe&quot;: true
\}

Failing step: None reported

Assertion expected: Controller unsafe original filename cannot escape the broker run namespace

Assertion actual: \{
  &quot;identity&quot;: \{
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-13/medcollab/messages/7ec000000000000000000001/..\_.\_fjzll2&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  \},
  &quot;originalFilenameSanitized&quot;: &quot;..\_..\_synthetic-\(canary\)&quot;,
  &quot;normalAppFolderPreservedUnderRunRoot&quot;: true,
  &quot;expectedFolderMatched&quot;: true,
  &quot;canonicalSegmentsSafe&quot;: true
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;identity&quot;: {
    &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-13/medcollab/messages/7ec000000000000000000001/.._._fjzll2&quot;,
    &quot;resourceType&quot;: &quot;image&quot;,
    &quot;deliveryType&quot;: &quot;upload&quot;,
    &quot;format&quot;: &quot;png&quot;,
    &quot;bytes&quot;: 70,
    &quot;width&quot;: 1,
    &quot;height&quot;: 1,
    &quot;secureURLApproved&quot;: true
  },
  &quot;originalFilenameSanitized&quot;: &quot;.._.._synthetic-(canary)&quot;,
  &quot;normalAppFolderPreservedUnderRunRoot&quot;: true,
  &quot;expectedFolderMatched&quot;: true,
  &quot;canonicalSegmentsSafe&quot;: true
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-782 — Application octet-PDF provider dispatch

**PASS**; module raw; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application octet-PDF provider dispatch. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application octet-PDF provider dispatch
   Expected: Octet-PDF should select raw; actual image intent remains VOCLE-724 observation
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Octet-PDF should select raw; actual image intent remains VOCLE-724 observation

Observed: \{
  &quot;requestedType&quot;: &quot;raw&quot;,
  &quot;expectedType&quot;: &quot;raw&quot;,
  &quot;appStatus&quot;: 200,
  &quot;providerAccepted&quot;: true,
  &quot;storedType&quot;: &quot;raw&quot;,
  &quot;providerRejectionStatus&quot;: null
\}

Failing step: None reported

Assertion expected: Octet-PDF should select raw; actual image intent remains VOCLE-724 observation

Assertion actual: \{
  &quot;requestedType&quot;: &quot;raw&quot;,
  &quot;expectedType&quot;: &quot;raw&quot;,
  &quot;appStatus&quot;: 200,
  &quot;providerAccepted&quot;: true,
  &quot;storedType&quot;: &quot;raw&quot;,
  &quot;providerRejectionStatus&quot;: null
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;requestedType&quot;: &quot;raw&quot;,
  &quot;expectedType&quot;: &quot;raw&quot;,
  &quot;appStatus&quot;: 200,
  &quot;providerAccepted&quot;: true,
  &quot;storedType&quot;: &quot;raw&quot;,
  &quot;providerRejectionStatus&quot;: null
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-783 — Application octet-MP4 provider dispatch

**PASS**; module video; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application octet-MP4 provider dispatch. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application octet-MP4 provider dispatch
   Expected: Octet-MP4 should select video; actual image intent remains VOCLE-725 observation
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Octet-MP4 should select video; actual image intent remains VOCLE-725 observation

Observed: \{
  &quot;requestedType&quot;: &quot;video&quot;,
  &quot;expectedType&quot;: &quot;video&quot;,
  &quot;appStatus&quot;: 200,
  &quot;providerAccepted&quot;: true,
  &quot;storedType&quot;: &quot;video&quot;,
  &quot;providerRejectionStatus&quot;: null
\}

Failing step: None reported

Assertion expected: Octet-MP4 should select video; actual image intent remains VOCLE-725 observation

Assertion actual: \{
  &quot;requestedType&quot;: &quot;video&quot;,
  &quot;expectedType&quot;: &quot;video&quot;,
  &quot;appStatus&quot;: 200,
  &quot;providerAccepted&quot;: true,
  &quot;storedType&quot;: &quot;video&quot;,
  &quot;providerRejectionStatus&quot;: null
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;requestedType&quot;: &quot;video&quot;,
  &quot;expectedType&quot;: &quot;video&quot;,
  &quot;appStatus&quot;: 200,
  &quot;providerAccepted&quot;: true,
  &quot;storedType&quot;: &quot;video&quot;,
  &quot;providerRejectionStatus&quot;: null
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-784 — Application shared handoff deletion limitation

**OBSERVATION**; module image; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Application shared handoff deletion limitation. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Application shared handoff deletion limitation
   Expected: Uploader should remove handoff asset; existing VOCLE-740 observation if forbidden
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: Uploader should remove handoff asset; existing VOCLE-740 observation if forbidden

Observed: \{
  &quot;status&quot;: 403,
  &quot;retained&quot;: true,
  &quot;originalFolder&quot;: &quot;medcollab/handoffs&quot;
\}

Failing step: Exact step index not captured by the original runner; inspect diagnostic and definition.

Assertion expected: Uploader should remove handoff asset; existing VOCLE-740 observation if forbidden

Assertion actual: \{
  &quot;status&quot;: 403,
  &quot;retained&quot;: true,
  &quot;originalFolder&quot;: &quot;medcollab/handoffs&quot;
\}

Classification: SECURITY\_OBSERVATION\_REQUIRES\_REVIEW

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner recorded a non-passing case. Later actions may not have been reached; diagnostic evidence is shown without changing its classification.

Inferred consequence, not an observed production/UI incident: the described image scenario is not fully verified. The diagnostic identifies the observed failure; its wider impact requires investigation.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;status&quot;: 403,
  &quot;retained&quot;: true,
  &quot;originalFolder&quot;: &quot;medcollab/handoffs&quot;
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.

## VOCLE-785 — Independent manifest cleanup and exact absence verification

**PASS**; module cleanup; tier SECURITY; priority UNSPECIFIED; owner UNASSIGNED; attempted true; duration not recorded ms.

Source b0471ba76f8efc28f3ee9add87cda0a12ec26526; harness b0471ba76f8efc28f3ee9add87cda0a12ec26526.

### Real-life scenario

Independent manifest cleanup and exact absence verification. Execute the documented isolated security probe.

### Prerequisites and reproduction

Use only deterministic synthetic fixtures in the owning suite. Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

API/environment procedure; no UI or production incident is claimed. Use the owning workflow at the recorded source revision.

1. Prepare the owning suite fixtures and safety prerequisites.
   Expected: Isolation and prerequisites verified before the action.
2. Independent manifest cleanup and exact absence verification
   Expected: All recorded image/video/raw resources removed; no unresolved upload intents
3. Independently inspect the recorded database, transport/provider and cleanup evidence.
   Expected: Recorded semantic checks and resource cleanup satisfy the unchanged suite contract.

### Expected and observed results

Contract: All recorded image/video/raw resources removed; no unresolved upload intents

Observed: \{
  &quot;attempted&quot;: true,
  &quot;resources&quot;: \[
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-001/file\_qzfvnq&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-2/medcollab/messages/7ec000000000000000000001/synthetic\_e6jal9&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-3/medcollab/messages/7ec000000000000000000001/synthetic\_qugpiq&quot;,
      &quot;resourceType&quot;: &quot;video&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-4/medcollab/messages/7ec000000000000000000001/synthetic\_kpweul&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-005/file\_vyeuwm&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_bhemsa&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_tw74iz&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/overwrite/synthetic&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/type-separation/synthetic&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/type-separation/synthetic&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-13/medcollab/messages/7ec000000000000000000001/..\_.\_fjzll2&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-14/medcollab/messages/7ec000000000000000000001/synthetic\_u1dpnu&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-15/medcollab/messages/7ec000000000000000000001/synthetic\_kgcdrg&quot;,
      &quot;resourceType&quot;: &quot;video&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-16/medcollab/handoffs/synthetic\_lazv9o&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \}
  \],
  &quot;pendingUnresolved&quot;: 0,
  &quot;proven&quot;: true,
  &quot;broadDeletionUsed&quot;: false
\}

Failing step: None reported

Assertion expected: All recorded image/video/raw resources removed; no unresolved upload intents

Assertion actual: \{
  &quot;attempted&quot;: true,
  &quot;resources&quot;: \[
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-001/file\_qzfvnq&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-2/medcollab/messages/7ec000000000000000000001/synthetic\_e6jal9&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-3/medcollab/messages/7ec000000000000000000001/synthetic\_qugpiq&quot;,
      &quot;resourceType&quot;: &quot;video&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-4/medcollab/messages/7ec000000000000000000001/synthetic\_kpweul&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-005/file\_vyeuwm&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_bhemsa&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate\_tw74iz&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/overwrite/synthetic&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/type-separation/synthetic&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/type-separation/synthetic&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-13/medcollab/messages/7ec000000000000000000001/..\_.\_fjzll2&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-14/medcollab/messages/7ec000000000000000000001/synthetic\_u1dpnu&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-15/medcollab/messages/7ec000000000000000000001/synthetic\_kgcdrg&quot;,
      &quot;resourceType&quot;: &quot;video&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \},
    \{
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-16/medcollab/handoffs/synthetic\_lazv9o&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    \}
  \],
  &quot;pendingUnresolved&quot;: 0,
  &quot;proven&quot;: true,
  &quot;broadDeletionUsed&quot;: false
\}

Classification: PASS

Root cause: UNKNOWN. This report does not infer a root cause from a status or similar message.

The runner reports that this case completed successfully. The executable checks below define its verified scope; individual intermediate values were not recorded unless shown in the evidence.

This recorded execution protects the described scenario within its stated scope.

Explicit subassertion evidence: \[\]

Scope/limitations: Only existing recorded provider evidence is reported. No provider operations are performed by reporting. Controller-level evidence does not prove route/auth/database coverage.

Product questions: none linked

Evidence files: No additional files available.

### Sanitized diagnostic

<pre>{
  &quot;attempted&quot;: true,
  &quot;resources&quot;: [
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-001/file_qzfvnq&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-2/medcollab/messages/7ec000000000000000000001/synthetic_e6jal9&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-3/medcollab/messages/7ec000000000000000000001/synthetic_qugpiq&quot;,
      &quot;resourceType&quot;: &quot;video&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-4/medcollab/messages/7ec000000000000000000001/synthetic_kpweul&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;not found&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/op-005/file_vyeuwm&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate_bhemsa&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/duplicate-names/synthetic-duplicate_tw74iz&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/overwrite/synthetic&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/type-separation/synthetic&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/type-separation/synthetic&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-13/medcollab/messages/7ec000000000000000000001/.._._fjzll2&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-14/medcollab/messages/7ec000000000000000000001/synthetic_u1dpnu&quot;,
      &quot;resourceType&quot;: &quot;raw&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-15/medcollab/messages/7ec000000000000000000001/synthetic_kgcdrg&quot;,
      &quot;resourceType&quot;: &quot;video&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    },
    {
      &quot;publicId&quot;: &quot;medcollab/security-test/38131356746-1-48904a8c-8743-4a8c-b777-0680ea12caae/app-16/medcollab/handoffs/synthetic_lazv9o&quot;,
      &quot;resourceType&quot;: &quot;image&quot;,
      &quot;destroyResult&quot;: &quot;ok&quot;,
      &quot;originAbsent&quot;: true
    }
  ],
  &quot;pendingUnresolved&quot;: 0,
  &quot;proven&quot;: true,
  &quot;broadDeletionUsed&quot;: false
}</pre>

### Executable definition (procedure, not execution log)

Definition location unavailable; original tooling reproduction is shown above.
