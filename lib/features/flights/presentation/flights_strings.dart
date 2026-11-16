/// Flights feature strings.
///
/// Keys are namespaced (`flights.something`) and registered in
/// `lib/core/l10n/app_text.dart`. Keep both maps in step — a key missing from
/// Bangla silently falls back to the English line.
library;

const Map<String, String> flightsEn = <String, String>{
  // ── Search page ──
  'flights.title': 'Flight',
  'flights.multiCity': 'Multi City',
  'flights.multiCitySoon': 'Multi City search is coming soon.',
  'flights.addReturn': '+ Add return date',
  'flights.returnNudge': 'Save more on return flight!',
  'flights.returnOn': 'Returning',
  'flights.searchCta': 'Search',

  // ── Travellers & class ──
  'flights.traveler': 'Traveler',
  'flights.travelers': 'Travelers',
  'flights.whoTravels': 'Who is travelling?',
  'flights.whoTravelsNote': 'Adults aged 12 and over',
  'flights.classTitle': 'Travel class',
  'flights.classNote': 'Cabin preference for every traveler',
  'flights.classEconomy': 'Economy',
  'flights.classPremium': 'Premium Economy',
  'flights.classBusiness': 'Business',
  'flights.classFirst': 'First Class',

  // ── Hot deals ──
  'flights.hotDeals': 'Hot Deals',
  'flights.dealBadge': 'Limited time',
  'flights.dealTitle': 'Dhaka to Dubai from OMR 125',
  'flights.dealBody': 'Return fares on selected airlines, booked through our desk.',

  // ── Airport selector ──
  'flights.fromTitle': 'Departure city',
  'flights.toTitle': 'Destination city',
  'flights.airportSearchNote': 'Search by city, airport or IATA code',
  'flights.airportSearchHint': 'Dhaka, DAC, Heathrow…',
  'flights.noAirports': 'No airports match that',
  'flights.noAirportsBody':
      'Try a city name like Dubai, or a three letter code like DXB.',

  // ── Results ──
  'flights.results': 'Available flights',
  'flights.searching': 'Finding the best fares…',
  'flights.optionsOne': 'option',
  'flights.optionsMany': 'options',
  'flights.sort': 'Sort',
  'flights.sortTitle': 'Sort results',
  'flights.sortRecommended': 'Recommended',
  'flights.sortCheapest': 'Cheapest',
  'flights.sortFastest': 'Fastest',
  'flights.sortEarliest': 'Earliest',
  'flights.filterAll': 'All',
  'flights.filterCheap': 'Under OMR 150',
  'flights.filterDirect': 'Direct',
  'flights.filterMorning': 'Morning',
  'flights.filterEvening': 'Evening',
  'flights.noMatch': 'No flights match',
  'flights.noMatchAll':
      'Try a different destination, or refresh for the latest fares.',
  'flights.noMatchFilter': 'Nothing fits this filter right now.',
  'flights.clearFilter': 'Clear filter',
  'flights.refreshFares': 'Refresh fares',

  // ── Booking sheet ──
  'flights.bookTitle': 'Book flight ticket',
  'flights.passengerInfo': 'Passenger information',
  'flights.fullName': 'Full name',
  'flights.fullNameHint': 'Name exactly as in the passport',
  'flights.fullNameError': 'Please enter the traveler name',
  'flights.phone': 'Phone number',
  'flights.phoneHint': '+968 or +880 number',
  'flights.phoneError': 'Please enter a phone number',
  'flights.passport': 'Passport number',
  'flights.passportHint': 'e.g. A01234567',
  'flights.email': 'Email address',
  'flights.emailHint': 'name@example.com',
  'flights.notes': 'Address / special requests',
  'flights.notesHint': 'e.g. Muscat, Oman / meal preference',
  'flights.noPayment':
      'No payment is taken here. We hold your fare and confirm by phone before ticketing.',
  'flights.totalFare': 'Total fare',
  'flights.confirm': 'Confirm booking',
  'flights.sending': 'Sending…',
  'flights.bookWhatsapp': 'Book on WhatsApp',
  'flights.sentTitle': 'Booking request sent',
  'flights.sentBody':
      'Our travel specialist will call you shortly to confirm your seats and tickets.',
  'flights.bookingFailed': 'We could not send the request. Please try again.',
};

