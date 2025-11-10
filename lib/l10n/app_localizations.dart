import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Vehicle Parts App'**
  String get appTitle;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile section header
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profile;

  /// Account section header
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// Support section header
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get support;

  /// Edit profile menu item
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Edit profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get editProfileSubtitle;

  /// Change password menu item
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Change password subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get changePasswordSubtitle;

  /// Privacy and security menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// Privacy and security subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your privacy settings'**
  String get privacySecuritySubtitle;

  /// Help and support menu item
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Help and support subtitle
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get helpSupportSubtitle;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy'**
  String get privacyPolicySubtitle;

  /// Terms of service menu item
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Terms of service subtitle
  ///
  /// In en, this message translates to:
  /// **'Read our terms of service'**
  String get termsOfServiceSubtitle;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About subtitle
  ///
  /// In en, this message translates to:
  /// **'App version and information'**
  String get aboutSubtitle;

  /// Logout menu item
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get logoutSubtitle;

  /// Language menu item
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageSubtitle;

  /// Coming soon dialog title
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Coming soon dialog message
  ///
  /// In en, this message translates to:
  /// **'{feature} will be available soon.'**
  String comingSoonMessage(String feature);

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// About dialog title
  ///
  /// In en, this message translates to:
  /// **'About M AUTO-ZONE'**
  String get aboutTitle;

  /// About dialog message
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0\n\nYour trusted partner for quality auto parts.\n\n© 2025 M AUTO-ZONE. All rights reserved.'**
  String get aboutMessage;

  /// Logout dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Sinhala language name
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get sinhala;

  /// Tamil language name
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get tamil;

  /// Login page welcome text
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your account'**
  String get signInToContinue;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmailRequired;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// View all button
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Request spare part action
  ///
  /// In en, this message translates to:
  /// **'Request Spare Part'**
  String get requestSparePart;

  /// Request spare part subtitle
  ///
  /// In en, this message translates to:
  /// **'Find the part you need'**
  String get findPartYouNeed;

  /// My requests action
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// My requests subtitle
  ///
  /// In en, this message translates to:
  /// **'View your requests'**
  String get viewYourRequests;

  /// Add request action
  ///
  /// In en, this message translates to:
  /// **'Add Request'**
  String get addRequest;

  /// Create new request button
  ///
  /// In en, this message translates to:
  /// **'Create New Request'**
  String get createNewRequest;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Requests navigation label
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// Products navigation label
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// Cart navigation label
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Cart loading message
  ///
  /// In en, this message translates to:
  /// **'Loading cart...'**
  String get loadingCart;

  /// Empty cart message
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// Start shopping button
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Checkout button
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Items label
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// Single item label
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// Empty cart title
  ///
  /// In en, this message translates to:
  /// **'Your Cart is Empty'**
  String get yourCartIsEmpty;

  /// Empty cart message
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added anything\nto your cart yet'**
  String get cartEmptyMessage;

  /// Browse requests button
  ///
  /// In en, this message translates to:
  /// **'Browse Requests'**
  String get browseRequests;

  /// Delivery label
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// Free delivery text
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// Order total label
  ///
  /// In en, this message translates to:
  /// **'Order Total'**
  String get orderTotal;

  /// Proceed to buy button
  ///
  /// In en, this message translates to:
  /// **'Proceed to Buy'**
  String get proceedToBuy;

  /// Help page title
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// Help center welcome
  ///
  /// In en, this message translates to:
  /// **'Welcome to Help Center'**
  String get welcomeToHelpCenter;

  /// Help center subtitle
  ///
  /// In en, this message translates to:
  /// **'Find answers and learn how to use AUTO-ZONE'**
  String get findAnswersAndLearn;

  /// How to request section title
  ///
  /// In en, this message translates to:
  /// **'How to Request a Spare Part'**
  String get howToRequestSparePart;

  /// Step 1 title
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Request\"'**
  String get tapAddRequest;

  /// Step 1 description
  ///
  /// In en, this message translates to:
  /// **'From the home screen, tap the \"Add Request\" button or navigate to the Requests section.'**
  String get tapAddRequestDesc;

  /// Step 2 title
  ///
  /// In en, this message translates to:
  /// **'Fill Vehicle Information'**
  String get fillVehicleInformation;

  /// Step 2 description
  ///
  /// In en, this message translates to:
  /// **'Enter your vehicle type, model, and year. Upload a photo of your vehicle if available.'**
  String get fillVehicleInformationDesc;

  /// Step 3 title
  ///
  /// In en, this message translates to:
  /// **'Add Part Details'**
  String get addPartDetails;

  /// Step 3 description
  ///
  /// In en, this message translates to:
  /// **'Specify the part name, part number (if known), and provide a detailed description.'**
  String get addPartDetailsDesc;

  /// Step 4 title
  ///
  /// In en, this message translates to:
  /// **'Upload Images/Video'**
  String get uploadImagesVideo;

  /// Step 4 description
  ///
  /// In en, this message translates to:
  /// **'Add photos of the part or vehicle area where the part is needed. You can also upload a video.'**
  String get uploadImagesVideoDesc;

  /// Step 5 title
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// Step 5 description
  ///
  /// In en, this message translates to:
  /// **'Review your information and submit the request. You\'ll receive updates on your request status.'**
  String get submitRequestDesc;

  /// Managing requests section title
  ///
  /// In en, this message translates to:
  /// **'Managing Your Requests'**
  String get managingYourRequests;

  /// View all requests title
  ///
  /// In en, this message translates to:
  /// **'View All Requests'**
  String get viewAllRequests;

  /// View all requests description
  ///
  /// In en, this message translates to:
  /// **'Go to \"My Requests\" from the home screen to see all your submitted requests and their current status.'**
  String get viewAllRequestsDesc;

  /// Request status title
  ///
  /// In en, this message translates to:
  /// **'Request Status'**
  String get requestStatus;

  /// Request status description
  ///
  /// In en, this message translates to:
  /// **'Track your requests with status indicators: Pending, In Progress, Completed, or Cancelled.'**
  String get requestStatusDesc;

  /// View request details title
  ///
  /// In en, this message translates to:
  /// **'View Request Details'**
  String get viewRequestDetails;

  /// View request details description
  ///
  /// In en, this message translates to:
  /// **'Tap on any request card to see full details, including vehicle information, part details, and attached media.'**
  String get viewRequestDetailsDesc;

  /// FAQ section title
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// FAQ question 1
  ///
  /// In en, this message translates to:
  /// **'How long does it take to process a request?'**
  String get faqProcessingTime;

  /// FAQ answer 1
  ///
  /// In en, this message translates to:
  /// **'Request processing time varies depending on part availability. Typically, you\'ll receive a response within 24-48 hours.'**
  String get faqProcessingTimeAnswer;

  /// FAQ question 2
  ///
  /// In en, this message translates to:
  /// **'Can I edit or cancel my request?'**
  String get faqEditCancel;

  /// FAQ answer 2
  ///
  /// In en, this message translates to:
  /// **'You can view your request details, but editing and cancellation features are currently being developed.'**
  String get faqEditCancelAnswer;

  /// FAQ question 3
  ///
  /// In en, this message translates to:
  /// **'What information should I include?'**
  String get faqWhatInformation;

  /// FAQ answer 3
  ///
  /// In en, this message translates to:
  /// **'Provide as much detail as possible: vehicle make, model, year, part name/number, and clear photos or videos.'**
  String get faqWhatInformationAnswer;

  /// FAQ question 4
  ///
  /// In en, this message translates to:
  /// **'How do I track my request status?'**
  String get faqTrackStatus;

  /// FAQ answer 4
  ///
  /// In en, this message translates to:
  /// **'Navigate to \"My Requests\" to see all your requests with their current status. Tap on any request for detailed information.'**
  String get faqTrackStatusAnswer;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Need More Help?'**
  String get needMoreHelp;

  /// Contact card title
  ///
  /// In en, this message translates to:
  /// **'Still Need Help?'**
  String get stillNeedHelp;

  /// Contact card subtitle
  ///
  /// In en, this message translates to:
  /// **'Contact our support team for assistance'**
  String get contactSupportTeam;

  /// Email button
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Call button
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// Request details page title
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// Loading request details message
  ///
  /// In en, this message translates to:
  /// **'Loading request details...'**
  String get loadingRequestDetails;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Failed to load request details message
  ///
  /// In en, this message translates to:
  /// **'Failed to load request details'**
  String get failedToLoadRequestDetails;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Request not found message
  ///
  /// In en, this message translates to:
  /// **'Request not found'**
  String get requestNotFound;

  /// Go back button
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Part information section
  ///
  /// In en, this message translates to:
  /// **'Part Information'**
  String get partInformation;

  /// Part name label
  ///
  /// In en, this message translates to:
  /// **'Part Name'**
  String get partName;

  /// Part number label
  ///
  /// In en, this message translates to:
  /// **'Part Number'**
  String get partNumber;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Vehicle information section
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformation;

  /// Vehicle type label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// Model label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Year label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Media section
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// Vehicle image label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Image'**
  String get vehicleImage;

  /// Part image label
  ///
  /// In en, this message translates to:
  /// **'Part Image'**
  String get partImage;

  /// Part video label
  ///
  /// In en, this message translates to:
  /// **'Part Video'**
  String get partVideo;

  /// Tap to view video text
  ///
  /// In en, this message translates to:
  /// **'Tap to view video'**
  String get tapToViewVideo;

  /// Suggested products section
  ///
  /// In en, this message translates to:
  /// **'Suggested Products'**
  String get suggestedProducts;

  /// Admin suggested products message
  ///
  /// In en, this message translates to:
  /// **'Admin has suggested the following products for your request'**
  String get adminSuggestedProducts;

  /// Added to cart message
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart'**
  String addedToCart(String productName);

  /// View cart button
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCart;

  /// Failed to add to cart message
  ///
  /// In en, this message translates to:
  /// **'Failed to add to cart: {error}'**
  String failedToAddToCart(String error);

  /// Request information section
  ///
  /// In en, this message translates to:
  /// **'Request Information'**
  String get requestInformation;

  /// Request ID label
  ///
  /// In en, this message translates to:
  /// **'Request ID'**
  String get requestId;

  /// Created label
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Last updated label
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No requests found title
  ///
  /// In en, this message translates to:
  /// **'No Requests Found'**
  String get noRequestsFound;

  /// No requests found message
  ///
  /// In en, this message translates to:
  /// **'You haven\'t made any spare part requests yet.'**
  String get noRequestsFoundMessage;

  /// Billing address section
  ///
  /// In en, this message translates to:
  /// **'Billing Address'**
  String get billingAddress;

  /// Fill billing address error
  ///
  /// In en, this message translates to:
  /// **'Please fill in all billing address fields'**
  String get fillBillingAddressFields;

  /// Payment page title
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Order summary title
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// Delete request dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Request'**
  String get deleteRequest;

  /// Delete request message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this request? This action cannot be undone.'**
  String get deleteRequestMessage;

  /// Deleting request message
  ///
  /// In en, this message translates to:
  /// **'Deleting request...'**
  String get deletingRequest;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Request deleted success message
  ///
  /// In en, this message translates to:
  /// **'Request deleted successfully'**
  String get requestDeletedSuccessfully;

  /// Failed to delete request message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete request'**
  String get failedToDeleteRequest;

  /// Need help card title
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// Need help card description
  ///
  /// In en, this message translates to:
  /// **'Learn how to request spare parts and manage your requests'**
  String get needHelpDescription;

  /// Total requests label
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get totalRequests;

  /// Pending requests label
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Completed requests label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Street address field label
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// Street address hint
  ///
  /// In en, this message translates to:
  /// **'House number, street name'**
  String get houseNumberStreetName;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// State/Province field label
  ///
  /// In en, this message translates to:
  /// **'State/Province (Optional)'**
  String get stateProvinceOptional;

  /// Country field label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Phone number validation error
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// Phone number format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
