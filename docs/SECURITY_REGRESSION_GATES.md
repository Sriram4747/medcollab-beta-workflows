# Final-validation reconciliation — 2026-10-06

Primary handoff: [Vocle Developer Remediation Report](VOCLE_DEVELOPER_REMEDIATION_REPORT.md). Fresh evidence covers816 unique security IDs,696 passes/120 observations; final broad613/78,offline62/35,real27/7,data22/9. Historical124 registry entries are retained;171/355 are resolved testing issues,773/776 are currently passing variable cache characterizations with no app change. Candidate counts62/62 and zero active gates remain unchanged. JSON latestValidation fields record exact current evidence; do not regenerate from historical sources and discard this overlay. Two upstream sanity failures and four dependent blocks are separately documented.

---

# Security regression gate registry

Evidence runs: 37175207493, 37181051425, 37355451614, 37358018047, 37359326520. **62 after-remediation candidates; 62 observations excluded; zero active application gates.**

This is a requirement registry, not an active gating configuration. The discovery runner still records application differences as observations. No application fix is known in the executed source. Existing policy, hardening and ambiguous cases cannot become blocking automatically.

After a fix: identify its commit; review the status, denial payload, state and semantic assertion; run the real isolated workflow with successful controls; then explicitly activate a versioned strict requirement gate. A passing run alone never activates a gate. Preserve old evidence and frozen IDs; append or deliberately version corrected secure assertions where a legacy disclosure callback cannot pass a denial response.

The JSON registry maps every observed testcase to requirement, current status, fix status and activation rule. Realtime gates also need positive producer/delivery controls; malformed-payload gates must allow the fixed handler to return safely rather than waiting for a failure diagnostic.

The latest reviewed evidence for a reused testcase supersedes its old observation details, while all source references/history remain preserved. Related IDs share a root rather than representing new vulnerabilities. Functional provider contracts are explicitly labeled separately from confirmed security defects. Cache/retention/account and data-layer hardening questions remain excluded. No current application finding is eligible to block immediately; no remediation commit is established.

Infrastructure, positive-cloud allowlisting, credential exclusion, transport isolation, artifact hygiene, execution prerequisites and exact cleanup already fail their respective workflows independently of application observation status. The registry itself does not implement a strict runner or change any CI trigger.

