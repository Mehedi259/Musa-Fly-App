/// Tours, Umrah and Visa strings.
///
/// Keys are namespaced (`journeys.something`) and registered in
/// `lib/core/l10n/app_text.dart`. Keep both maps in step — a key missing from
/// Bangla silently falls back to the English line.
library;

const Map<String, String> journeysEn = <String, String>{
  // ─────────── Shared across the three journeys ───────────
  'journeys.all': 'All',
  'journeys.anywhere': 'Anywhere',
  'journeys.budget': 'Budget',
  'journeys.anyBudget': 'Any budget',
  'journeys.budgetTitle': 'Choose a budget',
  'journeys.upTo': 'Up to',
  'journeys.andAbove': 'and above',
  'journeys.sort': 'Sort',
  'journeys.sortRecommended': 'Recommended',
  'journeys.sortPriceLow': 'Lowest price',
  'journeys.sortPriceHigh': 'Highest price',
  'journeys.available': 'available',
  'journeys.duration': 'Duration',
  'journeys.searchPlaceholder': 'Type to search…',
  'journeys.noMatch': 'Nothing matched',
  'journeys.clearFilters': 'Clear filters',
  'journeys.privacy': 'Your details are only used to prepare this request.',
  'journeys.fullName': 'Full name',
  'journeys.fullNameHint': 'Name as on passport',
  'journeys.phone': 'Phone number',
  'journeys.phoneHint': 'With country code',
  'journeys.email': 'Email',
  'journeys.emailHint': 'name@domain.com',
  'journeys.required': 'Required',
  'journeys.chatAdvisor': 'Chat with an advisor',
  'journeys.whatsappHint': 'Chat on WhatsApp',
  'journeys.submitError': 'Something went wrong. Please try again.',
  'journeys.step': 'Step',

  // ─────────── Tours ───────────
  'journeys.tours.eyebrow': 'Holidays & tours',
  'journeys.tours.title': 'Curated escapes,\nplanned end to end',
  'journeys.tours.subtitle':
      'Hand-picked holiday packages with flights, hotels, transfers and guided sightseeing.',
  'journeys.tours.destination': 'Destination',
  'journeys.tours.destinationTitle': 'Choose a destination',
  'journeys.tours.package': 'package',
  'journeys.tours.packages': 'packages',
  'journeys.tours.bestPrice': 'Best price promise',
  'journeys.tours.emptyTitle': 'No tours yet',
  'journeys.tours.emptyBody':
      'No holiday packages are published right now. Pull down to refresh or check back soon.',
  'journeys.tours.errorTitle': 'Could not load tours',
  'journeys.tours.noMatchBody':
      'No packages match this search. Try another destination or a wider budget.',
  'journeys.tours.inclusionsFallback':
      'Hotels, airport transfers and guided sightseeing included.',
  'journeys.tours.verified': 'Verified operator · free cancellation',
  'journeys.tours.glance': 'Trip at a glance',
  'journeys.tours.stay': 'Stay',
  'journeys.tours.stayValue': '4★ hotels',
  'journeys.tours.transfers': 'Transfers',
  'journeys.tours.transfersValue': 'Private',
  'journeys.tours.included': "What's included",
  'journeys.tours.includedSub': 'Everything covered by the package price',
  'journeys.tours.why': 'Why book with MusaFly',
  'journeys.tours.why1': 'Premium accommodation',
  'journeys.tours.why1Body':
      'Hand-picked 4-star and luxury properties, centrally located.',
  'journeys.tours.why2': 'Airport & sightseeing transfers',
  'journeys.tours.why2Body':
      'Private air-conditioned vehicles with an English-speaking driver.',
  'journeys.tours.why3': '24/7 concierge',
  'journeys.tours.why3Body':
      'On-ground assistance at your destination, at any hour.',
  'journeys.tours.taxNote':
      'All taxes and service charges are already included in this price.',
  'journeys.tours.book': 'Book package',
  'journeys.tours.guests': 'Guests & special requests',
  'journeys.tours.guestsHint': 'e.g. 2 adults, 1 child',
  'journeys.tours.submit': 'Send booking request',
  'journeys.tours.successTitle': 'Tour request received',
  'journeys.tours.successBody':
      'Our holiday planner will contact you shortly to tailor this trip for you.',
  'journeys.tours.wa': 'Hello MusaFly! I am interested in this holiday package:',
  'journeys.tours.waShare': 'Have a look at this holiday package on MusaFly:',
  'journeys.tours.waFollowUp':
      'Hello MusaFly! I have just sent a booking request for this holiday package:',

  // ─────────── Umrah ───────────
  'journeys.umrah.eyebrow': 'Blessed journey',
  'journeys.umrah.title': 'Umrah packages,\narranged with care',
  'journeys.umrah.subtitle':
      'Saudi e-Visa, return flights, hotels near the Haram and guided Ziyarah.',
  'journeys.umrah.tier': 'Package type',
  'journeys.umrah.anyTier': 'All packages',
  'journeys.umrah.tierTitle': 'Choose a package type',
  'journeys.umrah.package': 'package',
  'journeys.umrah.packages': 'packages',
  'journeys.umrah.licensed': 'Hajj & Umrah licensed',
  'journeys.umrah.emptyTitle': 'No packages published',
  'journeys.umrah.emptyBody':
      'No Umrah packages are available right now. Pull down to refresh, or speak to an advisor.',
  'journeys.umrah.errorTitle': 'Could not load packages',
  'journeys.umrah.noMatchBody':
      'No packages match this selection. Try another package type or budget.',
  'journeys.umrah.perPilgrim': 'per pilgrim',
  'journeys.umrah.badge': 'Umrah special',
  'journeys.umrah.evisa': 'Saudi e-Visa',
  'journeys.umrah.flights': 'Return flights',
  'journeys.umrah.cities': 'Makkah & Madinah',
  'journeys.umrah.ziyarah': 'Guided Ziyarah',
  'journeys.umrah.glance': 'Package at a glance',
  'journeys.umrah.visa': 'Visa',
  'journeys.umrah.includedValue': 'Included',
  'journeys.umrah.flightsLabel': 'Flights',
  'journeys.umrah.returnValue': 'Return',
  'journeys.umrah.inclusions': 'Package inclusions',
  'journeys.umrah.inclusionsSub': 'Covered by the price shown below',
  'journeys.umrah.stay': 'Accommodation',
  'journeys.umrah.staySub': 'Where you stay in the two holy cities',
  'journeys.umrah.makkah': 'Makkah Al-Mukarramah',
  'journeys.umrah.makkahBody':
      'A hotel a short walk from Masjid Al-Haram, with shuttle service.',
  'journeys.umrah.madinah': 'Madinah Al-Munawwarah',
  'journeys.umrah.madinahBody':
      'Walking distance to Al-Masjid an-Nabawi, breakfast included.',
  'journeys.umrah.transport': 'Ground transport & Ziyarah',
  'journeys.umrah.transportBody':
      'Airport pick-up, inter-city transfer and guided Ziyarah tours.',
  'journeys.umrah.know': 'Good to know',
  'journeys.umrah.family': 'Family & group friendly',
  'journeys.umrah.familyBody':
      'Double, triple and quad sharing rooms can be arranged on request.',
  'journeys.umrah.advisor': 'Advisor on call',
  'journeys.umrah.advisorBody':
      'A dedicated Umrah advisor stays reachable throughout your journey.',
  'journeys.umrah.approved':
      'Operated by a Saudi Ministry-approved Umrah provider. Visa and ground service handled for you.',
  'journeys.umrah.book': 'Book Umrah',
  'journeys.umrah.pilgrims': 'Pilgrims & room type',
  'journeys.umrah.pilgrimsHint': 'e.g. 2 adults, double sharing',
  'journeys.umrah.submit': 'Submit booking request',
  'journeys.umrah.successTitle': 'Umrah request submitted',
  'journeys.umrah.successBody':
      'May Allah accept your intention. Our advisor will call you about visa and flight details.',
  'journeys.umrah.wa': 'Salam MusaFly! I am interested in this Umrah package:',
  'journeys.umrah.waShare': 'Have a look at this Umrah package on MusaFly:',
  'journeys.umrah.waFollowUp':
      'Salam MusaFly! I have just sent a booking request for this Umrah package:',

  // ─────────── Visa ───────────
  'journeys.visa.eyebrow': 'Visa services',
  'journeys.visa.title': 'Visas handled\nfrom form to stamp',
  'journeys.visa.subtitle':
      'Document checks, embassy submission and status updates, handled by our consultants.',
  'journeys.visa.country': 'Destination',
  'journeys.visa.anyCountry': 'Any country',
  'journeys.visa.countryTitle': 'Choose a country',
  'journeys.visa.type': 'Visa type',
  'journeys.visa.anyType': 'All types',
  'journeys.visa.typeTitle': 'Choose a visa type',
  'journeys.visa.destination': 'destination',
  'journeys.visa.destinations': 'destinations',
  'journeys.visa.expert': 'Expert document check',
  'journeys.visa.emptyTitle': 'No visa services yet',
  'journeys.visa.emptyBody':
      'No visa services are published right now. Pull down to refresh or check back soon.',
  'journeys.visa.errorTitle': 'Could not load visa services',
  'journeys.visa.noMatchBody':
      'No country matches this selection. Try another destination or visa type.',
  'journeys.visa.service': 'Visa service',
  'journeys.visa.fee': 'Total visa fee',
  'journeys.visa.perApplicant': 'per applicant',
  'journeys.visa.glance': 'At a glance',
  'journeys.visa.processing': 'Processing',
  'journeys.visa.submission': 'Submission',
  'journeys.visa.handled': 'Handled',
  'journeys.visa.docs': 'Required documents',
  'journeys.visa.docsSub': 'Keep these ready before you apply',
  'journeys.visa.how': 'How it works',
  'journeys.visa.howSub': 'Four steps from application to approval',
  'journeys.visa.step1': 'Apply online',
  'journeys.visa.step1Body':
      'Fill in the short form here, or send your details to us on WhatsApp.',
  'journeys.visa.step2': 'Document review',
  'journeys.visa.step2Body':
      'Our visa consultant checks every paper and prepares your file.',
  'journeys.visa.step3': 'Embassy submission',
  'journeys.visa.step3Body':
      'We submit directly to the embassy or the official online portal.',
  'journeys.visa.step4': 'Receive your visa',
  'journeys.visa.step4Body':
      'The approved visa reaches you by email and WhatsApp as soon as it is issued.',
  'journeys.visa.support':
      'Full document support, and we keep you updated at every stage of the application.',
  'journeys.visa.passport': 'Passport number',
  'journeys.visa.passportHint': 'e.g. A01234567',
  'journeys.visa.city': 'Current city / country',
  'journeys.visa.cityHint': 'e.g. Muscat, Oman',
  'journeys.visa.submit': 'Submit application',
  'journeys.visa.successTitle': 'Application submitted',
  'journeys.visa.successBody':
      'Our visa expert will contact you to collect the documents required for this application.',
  'journeys.visa.wa': 'Hello MusaFly! I need help with this visa:',
  'journeys.visa.waShare': 'Have a look at this visa service on MusaFly:',
  'journeys.visa.waFollowUp':
      'Hello MusaFly! I have just submitted an application for this visa:',
};

