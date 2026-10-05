## VOCLE-752: Positive test-cloud binding and signed synthetic smoke

PASS

Expected: Exact positive allowlist match and signed PNG accepted only within this run

Actual: `{"allowlistMatched":true,"signedUploadAccepted":true,"identity":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/op-001/file_sdubjg","resourceType":"image","deliveryType":"upload","format":"png","bytes":70,"width":1,"height":1,"secureURLApproved":true}}`

Related cases: none

## VOCLE-753: Application PNG upload resource identity

PASS

Expected: Real controller PNG stored as image/upload under broker run namespace

Actual: `{"status":200,"identity":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-2/medcollab/messages/7ec000000000000000000001/synthetic_r9qyie","resourceType":"image","deliveryType":"upload","format":"png","bytes":70,"width":1,"height":1,"secureURLApproved":true},"brokerFolderAdaptation":true}`

Related cases: none

## VOCLE-754: Image exact authenticated resource read

PASS

Expected: Exact provider metadata matches recorded public ID, asset ID and resource type

Actual: `{"exists":true,"identityMatched":true,"bytes":70,"format":"png"}`

Related cases: none

## VOCLE-755: Image HTTPS original retrieval

PASS

Expected: Approved-cloud HTTPS original returns image bytes

Actual: `{"status":200,"contentType":"image/png","bytes":70,"sha256":"abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f","redirected":false}`

Related cases: none

## VOCLE-756: Application safe image thumbnail transformation

PASS

Expected: Controller 400x400 limit WebP thumbnail retrieves successfully

Actual: `{"status":200,"contentType":"image/webp","bytes":44,"sha256":"83e0c98111545b7c1ab12c028c63b12f2785c917c75e10bf75077e329633cd43","redirected":false}`

Related cases: none

## VOCLE-757: Image anonymous delivery characterization

PASS

Expected: Measure unsigned synthetic delivery; public access does not establish clinical policy

Actual: `{"status":200,"contentType":"image/png","bytes":70,"sha256":"abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f","redirected":false,"unsignedDelivery":true,"anonymouslyRetrievable":true,"policyApproval":false}`

Related cases: none

## VOCLE-758: Application MP4 upload resource identity

PASS

Expected: Real controller synthetic MP4 stored as video/upload

Actual: `{"status":200,"identity":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-3/medcollab/messages/7ec000000000000000000001/synthetic_gd7z3f","resourceType":"video","deliveryType":"upload","format":"mp4","bytes":1509,"width":16,"height":16,"secureURLApproved":true}}`

Related cases: none

## VOCLE-759: Video exact authenticated resource read

PASS

Expected: Exact video metadata exists and matches this run

Actual: `{"exists":true,"identityMatched":true,"bytes":1509,"format":"mp4"}`

Related cases: none

## VOCLE-760: Video HTTPS original retrieval

PASS

Expected: Synthetic video delivery returns video bytes

Actual: `{"status":200,"contentType":"video/mp4","bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7","redirected":false}`

Related cases: none

## VOCLE-761: Application video JPG thumbnail transformation

PASS

Expected: Controller video frame transformation retrieves image bytes

Actual: `{"status":200,"contentType":"image/jpeg","bytes":158,"sha256":"63927fcaf17b5ebee9ae1991c0fdeaf8d69bec0440a4456ff7cd010e47361f9f","redirected":false}`

Related cases: none

## VOCLE-762: Application owner video deletion limitation

OBSERVATION

Expected: Owner deletion should remove video; preserve existing VOCLE-736 finding if retained

Actual: `{"status":404,"videoRetained":true,"dispatch":["image","raw"]}`

Related cases: VOCLE-736

## VOCLE-763: Independent explicit video deletion

PASS

Expected: Correct video resource type destroy returns ok

Actual: `{"result":"ok"}`

Related cases: none

## VOCLE-764: Video origin disappearance

PASS

Expected: Exact authenticated video lookup returns 404 after deletion

Actual: `{"exists":false}`

Related cases: none

## VOCLE-765: Video post-delete delivery behavior

OBSERVATION

Expected: Fresh original delivery should stop; report CDN persistence separately from origin absence

Actual: `{"status":200,"contentType":"video/mp4","bytes":1509,"sha256":"d52c25883ebab2b9d7a9f416f4a7e7d118ff429eb68e85bbf295f34d99c70ae7","redirected":false,"appInvalidateOmitted":true,"independentTestDeletionInvalidate":false}`

Related cases: none

## VOCLE-766: Repeated video deletion semantics

PASS

Expected: Repeated exact video destroy returns not found

