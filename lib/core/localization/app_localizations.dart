import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Lost & Found',
      'search': 'Search',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'submit': 'Submit',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'no_data': 'No data available',
      'retry': 'Retry',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',

      'welcome_back': 'Welcome Back!',
      'search_items': 'Search items...',
      'all': 'All',
      'lost': 'Lost',
      'found': 'Found',
      'total': 'Total',
      'lost_items': 'Lost Items',
      'found_items': 'Found Items',
      'recent_items': 'Recent Items',
      'see_all': 'See All',
      'no_items_found': 'No items found',
      'no_items_description':
          'There are no items matching your search criteria.',

      'categories': 'Categories',
      'all_categories': 'All Categories',
      'select_category': 'Select Category',

      'item_details': 'Item Details',
      'description': 'Description',
      'location': 'Location',
      'reported_by': 'Reported By',
      'contact': 'Contact',
      'claim_item': 'Claim Item',
      'report_item': 'Report Item',
      'no_description': 'No description provided.',

      'report_lost_item': 'Report Lost Item',
      'report_found_item': 'Report Found Item',
      'item_name': 'Item Name',
      'item_description': 'Item Description',
      'item_location': 'Item Location',
      'select_type': 'Select Type',
      'add_photo': 'Add Photo',
      'add_video': 'Add Video',

      'profile': 'Profile',
      'my_items': 'My Items',
      'settings': 'Settings',
      'logout': 'Logout',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',

      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',

      'language': 'Language',
      'english': 'English',
      'nepali': 'Nepali',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'about': 'About',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',

      'item_reported_success': 'Item reported successfully!',
      'item_claimed_success': 'Item claimed successfully!',
      'item_deleted_success': 'Item deleted successfully!',
      'profile_updated_success': 'Profile updated successfully!',
      'no_internet': 'No internet connection',
      'something_went_wrong': 'Something went wrong',

      'sign_in_to_continue': 'Sign in to continue',
      'enter_your_email': 'Enter your email',
      'enter_your_password': 'Enter your password',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'password_min_length': 'Password must be at least 6 characters',
      'or': 'OR',
      'join_us_today': 'Join Us Today',
      'create_account_subtitle': 'Create your account to get started',
      'enter_full_name': 'Enter your full name',
      'please_enter_name': 'Please enter your name',
      'name_min_length': 'Name must be at least 3 characters',
      'email_address': 'Email Address',
      'code': 'Code',
      'select_batch': 'Select Batch',
      'loading_batches': 'Loading batches...',
      'choose_batch': 'Choose your batch',
      'please_select_batch': 'Please select your batch',
      'create_strong_password': 'Create a strong password',
      'reenter_password': 'Re-enter your password',
      'please_confirm_password': 'Please confirm your password',
      'passwords_not_match': 'Passwords do not match',
      'agree_terms': 'Please agree to the Terms & Conditions',
      'create_account': 'Create Account',
      'registration_success': 'Registration successful! Please login.',

      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',
      'report_lost_items_title': 'Report Lost Items',
      'report_lost_items_desc':
          'Quickly report lost items with photos and detailed descriptions. Our smart matching helps reunite you with your belongings.',
      'find_discover_title': 'Find & Discover',
      'find_discover_desc':
          "Browse through found items in real-time. Advanced filters help you find exactly what you're looking for.",
      'connect_instantly_title': 'Connect Instantly',
      'connect_instantly_desc':
          'Chat directly with finders or owners. Get instant notifications and recover your items quickly and securely.',

      'home': 'Home',
      'alerts': 'Alerts',

      'privacy_security': 'Privacy & Security',
      'help_support': 'Help & Support',
      'logout_confirm': 'Are you sure you want to logout?',
      'version': 'Version',

      'category': 'Category',
      'where_lost': 'Where did you lose it?',
      'where_found': 'Where did you find it?',
      'provide_details': 'Provide additional details about the item...',
      'lost_item_success': 'Lost item reported successfully!',
      'found_item_success': 'Found item reported successfully!',
      'permission_required': 'Permission Required',
      'permission_denied_message':
          'This feature requires permission to access your camera or gallery. Please enable it in your device settings.',
      'open_settings': 'Open Settings',
      'gallery_error':
          'Unable to access gallery. Please try using the camera instead.',

      'anonymous': 'Anonymous',
      'found_this_item': 'Found This Item?',
      'claim_item_title': 'Claim Item',
      'found_item_dialog_content':
          'You will be connected with the owner to return the item. Continue?',
      'claim_item_dialog_content':
          'Please provide proof of ownership to claim this item.',
      'continue_text': 'Continue',
      'owner_notified': 'Owner has been notified!',
      'claim_request_sent': 'Claim request sent!',

      'track_your_reports': 'Track your reports',
      'no_lost_items': 'No lost items reported',
      'no_found_items': 'No found items reported',
      'delete_item': 'Delete Item',
      'delete_confirm': 'Are you sure you want to delete',
      'other': 'Other',

      'please_enter_item_name': 'Please enter item name',
      'please_enter_location': 'Please enter location',
      'item_name_hint': 'e.g., iPhone 14 Pro, Blue Wallet',
    },
    'ne': {
      'app_name': 'हराएको र भेटिएको',
      'search': 'खोज्नुहोस्',
      'cancel': 'रद्द गर्नुहोस्',
      'save': 'सुरक्षित गर्नुहोस्',
      'delete': 'मेटाउनुहोस्',
      'edit': 'सम्पादन गर्नुहोस्',
      'submit': 'पेश गर्नुहोस्',
      'loading': 'लोड हुँदैछ...',
      'error': 'त्रुटि',
      'success': 'सफल',
      'no_data': 'कुनै डाटा उपलब्ध छैन',
      'retry': 'पुन: प्रयास गर्नुहोस्',
      'yes': 'हो',
      'no': 'होइन',
      'ok': 'ठीक छ',

      'welcome_back': 'फेरि स्वागत छ!',
      'search_items': 'वस्तुहरू खोज्नुहोस्...',
      'all': 'सबै',
      'lost': 'हराएको',
      'found': 'भेटिएको',
      'total': 'जम्मा',
      'lost_items': 'हराएका वस्तुहरू',
      'found_items': 'भेटिएका वस्तुहरू',
      'recent_items': 'हालैका वस्तुहरू',
      'see_all': 'सबै हेर्नुहोस्',
      'no_items_found': 'कुनै वस्तु भेटिएन',
      'no_items_description': 'तपाईंको खोज मापदण्डसँग मेल खाने कुनै वस्तु छैन।',

      'categories': 'वर्गहरू',
      'all_categories': 'सबै वर्गहरू',
      'select_category': 'वर्ग छान्नुहोस्',

      'item_details': 'वस्तुको विवरण',
      'description': 'विवरण',
      'location': 'स्थान',
      'reported_by': 'रिपोर्ट गर्ने',
      'contact': 'सम्पर्क',
      'claim_item': 'वस्तु दावी गर्नुहोस्',
      'report_item': 'वस्तु रिपोर्ट गर्नुहोस्',
      'no_description': 'कुनै विवरण प्रदान गरिएको छैन।',

      'report_lost_item': 'हराएको वस्तु रिपोर्ट गर्नुहोस्',
      'report_found_item': 'भेटिएको वस्तु रिपोर्ट गर्नुहोस्',
      'item_name': 'वस्तुको नाम',
      'item_description': 'वस्तुको विवरण',
      'item_location': 'वस्तुको स्थान',
      'select_type': 'प्रकार छान्नुहोस्',
      'add_photo': 'फोटो थप्नुहोस्',
      'add_video': 'भिडियो थप्नुहोस्',

      'profile': 'प्रोफाइल',
      'my_items': 'मेरा वस्तुहरू',
      'settings': 'सेटिङहरू',
      'logout': 'लग आउट',
      'edit_profile': 'प्रोफाइल सम्पादन गर्नुहोस्',
      'change_password': 'पासवर्ड परिवर्तन गर्नुहोस्',

      'login': 'लग इन',
      'signup': 'साइन अप',
      'email': 'इमेल',
      'password': 'पासवर्ड',
      'confirm_password': 'पासवर्ड पुष्टि गर्नुहोस्',
      'forgot_password': 'पासवर्ड बिर्सनुभयो?',
      'full_name': 'पूरा नाम',
      'phone_number': 'फोन नम्बर',
      'dont_have_account': 'खाता छैन?',
      'already_have_account': 'पहिले नै खाता छ?',

      'language': 'भाषा',
      'english': 'अंग्रेजी',
      'nepali': 'नेपाली',
      'dark_mode': 'डार्क मोड',
      'notifications': 'सूचनाहरू',
      'about': 'बारेमा',
      'privacy_policy': 'गोपनीयता नीति',
      'terms_of_service': 'सेवाका सर्तहरू',

      'item_reported_success': 'वस्तु सफलतापूर्वक रिपोर्ट गरियो!',
      'item_claimed_success': 'वस्तु सफलतापूर्वक दावी गरियो!',
      'item_deleted_success': 'वस्तु सफलतापूर्वक मेटाइयो!',
      'profile_updated_success': 'प्रोफाइल सफलतापूर्वक अपडेट गरियो!',
      'no_internet': 'इन्टरनेट जडान छैन',
      'something_went_wrong': 'केही गलत भयो',

      'sign_in_to_continue': 'जारी राख्न साइन इन गर्नुहोस्',
      'enter_your_email': 'तपाईंको इमेल प्रविष्ट गर्नुहोस्',
      'enter_your_password': 'तपाईंको पासवर्ड प्रविष्ट गर्नुहोस्',
      'please_enter_email': 'कृपया तपाईंको इमेल प्रविष्ट गर्नुहोस्',
      'please_enter_valid_email': 'कृपया वैध इमेल प्रविष्ट गर्नुहोस्',
      'please_enter_password': 'कृपया तपाईंको पासवर्ड प्रविष्ट गर्नुहोस्',
      'password_min_length': 'पासवर्ड कम्तीमा ६ वर्ण हुनुपर्छ',
      'or': 'वा',
      'join_us_today': 'आज हामीसँग जोडिनुहोस्',
      'create_account_subtitle': 'सुरु गर्न आफ्नो खाता बनाउनुहोस्',
      'enter_full_name': 'तपाईंको पूरा नाम प्रविष्ट गर्नुहोस्',
      'please_enter_name': 'कृपया तपाईंको नाम प्रविष्ट गर्नुहोस्',
      'name_min_length': 'नाम कम्तीमा ३ वर्ण हुनुपर्छ',
      'email_address': 'इमेल ठेगाना',
      'code': 'कोड',
      'select_batch': 'ब्याच छान्नुहोस्',
      'loading_batches': 'ब्याचहरू लोड हुँदैछ...',
      'choose_batch': 'आफ्नो ब्याच छान्नुहोस्',
      'please_select_batch': 'कृपया आफ्नो ब्याच छान्नुहोस्',
      'create_strong_password': 'बलियो पासवर्ड बनाउनुहोस्',
      'reenter_password': 'पासवर्ड पुन: प्रविष्ट गर्नुहोस्',
      'please_confirm_password': 'कृपया पासवर्ड पुष्टि गर्नुहोस्',
      'passwords_not_match': 'पासवर्डहरू मेल खाएनन्',
      'agree_terms': 'कृपया नियम र सर्तहरूमा सहमत हुनुहोस्',
      'create_account': 'खाता बनाउनुहोस्',
      'registration_success': 'दर्ता सफल भयो! कृपया लग इन गर्नुहोस्।',

      'skip': 'छोड्नुहोस्',
      'next': 'अर्को',
      'get_started': 'सुरु गर्नुहोस्',
      'report_lost_items_title': 'हराएको वस्तु रिपोर्ट गर्नुहोस्',
      'report_lost_items_desc':
          'फोटो र विस्तृत विवरणसहित हराएको वस्तु छिटो रिपोर्ट गर्नुहोस्। हाम्रो स्मार्ट म्याचिङले तपाईंको सामानसँग पुन: मिलाउन मद्दत गर्छ।',
      'find_discover_title': 'खोज्नुहोस् र पत्ता लगाउनुहोस्',
      'find_discover_desc':
          'वास्तविक समयमा भेटिएका वस्तुहरू हेर्नुहोस्। उन्नत फिल्टरहरूले तपाईंलाई खोज्दै हुनुहुन्छ भनेर पत्ता लगाउन मद्दत गर्छ।',
      'connect_instantly_title': 'तुरुन्त जडान गर्नुहोस्',
      'connect_instantly_desc':
          'खोज्ने वा मालिकसँग सीधा च्याट गर्नुहोस्। तुरुन्त सूचनाहरू प्राप्त गर्नुहोस् र आफ्नो वस्तुहरू छिटो र सुरक्षित रूपमा पुन: प्राप्त गर्नुहोस्।',

      'home': 'गृह',
      'alerts': 'अलर्टहरू',

      'privacy_security': 'गोपनीयता र सुरक्षा',
      'help_support': 'मद्दत र सहयोग',
      'logout_confirm': 'के तपाईं लग आउट गर्न चाहनुहुन्छ?',
      'version': 'संस्करण',

      'category': 'वर्ग',
      'where_lost': 'तपाईंले कहाँ हराउनुभयो?',
      'where_found': 'तपाईंले कहाँ भेट्नुभयो?',
      'provide_details': 'वस्तुको बारेमा थप विवरण दिनुहोस्...',
      'lost_item_success': 'हराएको वस्तु सफलतापूर्वक रिपोर्ट गरियो!',
      'found_item_success': 'भेटिएको वस्तु सफलतापूर्वक रिपोर्ट गरियो!',
      'permission_required': 'अनुमति आवश्यक छ',
      'permission_denied_message':
          'यो सुविधाले तपाईंको क्यामेरा वा ग्यालेरी पहुँच गर्न अनुमति चाहिन्छ। कृपया यसलाई आफ्नो उपकरण सेटिङमा सक्षम गर्नुहोस्।',
      'open_settings': 'सेटिङ खोल्नुहोस्',
      'gallery_error':
          'ग्यालेरी पहुँच गर्न सकिएन। कृपया क्यामेरा प्रयोग गर्नुहोस्।',

      'anonymous': 'अज्ञात',
      'found_this_item': 'यो वस्तु भेट्टाउनुभयो?',
      'claim_item_title': 'वस्तु दावी गर्नुहोस्',
      'found_item_dialog_content':
          'तपाईं वस्तु फिर्ता गर्न मालिकसँग जडान हुनुहुनेछ। जारी राख्ने?',
      'claim_item_dialog_content':
          'कृपया यो वस्तु दावी गर्न स्वामित्वको प्रमाण दिनुहोस्।',
      'continue_text': 'जारी राख्नुहोस्',
      'owner_notified': 'मालिकलाई सूचित गरिएको छ!',
      'claim_request_sent': 'दावी अनुरोध पठाइयो!',

      'track_your_reports': 'तपाईंको रिपोर्टहरू ट्र्याक गर्नुहोस्',
      'no_lost_items': 'कुनै हराएको वस्तु रिपोर्ट गरिएको छैन',
      'no_found_items': 'कुनै भेटिएको वस्तु रिपोर्ट गरिएको छैन',
      'delete_item': 'वस्तु मेटाउनुहोस्',
      'delete_confirm': 'के तपाईं मेटाउन चाहनुहुन्छ',
      'other': 'अन्य',

      'please_enter_item_name': 'कृपया वस्तुको नाम प्रविष्ट गर्नुहोस्',
      'please_enter_location': 'कृपया स्थान प्रविष्ट गर्नुहोस्',
      'item_name_hint': 'जस्तै, iPhone 14 Pro, नीलो वालेट',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static const Map<String, String> _nepaliNumerals = {
    '0': '०',
    '1': '१',
    '2': '२',
    '3': '३',
    '4': '४',
    '5': '५',
    '6': '६',
    '7': '७',
    '8': '८',
    '9': '९',
  };

  String formatNumber(dynamic number) {
    final numberString = number.toString();
    if (locale.languageCode == 'ne') {
      return numberString
          .split('')
          .map((char) {
            return _nepaliNumerals[char] ?? char;
          })
          .join('');
    }
    return numberString;
  }

  String get appName => translate('app_name');
  String get search => translate('search');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get submit => translate('submit');
  String get loading => translate('loading');
  String get error => translate('error');
  String get success => translate('success');
  String get noData => translate('no_data');
  String get retry => translate('retry');
  String get yes => translate('yes');
  String get no => translate('no');
  String get ok => translate('ok');

  String get welcomeBack => translate('welcome_back');
  String get searchItems => translate('search_items');
  String get all => translate('all');
  String get lost => translate('lost');
  String get found => translate('found');
  String get total => translate('total');
  String get lostItems => translate('lost_items');
  String get foundItems => translate('found_items');
  String get recentItems => translate('recent_items');
  String get seeAll => translate('see_all');
  String get noItemsFound => translate('no_items_found');
  String get noItemsDescription => translate('no_items_description');

  String get categories => translate('categories');
  String get allCategories => translate('all_categories');
  String get selectCategory => translate('select_category');

  String get itemDetails => translate('item_details');
  String get description => translate('description');
  String get location => translate('location');
  String get reportedBy => translate('reported_by');
  String get contact => translate('contact');
  String get claimItem => translate('claim_item');
  String get reportItem => translate('report_item');
  String get noDescription => translate('no_description');

  String get reportLostItem => translate('report_lost_item');
  String get reportFoundItem => translate('report_found_item');
  String get itemName => translate('item_name');
  String get itemDescription => translate('item_description');
  String get itemLocation => translate('item_location');
  String get selectType => translate('select_type');
  String get addPhoto => translate('add_photo');
  String get addVideo => translate('add_video');

  String get profile => translate('profile');
  String get myItems => translate('my_items');
  String get settings => translate('settings');
  String get logout => translate('logout');
  String get editProfile => translate('edit_profile');
  String get changePassword => translate('change_password');

  String get login => translate('login');
  String get signup => translate('signup');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get fullName => translate('full_name');
  String get phoneNumber => translate('phone_number');
  String get dontHaveAccount => translate('dont_have_account');
  String get alreadyHaveAccount => translate('already_have_account');

  String get language => translate('language');
  String get english => translate('english');
  String get nepali => translate('nepali');
  String get darkMode => translate('dark_mode');
  String get notifications => translate('notifications');
  String get about => translate('about');
  String get privacyPolicy => translate('privacy_policy');
  String get termsOfService => translate('terms_of_service');

  String get itemReportedSuccess => translate('item_reported_success');
  String get itemClaimedSuccess => translate('item_claimed_success');
  String get itemDeletedSuccess => translate('item_deleted_success');
  String get profileUpdatedSuccess => translate('profile_updated_success');
  String get noInternet => translate('no_internet');
  String get somethingWentWrong => translate('something_went_wrong');

  String get signInToContinue => translate('sign_in_to_continue');
  String get enterYourEmail => translate('enter_your_email');
  String get enterYourPassword => translate('enter_your_password');
  String get pleaseEnterEmail => translate('please_enter_email');
  String get pleaseEnterValidEmail => translate('please_enter_valid_email');
  String get pleaseEnterPassword => translate('please_enter_password');
  String get passwordMinLength => translate('password_min_length');
  String get or => translate('or');
  String get joinUsToday => translate('join_us_today');
  String get createAccountSubtitle => translate('create_account_subtitle');
  String get enterFullName => translate('enter_full_name');
  String get pleaseEnterName => translate('please_enter_name');
  String get nameMinLength => translate('name_min_length');
  String get emailAddress => translate('email_address');
  String get code => translate('code');
  String get selectBatch => translate('select_batch');
  String get loadingBatches => translate('loading_batches');
  String get chooseBatch => translate('choose_batch');
  String get pleaseSelectBatch => translate('please_select_batch');
  String get createStrongPassword => translate('create_strong_password');
  String get reenterPassword => translate('reenter_password');
  String get pleaseConfirmPassword => translate('please_confirm_password');
  String get passwordsNotMatch => translate('passwords_not_match');
  String get agreeTerms => translate('agree_terms');
  String get createAccount => translate('create_account');
  String get registrationSuccess => translate('registration_success');

  String get skip => translate('skip');
  String get next => translate('next');
  String get getStarted => translate('get_started');
  String get reportLostItemsTitle => translate('report_lost_items_title');
  String get reportLostItemsDesc => translate('report_lost_items_desc');
  String get findDiscoverTitle => translate('find_discover_title');
  String get findDiscoverDesc => translate('find_discover_desc');
  String get connectInstantlyTitle => translate('connect_instantly_title');
  String get connectInstantlyDesc => translate('connect_instantly_desc');

  String get home => translate('home');
  String get alerts => translate('alerts');

  String get privacySecurity => translate('privacy_security');
  String get helpSupport => translate('help_support');
  String get logoutConfirm => translate('logout_confirm');
  String get version => translate('version');

  String get category => translate('category');
  String get whereLost => translate('where_lost');
  String get whereFound => translate('where_found');
  String get provideDetails => translate('provide_details');
  String get lostItemSuccess => translate('lost_item_success');
  String get foundItemSuccess => translate('found_item_success');
  String get permissionRequired => translate('permission_required');
  String get permissionDeniedMessage => translate('permission_denied_message');
  String get openSettings => translate('open_settings');
  String get galleryError => translate('gallery_error');

  String get anonymous => translate('anonymous');
  String get foundThisItem => translate('found_this_item');
  String get claimItemTitle => translate('claim_item_title');
  String get foundItemDialogContent => translate('found_item_dialog_content');
  String get claimItemDialogContent => translate('claim_item_dialog_content');
  String get continueText => translate('continue_text');
  String get ownerNotified => translate('owner_notified');
  String get claimRequestSent => translate('claim_request_sent');

  String get trackYourReports => translate('track_your_reports');
  String get noLostItems => translate('no_lost_items');
  String get noFoundItems => translate('no_found_items');
  String get deleteItem => translate('delete_item');
  String get deleteConfirm => translate('delete_confirm');
  String get other => translate('other');

  String get pleaseEnterItemName => translate('please_enter_item_name');
  String get pleaseEnterLocation => translate('please_enter_location');
  String get itemNameHint => translate('item_name_hint');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ne'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
