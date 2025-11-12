// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vehicle Parts App';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'PROFILE';

  @override
  String get account => 'ACCOUNT';

  @override
  String get support => 'SUPPORT';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSubtitle => 'Update your personal information';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Update your password';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get privacySecuritySubtitle => 'Manage your privacy settings';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get helpSupportSubtitle => 'Get help and contact support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'Read our privacy policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsOfServiceSubtitle => 'Read our terms of service';

  @override
  String get about => 'About';

  @override
  String get aboutSubtitle => 'App version and information';

  @override
  String get logout => 'Logout';

  @override
  String get logoutSubtitle => 'Sign out of your account';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose your preferred language';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String comingSoonMessage(String feature) {
    return '$feature will be available soon.';
  }

  @override
  String get ok => 'OK';

  @override
  String get aboutTitle => 'About M AUTO-ZONE';

  @override
  String get aboutMessage =>
      'Version 1.0.0\n\nYour trusted partner for quality auto parts.\n\n© 2025 M AUTO-ZONE. All rights reserved.';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get sinhala => 'සිංහල';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue to your account';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmailRequired => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get viewAll => 'View All';

  @override
  String get requestSparePart => 'Request Spare Part';

  @override
  String get findPartYouNeed => 'Find the part you need';

  @override
  String get myRequests => 'My Requests';

  @override
  String get viewYourRequests => 'View your requests';

  @override
  String get addRequest => 'Add Request';

  @override
  String get createNewRequest => 'Create New Request';

  @override
  String get home => 'Home';

  @override
  String get requests => 'Requests';

  @override
  String get products => 'Products';

  @override
  String get cart => 'Cart';

  @override
  String get loadingCart => 'Loading cart...';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get startShopping => 'Start Shopping';

  @override
  String get total => 'Total';

  @override
  String get checkout => 'Checkout';

  @override
  String get items => 'items';

  @override
  String get item => 'item';

  @override
  String get yourCartIsEmpty => 'Your Cart is Empty';

  @override
  String get cartEmptyMessage =>
      'Looks like you haven\'t added anything\nto your cart yet';

  @override
  String get browseRequests => 'Browse Requests';

  @override
  String get delivery => 'Delivery';

  @override
  String get free => 'Free';

  @override
  String get orderTotal => 'Order Total';

  @override
  String get proceedToBuy => 'Proceed to Buy';

  @override
  String get helpSupportTitle => 'Help & Support';

  @override
  String get welcomeToHelpCenter => 'Welcome to Help Center';

  @override
  String get findAnswersAndLearn =>
      'Find answers and learn how to use AUTO-ZONE';

  @override
  String get howToRequestSparePart => 'How to Request a Spare Part';

  @override
  String get tapAddRequest => 'Tap \"Add Request\"';

  @override
  String get tapAddRequestDesc =>
      'From the home screen, tap the \"Add Request\" button or navigate to the Requests section.';

  @override
  String get fillVehicleInformation => 'Fill Vehicle Information';

  @override
  String get fillVehicleInformationDesc =>
      'Enter your vehicle type, model, and year. Upload a photo of your vehicle if available.';

  @override
  String get addPartDetails => 'Add Part Details';

  @override
  String get addPartDetailsDesc =>
      'Specify the part name, part number (if known), and provide a detailed description.';

  @override
  String get uploadImagesVideo => 'Upload Images/Video';

  @override
  String get uploadImagesVideoDesc =>
      'Add photos of the part or vehicle area where the part is needed. You can also upload a video.';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get submitRequestDesc =>
      'Review your information and submit the request. You\'ll receive updates on your request status.';

  @override
  String get managingYourRequests => 'Managing Your Requests';

  @override
  String get viewAllRequests => 'View All Requests';

  @override
  String get viewAllRequestsDesc =>
      'Go to \"My Requests\" from the home screen to see all your submitted requests and their current status.';

  @override
  String get requestStatus => 'Request Status';

  @override
  String get requestStatusDesc =>
      'Track your requests with status indicators: Pending, In Progress, Completed, or Cancelled.';

  @override
  String get viewRequestDetails => 'View Request Details';

  @override
  String get viewRequestDetailsDesc =>
      'Tap on any request card to see full details, including vehicle information, part details, and attached media.';

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get faqProcessingTime => 'How long does it take to process a request?';

  @override
  String get faqProcessingTimeAnswer =>
      'Request processing time varies depending on part availability. Typically, you\'ll receive a response within 24-48 hours.';

  @override
  String get faqEditCancel => 'Can I edit or cancel my request?';

  @override
  String get faqEditCancelAnswer =>
      'You can view your request details, but editing and cancellation features are currently being developed.';

  @override
  String get faqWhatInformation => 'What information should I include?';

  @override
  String get faqWhatInformationAnswer =>
      'Provide as much detail as possible: vehicle make, model, year, part name/number, and clear photos or videos.';

  @override
  String get faqTrackStatus => 'How do I track my request status?';

  @override
  String get faqTrackStatusAnswer =>
      'Navigate to \"My Requests\" to see all your requests with their current status. Tap on any request for detailed information.';

  @override
  String get needMoreHelp => 'Need More Help?';

  @override
  String get stillNeedHelp => 'Still Need Help?';

  @override
  String get contactSupportTeam => 'Contact our support team for assistance';

  @override
  String get email => 'Email';

  @override
  String get call => 'Call';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get loadingRequestDetails => 'Loading request details...';

  @override
  String get error => 'Error';

  @override
  String get failedToLoadRequestDetails => 'Failed to load request details';

  @override
  String get retry => 'Retry';

  @override
  String get requestNotFound => 'Request not found';

  @override
  String get goBack => 'Go Back';

  @override
  String get partInformation => 'Part Information';

  @override
  String get partName => 'Part Name';

  @override
  String get partNumber => 'Part Number';

  @override
  String get description => 'Description';

  @override
  String get vehicleInformation => 'Vehicle Information';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get model => 'Model';

  @override
  String get year => 'Year';

  @override
  String get media => 'Media';

  @override
  String get vehicleImage => 'Vehicle Image';

  @override
  String get partImage => 'Part Image';

  @override
  String get partVideo => 'Part Video';

  @override
  String get tapToViewVideo => 'Tap to view video';

  @override
  String get suggestedProducts => 'Suggested Products';

  @override
  String get adminSuggestedProducts =>
      'Admin has suggested the following products for your request';

  @override
  String addedToCart(String productName) {
    return '$productName added to cart';
  }

  @override
  String get viewCart => 'View Cart';

  @override
  String failedToAddToCart(String error) {
    return 'Failed to add to cart: $error';
  }

  @override
  String get requestInformation => 'Request Information';

  @override
  String get requestId => 'Request ID';

  @override
  String get created => 'Created';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get noRequestsFound => 'No Requests Found';

  @override
  String get noRequestsFoundMessage =>
      'You haven\'t made any spare part requests yet.';

  @override
  String get billingAddress => 'Billing Address';

  @override
  String get fillBillingAddressFields =>
      'Please fill in all billing address fields';

  @override
  String get payment => 'Payment';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get deleteRequest => 'Delete Request';

  @override
  String get deleteRequestMessage =>
      'Are you sure you want to delete this request? This action cannot be undone.';

  @override
  String get deletingRequest => 'Deleting request...';

  @override
  String get delete => 'Delete';

  @override
  String get requestDeletedSuccessfully => 'Request deleted successfully';

  @override
  String get failedToDeleteRequest => 'Failed to delete request';

  @override
  String get needHelp => 'Need Help?';

  @override
  String get needHelpDescription =>
      'Learn how to request spare parts and manage your requests';

  @override
  String get totalRequests => 'Total Requests';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get streetAddress => 'Street Address';

  @override
  String get houseNumberStreetName => 'House number, street name';

  @override
  String get city => 'City';

  @override
  String get stateProvinceOptional => 'State/Province (Optional)';

  @override
  String get country => 'Country';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get pleaseEnterValidPhoneNumber => 'Please enter a valid phone number';

  @override
  String get requestSparePartTitle => 'Request Spare Part';

  @override
  String get fillInDetailsBelow => 'Fill in the details below';

  @override
  String stepXOfY(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get tellUsAboutYourVehicle => 'Tell us about your vehicle';

  @override
  String get vehicleTypeLabel => 'Vehicle Type';

  @override
  String get pleaseSelectVehicleType => 'Please select a vehicle type';

  @override
  String get vehicleModelLabel => 'Vehicle Model';

  @override
  String get vehicleModelHint => 'e.g., Toyota Camry';

  @override
  String get pleaseEnterVehicleModel => 'Please enter vehicle model';

  @override
  String get vehicleYearLabel => 'Vehicle Year';

  @override
  String get vehicleYearHint => 'e.g., 2020';

  @override
  String get pleaseEnterVehicleYear => 'Please enter vehicle year';

  @override
  String get pleaseEnterValidVehicleYear => 'Please enter a valid vehicle year';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get pleaseSelectCountry => 'Please select a country';

  @override
  String get provinceStateLabel => 'Province/State';

  @override
  String get provinceStateHint => 'e.g., California, Ontario, London';

  @override
  String get pleaseEnterProvinceState => 'Please enter province/state';

  @override
  String get vehicleImageOptional => 'Vehicle Image (Optional)';

  @override
  String get tapToAddVehicleImage => 'Tap to add vehicle image';

  @override
  String get sparePartDetails => 'Spare Part Details';

  @override
  String get describePartYouNeed => 'Describe the part you need';

  @override
  String get partNameLabel => 'Part Name';

  @override
  String get partNameHint => 'e.g., Brake Pad, Engine Oil Filter';

  @override
  String get pleaseEnterPartName => 'Please enter part name';

  @override
  String get partNumberLabel => 'Part Number';

  @override
  String get partNumberHint => 'e.g., BP-001 (Optional)';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Detailed description of the part you need';

  @override
  String get pleaseEnterDescription => 'Please enter description';

  @override
  String get partImageOptional => 'Part Image (Optional)';

  @override
  String get tapToAddPartImage => 'Tap to add part image';

  @override
  String get partVideoOptional => 'Part Video (Optional)';

  @override
  String get videoSelected => 'Video selected';

  @override
  String get remove => 'Remove';

  @override
  String get tapToAddPartVideo => 'Tap to add part video';

  @override
  String get next => 'Next';

  @override
  String get cancelRequest => 'Cancel Request';

  @override
  String get cancelRequestMessage =>
      'Are you sure you want to cancel? All entered data will be lost.';

  @override
  String get keepEditing => 'Keep Editing';

  @override
  String get requestSubmitted => 'Request Submitted!';

  @override
  String get requestSubmittedMessage =>
      'Your spare part request has been submitted successfully. You will receive quotes from suppliers soon.';

  @override
  String get submitAnother => 'Submit Another';

  @override
  String get viewRequests => 'View Requests';

  @override
  String get submittingRequest => 'Submitting your request...';

  @override
  String get uploadingVideoFile =>
      'Uploading video file... This may take a few minutes';

  @override
  String get pleaseWait => 'Please wait, this may take a moment';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String errorPickingImage(String error) {
    return 'Error picking image: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'Error picking video: $error';
  }

  @override
  String get currentPassword => 'Current Password';

  @override
  String get enterCurrentPassword => 'Enter your current password';

  @override
  String get currentPasswordRequired => 'Current password is required';

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter your new password';

  @override
  String get newPasswordRequired => 'New password is required';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get confirmNewPasswordHint => 'Confirm your new password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordMustBeAtLeast8Characters =>
      'Password must be at least 8 characters';

  @override
  String get passwordMustBeAtLeast8CharactersLong =>
      'Your password must be at least 8 characters long.';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get failedToChangePassword => 'Failed to change password';

  @override
  String get enterFirstName => 'Enter your first name';

  @override
  String get firstNameRequired => 'First name is required';

  @override
  String get firstNameMustBeAtLeast2Characters =>
      'First name must be at least 2 characters';

  @override
  String get enterLastName => 'Enter your last name';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get lastNameMustBeAtLeast2Characters =>
      'Last name must be at least 2 characters';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get postalCodeRequired => 'Postal code is required';

  @override
  String get continueButton => 'Continue';

  @override
  String get billingInformation => 'Billing Information';

  @override
  String get enterBillingDetails => 'Enter your billing details';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get addressInformation => 'Address Information';

  @override
  String errorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get myCart => 'My Cart';

  @override
  String get eligibleForFreeDelivery => 'Eligible for free delivery';

  @override
  String get inStock => 'In Stock';

  @override
  String get quantity => 'Qty';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get proceedToPayment => 'Proceed to Payment';

  @override
  String get pay => 'Pay';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get emailLabel => 'Email';

  @override
  String get billingAddressRequired => 'Billing address is required';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String paymentProcessedSuccessfully(String paymentId) {
    return 'Your payment has been processed successfully.\n\nPayment ID: $paymentId\n\nYour order will be processed shortly.';
  }

  @override
  String get viewOrders => 'View Orders';

  @override
  String get paymentFailed => 'Payment Failed';

  @override
  String paymentCouldNotBeProcessed(String error) {
    return 'Payment could not be processed.\n\nError: $error\n\nPlease try again.';
  }

  @override
  String get paymentCancelled => 'Payment was cancelled';
}