const Map<String, String> flightsBn = <String, String>{
  // ── Search page ──
  'flights.title': 'ফ্লাইট',
  'flights.multiCity': 'মাল্টি সিটি',
  'flights.multiCitySoon': 'মাল্টি সিটি খোঁজা খুব শিগগিরই আসছে।',
  'flights.addReturn': '+ ফেরার তারিখ',
  'flights.returnNudge': 'ফেরার টিকিটে আরও সাশ্রয়!',
  'flights.returnOn': 'ফিরছেন',
  'flights.searchCta': 'খুঁজুন',

  // ── Travellers & class ──
  'flights.traveler': 'জন যাত্রী',
  'flights.travelers': 'জন যাত্রী',
  'flights.whoTravels': 'কারা যাচ্ছেন?',
  'flights.whoTravelsNote': '১২ বছরের বেশি বয়সী যাত্রী',
  'flights.classTitle': 'ভ্রমণ ক্লাস',
  'flights.classNote': 'প্রত্যেক যাত্রীর জন্য কেবিন পছন্দ',
  'flights.classEconomy': 'ইকোনমি',
  'flights.classPremium': 'প্রিমিয়াম ইকোনমি',
  'flights.classBusiness': 'বিজনেস',
  'flights.classFirst': 'ফার্স্ট ক্লাস',

  // ── Hot deals ──
  'flights.hotDeals': 'সেরা অফার',
  'flights.dealBadge': 'সীমিত সময়',
  'flights.dealTitle': 'ঢাকা থেকে দুবাই OMR ১২৫ থেকে',
  'flights.dealBody': 'নির্বাচিত এয়ারলাইনে ফেরার টিকিটসহ ভাড়া, আমাদের ডেস্কের মাধ্যমে।',

  // ── Airport selector ──
  'flights.fromTitle': 'যাত্রা শুরুর শহর',
  'flights.toTitle': 'গন্তব্যের শহর',
  'flights.airportSearchNote': 'শহর, বিমানবন্দর বা কোড দিয়ে খুঁজুন',
  'flights.airportSearchHint': 'ঢাকা, DAC, হিথ্রো…',
  'flights.noAirports': 'কোনো বিমানবন্দর মেলেনি',
  'flights.noAirportsBody': 'দুবাইয়ের মতো শহরের নাম বা DXB-এর মতো কোড লিখে দেখুন।',

  // ── Results ──
  'flights.results': 'ফ্লাইট পাওয়া যাচ্ছে',
  'flights.searching': 'সেরা ভাড়া খোঁজা হচ্ছে…',
  'flights.optionsOne': 'টি ফ্লাইট',
  'flights.optionsMany': 'টি ফ্লাইট',
  'flights.sort': 'সাজান',
  'flights.sortTitle': 'ফলাফল সাজান',
  'flights.sortRecommended': 'আমাদের পছন্দ',
  'flights.sortCheapest': 'কম দামে',
  'flights.sortFastest': 'দ্রুততম',
  'flights.sortEarliest': 'আগে ছাড়ে',
  'flights.filterAll': 'সব',
  'flights.filterCheap': 'OMR ১৫০-এর নিচে',
  'flights.filterDirect': 'সরাসরি',
  'flights.filterMorning': 'সকাল',
  'flights.filterEvening': 'বিকেল',
  'flights.noMatch': 'কোনো ফ্লাইট মেলেনি',
  'flights.noMatchAll': 'অন্য গন্তব্য দেখুন, অথবা নতুন ভাড়ার জন্য রিফ্রেশ করুন।',
  'flights.noMatchFilter': 'এই ফিল্টারে এখন কিছু নেই।',
  'flights.clearFilter': 'ফিল্টার সরান',
  'flights.refreshFares': 'ভাড়া রিফ্রেশ করুন',

  // ── Booking sheet ──
  'flights.bookTitle': 'ফ্লাইট টিকিট বুকিং',
  'flights.passengerInfo': 'যাত্রীর তথ্য',
  'flights.fullName': 'পুরো নাম',
  'flights.fullNameHint': 'পাসপোর্টে যেভাবে লেখা আছে',
  'flights.fullNameError': 'যাত্রীর নাম লিখুন',
  'flights.phone': 'ফোন নম্বর',
  'flights.phoneHint': '+968 বা +880 নম্বর',
  'flights.phoneError': 'ফোন নম্বর লিখুন',
  'flights.passport': 'পাসপোর্ট নম্বর',
  'flights.passportHint': 'যেমন A01234567',
  'flights.email': 'ইমেইল ঠিকানা',
  'flights.emailHint': 'name@example.com',
  'flights.notes': 'ঠিকানা / বিশেষ অনুরোধ',
  'flights.notesHint': 'যেমন মাসকাট, ওমান / খাবারের পছন্দ',
  'flights.noPayment':
      'এখানে কোনো টাকা নেওয়া হয় না। টিকিট করার আগে ফোনে নিশ্চিত করা হবে।',
  'flights.totalFare': 'মোট ভাড়া',
  'flights.confirm': 'বুকিং নিশ্চিত করুন',
  'flights.sending': 'পাঠানো হচ্ছে…',
  'flights.bookWhatsapp': 'হোয়াটসঅ্যাপে বুক করুন',
  'flights.sentTitle': 'বুকিংয়ের অনুরোধ পাঠানো হয়েছে',
  'flights.sentBody': 'আমাদের ট্রাভেল বিশেষজ্ঞ শিগগিরই ফোন করে সিট ও টিকিট নিশ্চিত করবেন।',
  'flights.bookingFailed': 'অনুরোধটি পাঠানো যায়নি। আবার চেষ্টা করুন।',
};
