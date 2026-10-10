# Final Android run: application failures and execution limits

Source `7d41211`, harness base plus recorded content hashes corresponding to
committed `7bf0888`. Eight IDs attempted: PASS 1, FAIL 7, ERROR 0; provenance and
automatic cleanup PASS. This is Android 36.1 with Flutter 3.29.3, synthetic local
Express/Mongo and injected provider inputs. No iOS or provider delivery claim.

| ID | Result | Evidence and primary failure |
| --- | --- | --- |
| FR-MED-08 | FAIL | Cancel made zero upload/message requests; PDF bytes and native external activity, PNG and video previews, unsupported-file error/non-persistence were reached. Camera denial escaped through `MediaPickerService.captureFromCamera` / chat `_sendAttachment` as unhandled `PlatformException(camera_access_denied)`. The JSON record's later `inTest` assertion is secondary; consult `native-logs/FR-MED-08-media.log` for the original exception. Permission recovery assertions after that failure were not credited. Q5 delivery policy remains unresolved. |
| FR-PUSH-05 | PASS | Exact native shade grouping and stored lines, injected tap route and exactly one backend-persisted/independently retrieved reply. `native-logs/FR-PUSH-05-notification-grouping.log`. This verifies injected local contracts, not FCM/APNs delivery. |
| FR-PUSH-06 | FAIL | Native permission states and token registration/refresh, logout removal and relogin subassertions completed. A subsequent AuthBloc `emit was called after an event handler completed normally` makes the entire case FAIL. `native-logs/FR-PUSH-06-notification-token.log`. |
| FR-NAV-04 | FAIL | Native stop/pause/resume, real reconnect, independently persisted/displayed peer message and retained draft verified. After disposal, `ChannelChatCubit.loadMessages` line 106 emitted after close. `native-logs/FR-NAV-04-resume.log`. Body completion does not excuse that application exception. |
| FR-NAV-05 | FAIL | Native encrypted session round trip/seed passed in the first process. The restored authenticated Home raised `Vertical viewport was given unbounded height`. Final API-failure logout/relaunch phases were not completed. `native-logs/FR-NAV-05-session-{seed,restore}.log`. |
| FR-LINK-04 | FAIL | Synthetic camera/picker/QR inputs exercised the actual decoder and preview; a real backend join persisted membership. The expected destination space route was not reached. `native-logs/FR-LINK-04-invites.log`. Later pending-approval presentation remains Q14 and is not credited as passed. |
| FR-JRN-05 | FAIL | Real chat journey encountered `ChannelChatCubit.loadMessages` emitting after close. A complete logout/relogin/refetch journey is not claimed. `native-logs/FR-JRN-05-chat-journey.log`. |
| FR-JRN-06 | FAIL | Logged-out cold preparation completed in one native process. Cold login raised AuthBloc's emit-after-handler-completion assertion. Handoff acknowledgement and sender update were not reached. `native-logs/FR-JRN-06-handoff-{seed,cold}.log`. |

The JSON, JUnit and logs are original evidence, with credential/token/VM-service
text redacted in the committed log copies. No testcase verdict is changed in
this triage. Prior development reports remain red with their original ERRORs;
separate remediation records and the progress document explain corrected
harness classification and directory-handle cleanup. Failed IDs can share a
single application defect. Testcase execution means assertions were attempted,
not that every later assertion was reached.