| Testcase | Root | Candidate | Current status / fix |
| --- | --- | --- | --- |
| VOCLE-094 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-098 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-099 | S2 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-110 | H1 | excluded | observed / unresolved review |
| VOCLE-112 | H1 | excluded | observed / unresolved review |
| VOCLE-159 | S3 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-171 | BASELINE_SEMANTICS | excluded | PASS / resolved test-harness issue |
| VOCLE-193 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-197 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-267 | S4 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-268 | S4 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-270 | S4 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-271 | S4 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-272 | S5 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-273 | S3 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-275 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-276 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-301 | H2 | excluded | observed / unresolved review |
| VOCLE-302 | H2 | excluded | observed / unresolved review |
| VOCLE-303 | H2 | excluded | observed / unresolved review |
| VOCLE-304 | H2 | excluded | observed / unresolved review |
| VOCLE-306 | H3 | excluded | observed / unresolved review |
| VOCLE-307 | H3 | excluded | observed / unresolved review |
| VOCLE-313 | S6 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-314 | S6 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-323 | U1 | excluded | observed / unresolved review |
| VOCLE-339 | S7 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-340 | S7 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-342 | S7 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-343 | S7 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-345 | S7 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-346 | S7 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-347 | S8 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-348 | S9 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-349 | S9 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-355 | BASELINE_SEMANTICS | excluded | PASS / resolved test-harness issue |
| VOCLE-356 | AUTH_WIDGET | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-357 | AUTH_WIDGET | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-398 | PUBLIC_PROFILE | excluded | observed / unresolved review |
| VOCLE-421 | SEARCH_SPACE_FILTER | excluded | observed / unresolved review |
| VOCLE-429 | N1_NEEDL_ACCESS | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-434 | N1_NEEDL_ACCESS | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-503 | N1_NEEDL_ACCESS | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-509 | N1_NEEDL_ACCESS | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-527 | GROUP_TARGET_STATE | excluded | observed / unresolved review |
| VOCLE-528 | GROUP_TARGET_STATE | excluded | observed / unresolved review |
| VOCLE-529 | GROUP_CONSENT | excluded | observed / unresolved review |
| VOCLE-530 | GROUP_CONSENT | excluded | observed / unresolved review |
| VOCLE-572 | HANDOFF_TARGET_STATE | excluded | observed / unresolved review |
| VOCLE-574 | REMOVED_HANDOFF_PARTY | excluded | observed / unresolved review |
| VOCLE-575 | REMOVED_HANDOFF_PARTY | excluded | observed / unresolved review |
| VOCLE-594 | N2_PRIVATE_PIN | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-595 | N2_PRIVATE_PIN | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-599 | ARCHIVED_PIN | excluded | observed / unresolved review |
| VOCLE-603 | N3_MENTION_AUDIENCE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-604 | N3_MENTION_AUDIENCE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-605 | INACTIVE_MENTION | excluded | observed / unresolved review |
| VOCLE-611 | SUPPORT_TYPE | excluded | observed / unresolved review |
| VOCLE-618 | SUPPORT_TYPE | excluded | observed / unresolved review |
| VOCLE-625 | SUPPORT_TYPE | excluded | observed / unresolved review |
| VOCLE-641 | DEV_NOTIFICATION_REFERENCES | excluded | observed / unresolved review |
| VOCLE-653 | SOCKET_EXPIRY_POLICY | excluded | observed / unresolved review |
| VOCLE-654 | R1_ACTIVE_SOCKET | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-655 | R1_ACTIVE_SOCKET | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-659 | R2_SPACE_PRESENCE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-660 | R2_SPACE_PRESENCE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-662 | S9 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-663 | R3_TYPING_CACHE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-672 | SOCKET_ASYNC_PAYLOAD | excluded | observed / unresolved review |
| VOCLE-673 | R4_SOCKET_CRASH | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-674 | R4_SOCKET_CRASH | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-675 | R4_SOCKET_CRASH | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-676 | SOCKET_ASYNC_PAYLOAD | excluded | observed / unresolved review |
| VOCLE-678 | R5_RECOVERY_AUTH | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-679 | R5_RECOVERY_AUTH | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-680 | R5_RECOVERY_AUTH | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-681 | S9 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-685 | N3_MENTION_AUDIENCE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-686 | N3_MENTION_AUDIENCE | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-687 | A1_OTP_CONSUMPTION | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-698 | H3 | excluded | observed / unresolved review |
| VOCLE-699 | H2 | excluded | observed / unresolved review |
| VOCLE-700 | H2 | excluded | observed / unresolved review |
| VOCLE-701 | media-octet-metadata | excluded | observed / unresolved review |
| VOCLE-704 | S6 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-705 | media-shared-handoff | excluded | observed / unresolved review |
| VOCLE-709 | media-reference-lifecycle | excluded | observed / unresolved review |
| VOCLE-710 | media-reference-lifecycle | excluded | observed / unresolved review |
| VOCLE-713 | media-reference-validation | excluded | observed / unresolved review |
| VOCLE-714 | media-reference-validation | excluded | observed / unresolved review |
| VOCLE-715 | media-reference-validation | excluded | observed / unresolved review |
| VOCLE-716 | media-reference-validation | excluded | observed / unresolved review |
| VOCLE-717 | media-reference-validation | excluded | observed / unresolved review |
| VOCLE-721 | media-shared-handoff | excluded | observed / unresolved review |
| VOCLE-724 | media-octet-resource-type | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-725 | media-octet-resource-type | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-727 | media-overwrite-intent | excluded | observed / unresolved review |
| VOCLE-733 | media-context-validation | excluded | observed / unresolved review |
| VOCLE-736 | media-video-delete | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-737 | media-invalidation-intent | excluded | observed / unresolved review |
| VOCLE-739 | media-namespace-validation | excluded | observed / unresolved review |
| VOCLE-740 | media-shared-handoff | excluded | observed / unresolved review |
| VOCLE-743 | media-compensation | excluded | observed / unresolved review |
| VOCLE-746 | media-video-message | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-747 | media-reference-lifecycle | excluded | observed / unresolved review |
| VOCLE-750 | H3 | excluded | observed / unresolved review |
| VOCLE-762 | media-video-delete | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-765 | media-invalidation-intent | excluded | observed / unresolved review |
| VOCLE-770 | CLOUDINARY_PDF_ATTACHMENT | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-771 | CLOUDINARY_PDF_PREVIEW | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-773 | media-invalidation-intent | excluded | PASS current bounded cache probe / policy remains open |
| VOCLE-776 | media-invalidation-intent | excluded | PASS current bounded cache probe / policy remains open |
| VOCLE-782 | media-octet-resource-type | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-783 | media-octet-resource-type | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-784 | media-shared-handoff | excluded | observed / unresolved review |
| VOCLE-790 | DATA_DEFAULT_PROJECTION | excluded | observed / unresolved review |
| VOCLE-797 | DATA_REQUEST_UNIQUENESS | excluded | observed / unresolved review |
| VOCLE-803 | DATA_NOTIFICATION_EXPIRY | excluded | observed / unresolved review |
| VOCLE-805 | DATA_DELETED_EDIT | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-806 | DATA_PREVIEW_RETENTION | excluded | observed / unresolved review |
| VOCLE-808 | DATA_INACTIVE_SPACE | excluded | observed / unresolved review |
| VOCLE-809 | DATA_ORPHAN_REFS | excluded | observed / unresolved review |
| VOCLE-815 | DATA_DEVICE_TRANSFER | excluded | observed / unresolved review |
| VOCLE-816 | DATA_UPDATE_VALIDATION | excluded | observed / unresolved review |

Machine-readable details: [SECURITY_REGRESSION_GATES.json](SECURITY_REGRESSION_GATES.json).
