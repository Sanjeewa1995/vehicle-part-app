# PayHere Payment Integration

This feature integrates PayHere payment gateway (v3.2.0) for processing payments in the Vehicle Parts App, following the official PayHere Flutter SDK documentation.

## Setup Instructions

### 1. Get PayHere Credentials

1. Sign up for a PayHere merchant account at [https://www.payhere.lk](https://www.payhere.lk)
2. Log in to your PayHere Merchant Account
3. Go to **Settings** > **Domains & Credentials**
4. Click on **Add Domain/App**
5. Select **App** and enter your Flutter app's package name: `com.vehiclepart.vehicle_part_app`
6. Note the generated **Merchant ID** and **Merchant Secret** (hash value) for your app
7. Click **Request to Approve** (approval may take up to one business day for live accounts)

### 2. Configure Credentials

Update the credentials in `lib/features/payment/data/repositories/payhere_service.dart`:

```dart
static const String merchantId = 'YOUR_MERCHANT_ID';
static const String merchantSecret = 'YOUR_MERCHANT_SECRET';
static const String notifyUrl = 'https://yourdomain.com/notify';
static const bool sandbox = true; // Set to false for production
```

### 3. Android Configuration ✅ (Already Configured)

The following Android prerequisites have been set up:

- ✅ **Maven Repository**: Added PayHere Maven repository to `android/build.gradle.kts`
- ✅ **AndroidManifest**: Added tools namespace and `tools:replace="android:label"` attribute
- ✅ **ProGuard Rules**: Added ProGuard rules in `android/app/proguard-rules.pro`

### 4. iOS Configuration

Run the following command in your iOS project:

```bash
cd ios
pod install
```

Note: If you encounter encoding errors, Flutter will handle pod installation automatically during build.

### 5. Testing

- Use `sandbox: true` for testing with PayHere's test environment
- Use test card numbers provided by PayHere for testing
- Set `sandbox: false` when ready for production

## Usage

The "Pay from PayHere" button is available on the payment page. When clicked, it:

1. Creates a payment request with order details
2. Opens the PayHere payment interface
3. Handles success, error, and cancellation callbacks
4. Navigates to orders page on successful payment

## TODO

- [ ] Replace placeholder user data with actual user profile data
- [ ] Integrate with cart to get actual order total
- [ ] Add order ID generation from backend
- [ ] Implement payment notification webhook handler
- [ ] Add payment history tracking

## Payment Request Model

The `PaymentRequest` model supports all PayHere payment types:

### One-time Payment
Standard payment charged once.

### Recurring Payment
Subscription payment charged at fixed intervals:
- `recurrence`: Payment frequency (e.g., "1 Month")
- `duration`: Payment duration (e.g., "1 Year")
- `startupFee`: Extra amount for first payment

### Preapproval (Tokenization)
Tokenize customer card for later use with PayHere Charging API:
- Set `preapprove: true`

### Hold-on-Card
Authorize charges on customer's card for later capture:
- Set `authorize: true`

### Item-wise Details
Optionally include detailed item breakdown:
```dart
paymentItems: [
  PaymentItem(
    itemNumber: '001',
    itemName: 'Brake Pads',
    amount: 25.00,
    quantity: 2,
  ),
  PaymentItem(
    itemNumber: '002',
    itemName: 'Oil Filter',
    amount: 20.00,
    quantity: 1,
  ),
]
```

### Model Fields
- Order ID, Items description, Amount
- Currency (default: LKR)
- Customer details (name, email, phone, address)
- Delivery address (optional)
- Custom fields (custom1, custom2)

## Callbacks

- **onSuccess**: Called when payment is successful, receives payment ID
- **onError**: Called when payment fails, receives error message
- **onDismissed**: Called when user cancels the payment

