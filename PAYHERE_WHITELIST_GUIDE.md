# PayHere "Unauthorized Domain" Error - Fix Guide

## Error Message
"Server Response Error: Unauthorized domain"

## What This Means
Your app's package name is not whitelisted in your PayHere merchant account.

## Your App Package Names
- **Android**: `com.vehiclepart.vehicle_part_app`
- **iOS**: `com.vehiclepart.vehiclePartApp` (check in Xcode)

## Solution: Whitelist Your App in PayHere

### Step 1: Login to PayHere Merchant Account
1. Go to [https://www.payhere.lk](https://www.payhere.lk)
2. Login to your merchant account

### Step 2: Navigate to Settings
1. Click on **Settings** in the dashboard
2. Select **Domains & Credentials**

### Step 3: Add Your App
1. Click the **"Add Domain/App"** button
2. In the first dropdown, select **"App"** (not "Domain")
3. Enter your app package name:
   - For Android: `com.vehiclepart.vehicle_part_app`
   - For iOS: `com.vehiclepart.vehiclePartApp` (if different)
4. **Important**: Copy the **Merchant Secret** (hash value) shown in the last field
5. Click **"Request to Approve"**

### Step 4: Wait for Approval
- **Sandbox accounts**: Usually approved immediately
- **Live accounts**: May take up to 1 business day for manual review

### Step 5: Update Your Code (if needed)
If you got a new Merchant Secret, update it in:
```
lib/features/payment/data/repositories/payhere_service.dart
```

### Step 6: Verify Settings
Make sure in `payhere_service.dart`:
- `merchantId`: Matches your PayHere merchant ID
- `merchantSecret`: Matches the hash value from Step 3
- `sandbox`: Set to `true` for testing, `false` for production

## Important Notes

1. **Package Name Must Match Exactly**
   - The package name in your app must match exactly what you enter in PayHere
   - No spaces, case-sensitive for iOS

2. **Separate Entries for Android & iOS**
   - If Android and iOS have different package names, you need to add both
   - Each will have its own Merchant Secret

3. **Sandbox vs Live**
   - Sandbox credentials work only with `sandbox: true`
   - Live credentials work only with `sandbox: false`
   - Make sure you're using the correct credentials for your environment

4. **Testing**
   - After whitelisting, wait a few minutes for changes to propagate
   - Try the payment again

## Current Configuration
- Merchant ID: `1232702`
- Sandbox Mode: `true`
- Package Name (Android): `com.vehiclepart.vehicle_part_app`

## Still Having Issues?

1. **Double-check package name**: Verify in `android/app/build.gradle.kts` (line 24)
2. **Check iOS bundle ID**: Open `ios/Runner.xcworkspace` in Xcode and check Bundle Identifier
3. **Verify credentials**: Make sure Merchant ID and Secret are correct
4. **Check approval status**: In PayHere dashboard, verify the app shows as "Approved"

