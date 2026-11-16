/// Strings shared across the whole app: navigation, actions, states.
///
/// Feature-specific copy lives in that feature's own strings file.
library;

const Map<String, String> commonEn = <String, String>{
  // Navigation
  'nav.home': 'Home',
  'nav.flights': 'Flights',
  'nav.umrah': 'Umrah',
  'nav.visa': 'Visa',
  'nav.trips': 'Bookings',
  'nav.bookings': 'Bookings',
  'nav.chat': 'Chat',
  'nav.inbox': 'Inbox',
  'nav.profile': 'Profile',

  // Services
  'service.flight': 'Flight',
  'service.hotel': 'Hotel',
  'service.tour': 'Tour',
  'service.visa': 'Visa',
  'service.umrah': 'Umrah',
  'service.deals': 'Deals',

  // Actions
  'action.search': 'Search',
  'action.bookNow': 'Book Now',
  'action.applyNow': 'Apply Now',
  'action.viewDetails': 'View Details',
  'action.viewAll': 'See All',
  'action.explore': 'Explore',
  'action.retry': 'Try Again',
  'action.refresh': 'Refresh',
  'action.continue': 'Continue',
  'action.cancel': 'Cancel',
  'action.submit': 'Submit',
  'action.close': 'Close',
  'action.share': 'Share',
  'action.call': 'Call us',
  'action.whatsapp': 'WhatsApp',
  'action.signIn': 'Sign in',
  'action.signOut': 'Sign out',

  // States
  'state.loading': 'Loading…',
  'state.empty': 'Nothing here yet',
  'state.emptyBody': 'We could not find anything matching this.',
  'state.error': 'Something went wrong',
  'state.errorBody': 'Please check your connection and try again.',
  'state.offline': 'You appear to be offline',

  // Language
  'lang.title': 'Choose your language',
  'lang.subtitle': 'You can change this any time from the help centre.',
  'lang.continue': 'Continue',
  'lang.english': 'English',
  'lang.bangla': 'বাংলা',
  'lang.changed': 'Language updated',

  // Splash
  'splash.tagline': 'You travel, we care',

  // Misc
  'common.perTraveler': 'per traveler',
  'common.perPerson': 'per person',
  'common.startingAt': 'Starting at',
  'common.from': 'From',
  'common.to': 'To',
  'common.departure': 'Departure',
  'common.return': 'Return',
  'common.travelers': 'Travelers',
  'common.class': 'Class',
  'common.oneWay': 'One Way',
  'common.roundTrip': 'Round Trip',
  'common.nonStop': 'Non-stop',
  'common.available': 'Available',
  'common.night': 'night',
  'common.day': 'day',
  'common.days': 'days',
};

const Map<String, String> commonBn = <String, String>{
  // Navigation
  'nav.home': 'হোম',
  'nav.flights': 'ফ্লাইট',
  'nav.umrah': 'উমরাহ',
  'nav.visa': 'ভিসা',
  'nav.trips': 'বুকিংস',
  'nav.bookings': 'বুকিংস',
  'nav.chat': 'চ্যাট',
  'nav.inbox': 'ইনবক্স',
  'nav.profile': 'প্রোফাইল',

  // Services
  'service.flight': 'ফ্লাইট',
  'service.hotel': 'হোটেল',
  'service.tour': 'ট্যুর',
  'service.visa': 'ভিসা',
  'service.umrah': 'উমরাহ',
  'service.deals': 'অফার',

  // Actions
  'action.search': 'খুঁজুন',
  'action.bookNow': 'বুক করুন',
  'action.applyNow': 'আবেদন করুন',
  'action.viewDetails': 'বিস্তারিত',
  'action.viewAll': 'সব দেখুন',
  'action.explore': 'ঘুরে দেখুন',
  'action.retry': 'আবার চেষ্টা করুন',
  'action.refresh': 'রিফ্রেশ',
  'action.continue': 'এগিয়ে যান',
  'action.cancel': 'বাতিল',
  'action.submit': 'জমা দিন',
  'action.close': 'বন্ধ করুন',
  'action.share': 'শেয়ার',
  'action.call': 'কল করুন',
  'action.whatsapp': 'হোয়াটসঅ্যাপ',
  'action.signIn': 'সাইন ইন',
  'action.signOut': 'সাইন আউট',

  // States
  'state.loading': 'লোড হচ্ছে…',
  'state.empty': 'এখানে এখনও কিছু নেই',
  'state.emptyBody': 'এই শর্তে কিছু খুঁজে পাওয়া যায়নি।',
  'state.error': 'কিছু একটা সমস্যা হয়েছে',
  'state.errorBody': 'ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করুন।',
  'state.offline': 'আপনি অফলাইনে আছেন বলে মনে হচ্ছে',

  // Language
  'lang.title': 'আপনার ভাষা বেছে নিন',
  'lang.subtitle': 'হেল্প সেন্টার থেকে যেকোনো সময় বদলাতে পারবেন।',
  'lang.continue': 'এগিয়ে যান',
  'lang.english': 'English',
  'lang.bangla': 'বাংলা',
  'lang.changed': 'ভাষা বদলানো হয়েছে',

  // Splash
  'splash.tagline': 'আপনি ভ্রমণ করুন, আমরা আছি পাশে',

  // Misc
  'common.perTraveler': 'জনপ্রতি',
  'common.perPerson': 'জনপ্রতি',
  'common.startingAt': 'শুরু',
  'common.from': 'যেখান থেকে',
  'common.to': 'যেখানে',
  'common.departure': 'যাত্রার তারিখ',
  'common.return': 'ফেরার তারিখ',
  'common.travelers': 'যাত্রী',
  'common.class': 'ক্লাস',
  'common.oneWay': 'ওয়ান ওয়ে',
  'common.roundTrip': 'রাউন্ড ট্রিপ',
  'common.nonStop': 'ননস্টপ',
  'common.available': 'খালি আছে',
  'common.night': 'রাত',
  'common.day': 'দিন',
  'common.days': 'দিন',
};
