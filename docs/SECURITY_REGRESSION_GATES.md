# Security regression gate registry

Evidence run: 37175207493. **51 confirmed-case candidates; 29 observations excluded; zero active gates.**

This is a requirement registry, not an active gating configuration. The discovery runner still records application differences as observations. No application fix is known in the executed source. Existing policy, hardening and ambiguous cases cannot become blocking automatically.

After a fix: identify its commit; review the status, denial payload, state and semantic assertion; run the real isolated workflow with successful controls; then explicitly activate a versioned strict requirement gate. A passing run alone never activates a gate. Preserve old evidence and frozen IDs; append or deliberately version corrected secure assertions where a legacy disclosure callback cannot pass a denial response.

The JSON registry maps every observed testcase to requirement, current status, fix status and activation rule. Realtime gates also need positive producer/delivery controls; malformed-payload gates must allow the fixed handler to return safely rather than waiting for a failure diagnostic.

| Testcase | Root | Candidate | Current status / fix |
| --- | --- | --- | --- |
| VOCLE-094 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-098 | S1 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-099 | S2 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-110 | H1 | excluded | observed / unresolved review |
| VOCLE-112 | H1 | excluded | observed / unresolved review |
| VOCLE-159 | S3 | yes, after fix/assertion audit | observed / unfixed |
| VOCLE-171 | BASELINE_SEMANTICS | excluded | observed / unresolved review |
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
| VOCLE-355 | BASELINE_SEMANTICS | excluded | observed / unresolved review |
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

Machine-readable details: [SECURITY_REGRESSION_GATES.json](SECURITY_REGRESSION_GATES.json).