const Map<String, String> journeysBn = <String, String>{
  // ─────────── সাধারণ ───────────
  'journeys.all': 'সব',
  'journeys.anywhere': 'যেকোনো জায়গা',
  'journeys.budget': 'বাজেট',
  'journeys.anyBudget': 'যেকোনো বাজেট',
  'journeys.budgetTitle': 'বাজেট বেছে নিন',
  'journeys.upTo': 'সর্বোচ্চ',
  'journeys.andAbove': 'এর বেশি',
  'journeys.sort': 'সাজান',
  'journeys.sortRecommended': 'জনপ্রিয়',
  'journeys.sortPriceLow': 'কম দাম আগে',
  'journeys.sortPriceHigh': 'বেশি দাম আগে',
  'journeys.available': 'রয়েছে',
  'journeys.duration': 'সময়কাল',
  'journeys.searchPlaceholder': 'লিখে খুঁজুন…',
  'journeys.noMatch': 'কিছু পাওয়া যায়নি',
  'journeys.clearFilters': 'ফিল্টার মুছুন',
  'journeys.privacy': 'আপনার তথ্য শুধু এই অনুরোধ প্রস্তুত করতেই ব্যবহার করা হবে।',
  'journeys.fullName': 'পুরো নাম',
  'journeys.fullNameHint': 'পাসপোর্টে যেভাবে লেখা',
  'journeys.phone': 'ফোন নম্বর',
  'journeys.phoneHint': 'কান্ট্রি কোডসহ',
  'journeys.email': 'ইমেইল',
  'journeys.emailHint': 'name@domain.com',
  'journeys.required': 'অবশ্যই দিতে হবে',
  'journeys.chatAdvisor': 'পরামর্শকের সঙ্গে কথা বলুন',
  'journeys.whatsappHint': 'হোয়াটসঅ্যাপে কথা বলুন',
  'journeys.submitError': 'কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।',
  'journeys.step': 'ধাপ',

  // ─────────── ট্যুর ───────────
  'journeys.tours.eyebrow': 'হলিডে ও ট্যুর',
  'journeys.tours.title': 'বাছাই করা ভ্রমণ,\nশুরু থেকে শেষ পর্যন্ত',
  'journeys.tours.subtitle':
      'ফ্লাইট, হোটেল, ট্রান্সফার আর গাইডসহ ঘোরাঘুরি—সবকিছু মিলিয়ে বাছাই করা হলিডে প্যাকেজ।',
  'journeys.tours.destination': 'গন্তব্য',
  'journeys.tours.destinationTitle': 'গন্তব্য বেছে নিন',
  'journeys.tours.package': 'প্যাকেজ',
  'journeys.tours.packages': 'প্যাকেজ',
  'journeys.tours.bestPrice': 'সেরা দামের নিশ্চয়তা',
  'journeys.tours.emptyTitle': 'এখনও কোনো ট্যুর নেই',
  'journeys.tours.emptyBody':
      'এই মুহূর্তে কোনো হলিডে প্যাকেজ প্রকাশ করা হয়নি। নিচে টেনে রিফ্রেশ করুন বা পরে দেখুন।',
  'journeys.tours.errorTitle': 'ট্যুর লোড করা যায়নি',
  'journeys.tours.noMatchBody':
      'এই খোঁজার সঙ্গে কোনো প্যাকেজ মেলেনি। অন্য গন্তব্য বা বড় বাজেট বেছে দেখুন।',
  'journeys.tours.inclusionsFallback':
      'হোটেল, এয়ারপোর্ট ট্রান্সফার ও গাইডসহ ঘোরাঘুরি অন্তর্ভুক্ত।',
  'journeys.tours.verified': 'যাচাই করা অপারেটর · ফ্রি বাতিল',
  'journeys.tours.glance': 'এক নজরে ভ্রমণ',
  'journeys.tours.stay': 'থাকা',
  'journeys.tours.stayValue': '৪★ হোটেল',
  'journeys.tours.transfers': 'ট্রান্সফার',
  'journeys.tours.transfersValue': 'প্রাইভেট',
  'journeys.tours.included': 'যা যা থাকছে',
  'journeys.tours.includedSub': 'প্যাকেজের দামেই সবকিছু অন্তর্ভুক্ত',
  'journeys.tours.why': 'কেন মুসাফ্লাই থেকে বুক করবেন',
  'journeys.tours.why1': 'প্রিমিয়াম হোটেল',
  'journeys.tours.why1Body':
      'শহরের কেন্দ্রে বাছাই করা ৪ তারকা ও বিলাসবহুল হোটেল।',
  'journeys.tours.why2': 'এয়ারপোর্ট ও সাইটসিয়িং ট্রান্সফার',
  'journeys.tours.why2Body':
      'ইংরেজি জানা চালকসহ প্রাইভেট শীতাতপ নিয়ন্ত্রিত গাড়ি।',
  'journeys.tours.why3': '২৪/৭ সহায়তা',
  'journeys.tours.why3Body': 'গন্তব্যে যেকোনো সময় পাশে থাকার ব্যবস্থা।',
  'journeys.tours.taxNote': 'সব কর ও সার্ভিস চার্জ এই দামেই অন্তর্ভুক্ত।',
  'journeys.tours.book': 'প্যাকেজ বুক করুন',
  'journeys.tours.guests': 'অতিথি ও বিশেষ অনুরোধ',
  'journeys.tours.guestsHint': 'যেমন ২ জন বড়, ১ জন শিশু',
  'journeys.tours.submit': 'বুকিং অনুরোধ পাঠান',
  'journeys.tours.successTitle': 'ট্যুরের অনুরোধ পেয়েছি',
  'journeys.tours.successBody':
      'আমাদের হলিডে প্ল্যানার শিগগিরই যোগাযোগ করে আপনার মতো করে ভ্রমণ সাজিয়ে দেবেন।',
  'journeys.tours.wa': 'হ্যালো মুসাফ্লাই! আমি এই হলিডে প্যাকেজটিতে আগ্রহী:',
  'journeys.tours.waShare': 'মুসাফ্লাইয়ের এই হলিডে প্যাকেজটি দেখুন:',
  'journeys.tours.waFollowUp':
      'হ্যালো মুসাফ্লাই! আমি এই হলিডে প্যাকেজের জন্য বুকিং অনুরোধ পাঠিয়েছি:',

  // ─────────── উমরাহ ───────────
  'journeys.umrah.eyebrow': 'বরকতময় সফর',
  'journeys.umrah.title': 'উমরাহ প্যাকেজ,\nযত্ন নিয়ে সাজানো',
  'journeys.umrah.subtitle':
      'সৌদি ই-ভিসা, রিটার্ন ফ্লাইট, হারামের কাছাকাছি হোটেল আর গাইডসহ জিয়ারাহ।',
  'journeys.umrah.tier': 'প্যাকেজের ধরন',
  'journeys.umrah.anyTier': 'সব প্যাকেজ',
  'journeys.umrah.tierTitle': 'প্যাকেজের ধরন বেছে নিন',
  'journeys.umrah.package': 'প্যাকেজ',
  'journeys.umrah.packages': 'প্যাকেজ',
  'journeys.umrah.licensed': 'হজ ও উমরাহ লাইসেন্সপ্রাপ্ত',
  'journeys.umrah.emptyTitle': 'কোনো প্যাকেজ প্রকাশিত হয়নি',
  'journeys.umrah.emptyBody':
      'এই মুহূর্তে কোনো উমরাহ প্যাকেজ নেই। নিচে টেনে রিফ্রেশ করুন বা পরামর্শকের সঙ্গে কথা বলুন।',
  'journeys.umrah.errorTitle': 'প্যাকেজ লোড করা যায়নি',
  'journeys.umrah.noMatchBody':
      'এই বাছাইয়ের সঙ্গে কোনো প্যাকেজ মেলেনি। অন্য ধরন বা বাজেট দেখুন।',
  'journeys.umrah.perPilgrim': 'জনপ্রতি',
  'journeys.umrah.badge': 'উমরাহ স্পেশাল',
  'journeys.umrah.evisa': 'সৌদি ই-ভিসা',
  'journeys.umrah.flights': 'রিটার্ন ফ্লাইট',
  'journeys.umrah.cities': 'মক্কা ও মদিনা',
  'journeys.umrah.ziyarah': 'গাইডসহ জিয়ারাহ',
  'journeys.umrah.glance': 'এক নজরে প্যাকেজ',
  'journeys.umrah.visa': 'ভিসা',
  'journeys.umrah.includedValue': 'অন্তর্ভুক্ত',
  'journeys.umrah.flightsLabel': 'ফ্লাইট',
  'journeys.umrah.returnValue': 'যাওয়া-আসা',
  'journeys.umrah.inclusions': 'প্যাকেজে যা থাকছে',
  'journeys.umrah.inclusionsSub': 'নিচের দামেই সবকিছু অন্তর্ভুক্ত',
  'journeys.umrah.stay': 'থাকার ব্যবস্থা',
  'journeys.umrah.staySub': 'দুই পবিত্র শহরে যেখানে থাকবেন',
  'journeys.umrah.makkah': 'মক্কা আল-মুকাররমা',
  'journeys.umrah.makkahBody':
      'মসজিদুল হারাম থেকে অল্প হাঁটা দূরত্বে হোটেল, শাটল সার্ভিসসহ।',
  'journeys.umrah.madinah': 'মদিনা আল-মুনাওয়ারা',
  'journeys.umrah.madinahBody':
      'মসজিদে নববীর হাঁটা দূরত্বে হোটেল, সকালের নাশতাসহ।',
  'journeys.umrah.transport': 'যাতায়াত ও জিয়ারাহ',
  'journeys.umrah.transportBody':
      'এয়ারপোর্ট থেকে নেওয়া, শহরের মাঝে যাতায়াত ও গাইডসহ জিয়ারাহ।',
  'journeys.umrah.know': 'জেনে রাখুন',
  'journeys.umrah.family': 'পরিবার ও দলের জন্য',
  'journeys.umrah.familyBody':
      'অনুরোধে ডাবল, ট্রিপল ও কোয়াড শেয়ারিং রুমের ব্যবস্থা করা যায়।',
  'journeys.umrah.advisor': 'পরামর্শক সবসময় পাশে',
  'journeys.umrah.advisorBody':
      'পুরো সফরজুড়ে একজন নির্দিষ্ট উমরাহ পরামর্শককে পাবেন।',
  'journeys.umrah.approved':
      'সৌদি মন্ত্রণালয় অনুমোদিত উমরাহ প্রতিষ্ঠানের পরিচালনায়। ভিসা ও স্থানীয় সেবা আমরাই দেখি।',
  'journeys.umrah.book': 'উমরাহ বুক করুন',
  'journeys.umrah.pilgrims': 'যাত্রী ও রুমের ধরন',
  'journeys.umrah.pilgrimsHint': 'যেমন ২ জন, ডাবল শেয়ারিং',
  'journeys.umrah.submit': 'বুকিং অনুরোধ পাঠান',
  'journeys.umrah.successTitle': 'উমরাহ অনুরোধ জমা হয়েছে',
  'journeys.umrah.successBody':
      'আল্লাহ আপনার নিয়ত কবুল করুন। ভিসা ও ফ্লাইটের বিষয়ে আমাদের পরামর্শক কল করবেন।',
  'journeys.umrah.wa': 'সালাম মুসাফ্লাই! আমি এই উমরাহ প্যাকেজটিতে আগ্রহী:',
  'journeys.umrah.waShare': 'মুসাফ্লাইয়ের এই উমরাহ প্যাকেজটি দেখুন:',
  'journeys.umrah.waFollowUp':
      'সালাম মুসাফ্লাই! আমি এই উমরাহ প্যাকেজের জন্য বুকিং অনুরোধ পাঠিয়েছি:',

  // ─────────── ভিসা ───────────
  'journeys.visa.eyebrow': 'ভিসা সেবা',
  'journeys.visa.title': 'ভিসার সবকিছু\nআমরাই দেখি',
  'journeys.visa.subtitle':
      'কাগজপত্র যাচাই, দূতাবাসে জমা আর অবস্থার আপডেট—সবই আমাদের পরামর্শকেরা সামলান।',
  'journeys.visa.country': 'গন্তব্য',
  'journeys.visa.anyCountry': 'যেকোনো দেশ',
  'journeys.visa.countryTitle': 'দেশ বেছে নিন',
  'journeys.visa.type': 'ভিসার ধরন',
  'journeys.visa.anyType': 'সব ধরন',
  'journeys.visa.typeTitle': 'ভিসার ধরন বেছে নিন',
  'journeys.visa.destination': 'গন্তব্য',
  'journeys.visa.destinations': 'গন্তব্য',
  'journeys.visa.expert': 'বিশেষজ্ঞের কাগজ যাচাই',
  'journeys.visa.emptyTitle': 'এখনও কোনো ভিসা সেবা নেই',
  'journeys.visa.emptyBody':
      'এই মুহূর্তে কোনো ভিসা সেবা প্রকাশ করা হয়নি। নিচে টেনে রিফ্রেশ করুন বা পরে দেখুন।',
  'journeys.visa.errorTitle': 'ভিসা সেবা লোড করা যায়নি',
  'journeys.visa.noMatchBody':
      'এই বাছাইয়ের সঙ্গে কোনো দেশ মেলেনি। অন্য গন্তব্য বা ভিসার ধরন দেখুন।',
  'journeys.visa.service': 'ভিসা সেবা',
  'journeys.visa.fee': 'মোট ভিসা ফি',
  'journeys.visa.perApplicant': 'প্রতি আবেদনকারী',
  'journeys.visa.glance': 'এক নজরে',
  'journeys.visa.processing': 'প্রসেসিং',
  'journeys.visa.submission': 'জমা দেওয়া',
  'journeys.visa.handled': 'আমরাই করি',
  'journeys.visa.docs': 'প্রয়োজনীয় কাগজপত্র',
  'journeys.visa.docsSub': 'আবেদনের আগে এগুলো হাতে রাখুন',
  'journeys.visa.how': 'যেভাবে কাজ হয়',
  'journeys.visa.howSub': 'আবেদন থেকে অনুমোদন—চারটি ধাপ',
  'journeys.visa.step1': 'অনলাইনে আবেদন',
  'journeys.visa.step1Body':
      'এখানেই ছোট ফর্মটি পূরণ করুন, অথবা হোয়াটসঅ্যাপে তথ্য পাঠান।',
  'journeys.visa.step2': 'কাগজপত্র যাচাই',
  'journeys.visa.step2Body':
      'আমাদের ভিসা পরামর্শক প্রতিটি কাগজ দেখে ফাইল তৈরি করেন।',
  'journeys.visa.step3': 'দূতাবাসে জমা',
  'journeys.visa.step3Body': 'আমরা সরাসরি দূতাবাসে বা সরকারি পোর্টালে জমা দিই।',
  'journeys.visa.step4': 'ভিসা হাতে পাওয়া',
  'journeys.visa.step4Body':
      'ভিসা অনুমোদন হওয়ামাত্র ইমেইল ও হোয়াটসঅ্যাপে পৌঁছে যাবে।',
  'journeys.visa.support':
      'পুরো কাগজপত্রে সহায়তা, আর আবেদনের প্রতিটি ধাপে আপডেট।',
  'journeys.visa.passport': 'পাসপোর্ট নম্বর',
  'journeys.visa.passportHint': 'যেমন A01234567',
  'journeys.visa.city': 'এখন যে শহর / দেশে আছেন',
  'journeys.visa.cityHint': 'যেমন মাস্কাট, ওমান',
  'journeys.visa.submit': 'আবেদন জমা দিন',
  'journeys.visa.successTitle': 'আবেদন জমা হয়েছে',
  'journeys.visa.successBody':
      'প্রয়োজনীয় কাগজপত্র নিতে আমাদের ভিসা বিশেষজ্ঞ আপনার সঙ্গে যোগাযোগ করবেন।',
  'journeys.visa.wa': 'হ্যালো মুসাফ্লাই! এই ভিসার ব্যাপারে সহায়তা দরকার:',
  'journeys.visa.waShare': 'মুসাফ্লাইয়ের এই ভিসা সেবাটি দেখুন:',
  'journeys.visa.waFollowUp':
      'হ্যালো মুসাফ্লাই! আমি এই ভিসার জন্য আবেদন জমা দিয়েছি:',
};
