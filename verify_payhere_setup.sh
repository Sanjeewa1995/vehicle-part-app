#!/bin/bash

echo "=========================================="
echo "PayHere Configuration Verification"
echo "=========================================="
echo ""

echo "1. Checking Android Package Name..."
APP_ID=$(grep -E "applicationId\s*=" android/app/build.gradle.kts | sed 's/.*applicationId.*"\(.*\)".*/\1/')
echo "   Package Name: $APP_ID"
echo "   Expected: com.vehiclepart.vehicle_part_app"
if [ "$APP_ID" == "com.vehiclepart.vehicle_part_app" ]; then
    echo "   ✅ Package name matches!"
else
    echo "   ❌ Package name mismatch!"
fi
echo ""

echo "2. Checking AndroidManifest.xml..."
MANIFEST_PKG=$(grep -E "package=" android/app/src/main/AndroidManifest.xml | sed 's/.*package="\(.*\)".*/\1/')
echo "   Package: $MANIFEST_PKG"
if [ "$MANIFEST_PKG" == "com.vehiclepart.vehicle_part_app" ]; then
    echo "   ✅ Manifest package matches!"
else
    echo "   ❌ Manifest package mismatch!"
fi
echo ""

echo "3. Checking PayHere Service Configuration..."
MERCHANT_ID=$(grep -E "merchantId\s*=" lib/features/payment/data/repositories/payhere_service.dart | sed "s/.*merchantId.*'\(.*\)'.*/\1/")
MERCHANT_SECRET=$(grep -E "merchantSecret\s*=" lib/features/payment/data/repositories/payhere_service.dart | sed "s/.*merchantSecret.*'\(.*\)'.*/\1/")
SANDBOX=$(grep -E "sandbox\s*=" lib/features/payment/data/repositories/payhere_service.dart | sed "s/.*sandbox\s*=\s*\(.*\);.*/\1/")

echo "   Merchant ID: $MERCHANT_ID"
echo "   Expected: 1232702"
if [ "$MERCHANT_ID" == "1232702" ]; then
    echo "   ✅ Merchant ID matches!"
else
    echo "   ❌ Merchant ID mismatch!"
fi
echo ""

echo "   Merchant Secret: ${MERCHANT_SECRET:0:20}... (first 20 chars)"
echo "   Expected starts with: MzQ2ODc3MTQ1OTIyNTY4"
if [[ "$MERCHANT_SECRET" == MzQ2ODc3MTQ1OTIyNTY4* ]]; then
    echo "   ✅ Merchant Secret starts correctly!"
else
    echo "   ❌ Merchant Secret mismatch!"
fi
echo ""

echo "   Sandbox Mode: $SANDBOX"
echo "   Expected: true"
if [ "$SANDBOX" == "true" ]; then
    echo "   ✅ Sandbox mode is enabled!"
else
    echo "   ⚠️  Sandbox mode is disabled (production mode)"
fi
echo ""

echo "=========================================="
echo "Next Steps:"
echo "=========================================="
echo "1. Verify in PayHere Dashboard:"
echo "   - Go to Settings → Domains & Credentials"
echo "   - Find: com.vehiclepart.vehicle_part_app"
echo "   - Status should be: Active"
echo "   - Merchant Secret should match: $MERCHANT_SECRET"
echo ""
echo "2. If status is 'Pending', wait 5-10 minutes"
echo ""
echo "3. Rebuild app: flutter clean && flutter pub get && flutter run"
echo ""

