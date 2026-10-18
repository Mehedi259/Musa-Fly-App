# MusaFly Mobile App (Flutter)

A modern, high-performance, enterprise-grade travel application for **MusaFly** built with Flutter, Clean Architecture, and full REST API integration.

---

## 🌟 Key Features

1. **Flight Search & Ticketing**:
   - One-way and Round-trip ticket search.
   - Airport selector with top hub airports (Dhaka DAC, Dubai DXB, Muscat MCT, Jeddah JED, Chittagong CGP, Cox's Bazar CXB, Singapore SIN, London LHR, etc.).
   - Date picker, passenger counter, and travel class selector (Economy, Business, First Class).
   - Live synchronization with MusaFly backend API (`/api/flights/`).
   - One-tap booking modal syncing with `/api/deals/` and direct WhatsApp confirmation.

2. **Holiday & Tour Packages**:
   - Handpicked international & domestic tour packages.
   - Real-time pricing, duration, inclusions breakdown, and 24/7 concierge support.
   - Live backend integration (`/api/tours/`).

3. **Umrah & Hajj Pilgrimage**:
   - Comprehensive Umrah packages (Economy, Premium, VIP).
   - Details on Makkah (Al Kiswah, Swissotel, Fairmont) and Madinah (Jewar Al Saqefah, Pullman Zamzam, Oberoi) accommodations.
   - Visa, flights, and ziyarah inclusions.
   - Direct booking inquiry and spiritual guidance on WhatsApp.
   - Live backend integration (`/api/umrah/`).

4. **Visa Processing & Assistance**:
   - Real-time visa requirements checklist (e.g. Malaysia, Oman, Singapore, Dubai).
   - Step-by-step application workflow tracker.
   - Direct document submission and status monitoring.
   - Live backend integration (`/api/visas/`).

5. **Customer Deals & Inquiries**:
   - Centralized deal tracker synced with backend (`/api/deals/` & `/api/customers/`).
   - Custom inquiry generator directly creating leads into the database.

6. **Customer Care & Support**:
   - Instant WhatsApp Concierge (`+968 95923226`).
   - Direct phone dialer and email support.
   - Categorized FAQs (`/api/faqs/`).
   - Verified client reviews & testimonials (`/api/testimonials/`).

---

## 🏛️ Architecture & Folder Structure

Built adhering to **Clean Architecture** principles:

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart      # Live API base URL & endpoints
│   │   ├── app_colors.dart         # Royal Navy (#204D90), Gold (#E6AB35)
│   │   ├── app_assets.dart         # Local & network assets
│   │   ├── app_strings.dart        # Contact & brand strings
│   │   └── app_theme.dart          # GoogleFonts (Outfit & Plus Jakarta Sans)
│   ├── network/
│   │   ├── api_client.dart         # Robust HTTP client with error handling
│   │   └── api_exceptions.dart     # Custom exception types
│   ├── utils/
│   │   ├── currency_formatter.dart # BDT, USD, OMR formatters
│   │   ├── date_formatter.dart     # Flight & travel date parsers
│   │   └── url_helper.dart         # WhatsApp, phone, email launcher
│   └── widgets/
│       ├── custom_button.dart      # Reusable modern buttons
│       ├── custom_text_field.dart  # Form input fields
│       ├── shimmer_loader.dart     # Skeleton loaders
│       ├── empty_state_view.dart   # Empty list states
│       ├── error_state_view.dart   # Network error with retry
│       ├── section_title.dart      # Section headers
│       └── app_network_image.dart  # Cached network image with fallback
├── features/
│   ├── navigation/                 # BottomNavigationBar & IndexedStack
│   ├── home/                       # Master landing & discovery screen
│   ├── flights/                    # Flight search, results, booking
│   ├── tours/                      # Tour packages & detailed itineraries
│   ├── umrah/                      # Umrah pilgrimage packages
│   ├── visas/                      # Visa services & document checklist
│   ├── deals/                      # Booking inquiries & backend sync
│   └── support/                    # FAQs, Testimonials & Contact
└── main.dart                       # MultiProvider & App entry
```

---

## 🚀 Running the App

```bash
# 1. Get dependencies
flutter pub get

# 2. Run code analyzer (0 errors, 0 warnings)
flutter analyze

# 3. Run test suite
flutter test

# 4. Run on connected device or simulator
flutter run
```

---

## 🔗 Connected Backend

- **Base URL**: `http://46.225.103.236:8001/api/`
- **Supported Endpoints**:
  - `GET /flights/`, `POST /flights/`
  - `GET /tours/`, `POST /tours/`
  - `GET /umrah/`, `POST /umrah/`
  - `GET /visas/`, `POST /visas/`
  - `GET /deals/`, `POST /deals/`
  - `GET /customers/`, `POST /customers/`
  - `GET /faqs/`
  - `GET /testimonials/`
  - `GET /dashboard/stats/`