Actual: `{"result":"not found"}`

Related cases: none

## VOCLE-767: Application PDF raw upload resource identity

PASS

Expected: Real controller synthetic PDF stored as raw/upload

Actual: `{"status":200,"identity":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-4/medcollab/messages/7ec000000000000000000001/synthetic_qf9iew","resourceType":"raw","deliveryType":"upload","format":null,"bytes":344,"width":null,"height":null,"secureURLApproved":true}}`

Related cases: none

## VOCLE-768: Raw PDF exact authenticated resource read

PASS

Expected: Exact raw PDF metadata exists and matches this run

Actual: `{"exists":true,"identityMatched":true,"bytes":344,"format":null}`

Related cases: none

## VOCLE-769: Raw PDF HTTPS original delivery

PASS

Expected: Original synthetic PDF delivery returns exact fixture bytes

Actual: `{"status":200,"contentType":"application/octet-stream","bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78","redirected":false}`

Related cases: none

## VOCLE-770: Application raw PDF attachment delivery

OBSERVATION

Expected: Controller attachment URL returns exact PDF bytes where account allows delivery

Actual: `{"status":400,"contentType":"application/json","bytes":402,"sha256":"a43a8f06b89c0ba9a39b4779a1219c1f5459c7bd671742fc9fb8cf4edc7d2496","redirected":false,"plainAttachmentControl":{"status":200,"contentType":"application/octet-stream","bytes":344,"sha256":"b58465abb13d34419dd15dc13a9cbcae5f8bca34057416111b66ccd2a5755a78","redirected":false},"plainAttachmentSupported":true}`

Related cases: none

## VOCLE-771: Application raw PDF image preview compatibility

OBSERVATION

Expected: Measure actual image preview; URL construction alone cannot establish support

Actual: `{"status":404,"contentType":"application/json","bytes":460,"sha256":"498350fff1a54241b5f4300964bebc9da7402a904bbcdcaff6a479f23d53e47e","redirected":false,"uploadedResourceType":"raw","previewResourceType":"image","previewSupported":false,"imagePDFControl":{"identity":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/op-005/file_bvbgto","resourceType":"image","deliveryType":"upload","format":"pdf","bytes":344,"width":10,"height":10,"secureURLApproved":true},"metadata":{"exists":true,"identityMatched":true,"bytes":344,"format":"pdf"},"preview":{"status":200,"contentType":"image/webp","bytes":38,"sha256":"a1e2f6dbda847380d13af6bd388778fe2d5c2a3b127c38a3924cbe31e1dd8de2","redirected":false},"previewSupported":true}}`

Related cases: none

## VOCLE-772: Application owner raw deletion

PASS

Expected: Unchanged controller image-then-raw deletion removes owned PDF

Actual: `{"status":200,"exists":false}`

Related cases: none

## VOCLE-773: Raw origin disappearance and post-delete retrieval

PASS

Expected: Exact authenticated raw lookup returns 404; measure original delivery separately for cache persistence

Actual: `{"exists":false,"delivery":{"status":404,"contentType":"application/json","bytes":429,"sha256":"e567e0d36af98609750860608fd47ee9109815b641bc53c58e95783488ce318c","redirected":false},"originAbsenceIndependentOfCDN":true}`

Related cases: none

## VOCLE-774: Repeated raw deletion semantics

PASS

Expected: Repeated exact raw destroy returns not found

Actual: `{"result":"not found"}`

Related cases: none

## VOCLE-775: Application owner image deletion

PASS

Expected: Unchanged controller removes owned image

Actual: `{"status":200,"exists":false}`

Related cases: none

## VOCLE-776: Image origin disappearance, retrieval and repeated deletion

PASS

Expected: Image exact lookup absent, repeated destroy not found; measure original delivery separately

Actual: `{"exists":false,"result":"not found","delivery":{"status":404,"contentType":"application/json","bytes":444,"sha256":"a0008f97dba8f9d4bf9bd643efbc8780510593ea4a901b944be5f8229a5d25da","redirected":false},"originAbsenceIndependentOfCDN":true}`

Related cases: none

## VOCLE-777: Same-folder duplicate filenames and generated IDs

PASS

Expected: Provider generates distinct IDs for duplicate synthetic filenames without overwriting

Actual: `{"distinctIds":true,"first":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/duplicate-names/synthetic-duplicate_b6fud7","resourceType":"image","deliveryType":"upload","format":"png","bytes":70,"width":1,"height":1,"secureURLApproved":true},"second":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/duplicate-names/synthetic-duplicate_rqjqw9","resourceType":"image","deliveryType":"upload","format":"png","bytes":70,"width":1,"height":1,"secureURLApproved":true},"filenameOverrideControlsID":true}`

