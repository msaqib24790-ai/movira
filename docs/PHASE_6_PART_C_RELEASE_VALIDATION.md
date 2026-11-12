# Phase 6 Part C — Production Build & Release Validation

**Project:** MOVIRA
**Package:** com.movira.movira
**Version:** 1.0.0
**Validation date:** 12 November 2026
**Status:** VALIDATION PASSED

## 1. Release APK Integrity
- Release APK generated successfully.
- Package, version, SDK levels and application label verified.
- APK size: approximately 69.15 MB.
- SHA-256:
  `082910EF35713FDDAA962A538AB170C10D34D70C8151CFA2EDFDEE2C464AA89`

## 2. Release Signature
- APK signature verification passed.
- APK signed with the MOVIRA upload certificate.
- RSA 2048-bit signing key.
- SHA-256 certificate fingerprint:
  `45:7D:7C:B0:4C:79:02:1E:9B:E3:B9:43:B4:64:74:D9:5A:58:80:9B:ED:EE:4C:F9:46:4B:8F:04:51:04:61:64`

## 3. Clean Installation
- Existing release test installation removed.
- Release APK installed successfully on MOVIRA_Release_Test.

## 4. Cold-Start Test
- Release application launched successfully.
- Android runtime permissions granted.
- Welcome screen displayed after launch.

## 5. Core Screen Verification
User-confirmed tests passed:
- Welcome and Get Started
- Home
- Route Search
- Nearby Stops
- Schedules

## 6. Authentication Verification
User-confirmed tests passed:
- Login with existing account
- Home after login
- User Profile and profile information

## 7. Firebase Integration
User-confirmed tests passed:
- Previously saved trips loaded.
- New test trip saved.
- Saved trip persisted after leaving and reopening the application.

## 8. Maps and Location
User-confirmed tests passed:
- Map loaded.
- Current location detected.
- Nearby Stops results displayed.
- Map zoom and pan worked.

## 9. Notifications
User-confirmed tests passed:
- Notification Alerts screen loaded.
- Reminder displayed and scheduling worked.
- Scheduled local notification delivered.
- Direct Firebase Cloud Messaging test message delivered on the original Pixel 7 emulator.
- Notification sound confirmed.

## 10. Navigation Regression
User-confirmed tests passed:
- Trip Planner to Trip Summary.
- Home to Route Search, Results and Details.
- Support Center.
- About, Terms & Conditions and Privacy Policy.
- Android Back navigation.

## 11. Stability Monitoring
- Application process remained alive during the test.
- No matching fatal exception or fatal signal was found in the inspected recent log output.

## 12. Performance Snapshot
- Total PSS: 122,735 KB.
- RSS: 247,836 KB.
- Memory figures are a runtime snapshot, not a full performance benchmark.

## 13. Static Analysis
- Flutter analysis finished.
- 0 errors.
- 7 warnings.
- 133 informational findings.
- Existing findings were not changed as part of release validation.

## 14. Final APK Checksum
- Final APK checksum rechecked.
- SHA-256 matched the previously verified release APK.

## Outstanding Notes
- An Impeller rendering validation warning was observed during emulator testing.
- The warning did not coincide with an observed application crash.
- A fresh Skia launch did not reproduce the warning.
- The exact source of the Impeller warning remains unidentified.
- Firebase direct test-message delivery was verified; this does not establish that audience campaign analytics are working.
- Production deployment and Google Play Store publication have not been performed.

## Final Result
All 14 Phase 6 Part C validation checkpoints were recorded as passed.
The findings and outstanding release activities above remain documented.

This report records the validation performed; it does not claim that MOVIRA has been published to production.
