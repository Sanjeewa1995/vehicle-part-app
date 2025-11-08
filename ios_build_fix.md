# iOS Build Fix Guide

## Issue
iOS build failing with "Command PrecompileModule failed with a nonzero exit code"

## Solutions

### 1. Clean Build (Recommended)
```bash
cd /Users/malakasanjeewa/vehicle-part-app
flutter clean
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
cd ios
pod deintegrate
pod install
cd ..
flutter pub get
flutter run
```

### 2. If Disk Space Issues Persist
```bash
# Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# Clean Flutter build cache
flutter clean
rm -rf build/
```

### 3. Update iOS Deployment Target
The Podfile is set to iOS 13.0, which matches PayHere SDK requirements.

### 4. If PayHere SDK Issues
If the build still fails, try temporarily removing PayHere to test:
1. Comment out PayHere imports in payment_page.dart
2. Build and test
3. If successful, the issue is PayHere-specific

### 5. Xcode Build
Try building directly from Xcode:
```bash
open ios/Runner.xcworkspace
```
Then build from Xcode (Cmd+B) to see detailed error messages.

## Notes
- PayHere SDK v3.2.0 requires iOS 13.0+
- Ensure you have enough disk space (at least 5GB free)
- Xcode 16.4 is installed and should be compatible