Related cases: none

## VOCLE-778: Explicit overwrite false preserves original

PASS

Expected: Second same-ID upload with overwrite false preserves original exact resource

Actual: `{"secondRejected":false,"existingReturned":true,"identityPreserved":true,"versionPreserved":true,"differentSyntheticBytesAttempted":true,"originalBytesPreserved":true,"delivery":{"status":200,"contentType":"image/png","bytes":70,"sha256":"abc58d5127d7cdf313beb9ec8ee839860a9c6bfbc48c8b8eb6a3f7d8bb63de6f","redirected":false}}`

Related cases: none

## VOCLE-779: Explicit overwrite true characterization

PASS

Expected: Bounded owned same-ID overwrite is accepted; record actual version and bytes

Actual: `{"accepted":true,"previousVersion":1791227663,"returnedVersion":1791227664,"differentSyntheticBytesOnly":true,"replacementBytesVerified":true,"delivery":{"status":200,"contentType":"image/png","bytes":70,"sha256":"d5a51b6aed15684ec8c123e30fe5703155359d6543b6d7b47cb5766ef44939de","redirected":false},"productionOverwritePolicyVerified":false}`

Related cases: none

## VOCLE-780: Same public ID resource-type separation

PASS

Expected: Image/raw same public ID remain independently typed resources

Actual: `{"samePublicId":true,"independentResourceTypes":["image","raw"]}`

Related cases: none

## VOCLE-781: Namespace and forged filename isolation

PASS

Expected: Controller unsafe original filename cannot escape the broker run namespace

Actual: `{"identity":{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-13/medcollab/messages/7ec000000000000000000001/.._._zfspqx","resourceType":"image","deliveryType":"upload","format":"png","bytes":70,"width":1,"height":1,"secureURLApproved":true},"originalFilenameSanitized":".._.._synthetic-(canary)","normalAppFolderPreservedUnderRunRoot":true,"expectedFolderMatched":true,"canonicalSegmentsSafe":true}`

Related cases: none

## VOCLE-782: Application octet-PDF provider dispatch

OBSERVATION

Expected: Octet-PDF should select raw; actual image intent remains VOCLE-724 observation

Actual: `{"requestedType":"image","expectedType":"raw","appStatus":200,"providerAccepted":true,"storedType":"image","providerRejectionStatus":null}`

Related cases: VOCLE-724

## VOCLE-783: Application octet-MP4 provider dispatch

OBSERVATION

Expected: Octet-MP4 should select video; actual image intent remains VOCLE-725 observation

Actual: `{"requestedType":"image","expectedType":"video","appStatus":500,"providerAccepted":false,"storedType":null,"providerRejectionStatus":400}`

Related cases: VOCLE-725

## VOCLE-784: Application shared handoff deletion limitation

OBSERVATION

Expected: Uploader should remove handoff asset; existing VOCLE-740 observation if forbidden

Actual: `{"status":403,"retained":true,"originalFolder":"medcollab/handoffs"}`

Related cases: VOCLE-740

## VOCLE-785: Independent manifest cleanup and exact absence verification

PASS

Expected: All recorded image/video/raw resources removed; no unresolved upload intents

Actual: `{"attempted":true,"resources":[{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/op-001/file_sdubjg","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-2/medcollab/messages/7ec000000000000000000001/synthetic_r9qyie","resourceType":"image","destroyResult":"not found","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-3/medcollab/messages/7ec000000000000000000001/synthetic_gd7z3f","resourceType":"video","destroyResult":"not found","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-4/medcollab/messages/7ec000000000000000000001/synthetic_qf9iew","resourceType":"raw","destroyResult":"not found","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/op-005/file_bvbgto","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/duplicate-names/synthetic-duplicate_b6fud7","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/duplicate-names/synthetic-duplicate_rqjqw9","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/overwrite/synthetic","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/type-separation/synthetic","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/type-separation/synthetic","resourceType":"raw","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-13/medcollab/messages/7ec000000000000000000001/.._._zfspqx","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-14/medcollab/messages/7ec000000000000000000001/synthetic_jq1njj","resourceType":"image","destroyResult":"ok","originAbsent":true},{"publicId":"medcollab/security-test/37361873736-1-5ed8f7a2-5f9b-457e-b356-33c00655c089/app-16/medcollab/handoffs/synthetic_ju66hi","resourceType":"image","destroyResult":"ok","originAbsent":true}],"pendingUnresolved":0,"proven":true,"broadDeletionUsed":false}`

Related cases: none
