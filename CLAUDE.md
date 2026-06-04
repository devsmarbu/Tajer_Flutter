# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Tajer** is a production e-commerce buyer app (Flutter) for the tajershops.com platform. Package name: `com.tajershops.tajer`. The app supports RTL languages (Arabic, Urdu, Farsi, Hebrew), multi-currency, and multi-country operations.

## Build & Run Commands

```bash
# Install dependencies
flutter pub get

# Run in debug mode
flutter run

# Build APK (release)
flutter build apk --release

# Build iOS (release)
flutter build ios --release

# Analyze code
flutter analyze

# Run tests
flutter test

# Generate launcher icons
flutter pub run flutter_launcher_icons
```

**Dart SDK:** ^3.9.2  
**No build flavors** configured — environment is toggled via `AppConfig.env` in `lib/main.dart` line 72.

## Environment Configuration

Environments are set in `lib/app/core/constants/app_constants.dart`:
- **Production:** `https://tajershops.com/app-api/3.1/`
- **Development:** `https://beta.tajershops.com/app-api/3.1/`

Switch by changing `AppConfig.env = AppEnvironment.PRODUCTION` in `main.dart`.

## Architecture

**State Management:** GetX (`get: ^4.6.6`) — controllers use `.obs` reactive variables, `Obx()` widgets, and `Get.lazyPut()`/`Get.put()` for DI.

**Module Structure:** Each feature follows this pattern:
```
lib/app/modules/<feature>/
├── view/          # UI screens + GetX Bindings
├── controller/    # GetxController with API client mixins
└── models/        # Data classes
```

**Key Layers:**
- `lib/app/modules/` — 34 feature modules (home, cart, orders, authentication, etc.)
- `lib/app/data/service/` — 27 API client files as mixins, mixed into controllers
- `lib/app/data/respository/` — 10 repository files for data access
- `lib/app/data/service/api_service/api_service.dart` — Centralized Dio config with interceptors
- `lib/app/core/routes/app_routes.dart` — 51 named routes with `GetPage` definitions
- `lib/common/widgets/` — Shared UI components (text fields, dropdowns, loaders)
- `lib/utils/` — App-wide utilities (colors, preferences, loader, base response)
- `lib/translations/localization_service.dart` — Dynamic JSON-based translations with RTL support

**Permanent Controllers** (registered in `main.dart`, available app-wide):
- `LocalizationService` — language/locale
- `AccountController` — user profile, membership
- `SplashController` — initial data load, auth check
- `BottomNavController` — tab navigation state

## API Integration Pattern

Controllers use **mixin composition** with API clients:
```dart
class SomeController extends GetxController with SomeApiClient, AppLoader { ... }
```

API clients call Dio through `ApiService`. The interceptor automatically:
- Attaches headers: `X-TOKEN`, `X-LANGUAGE-ID`, `X-YK-COUNTRY-CODE`, `X-CURRENCY-ID`, `Cookie` (PHPSESSID)
- Checks internet connectivity before requests via `NetworkChecker`
- Detects session expiry (`displayLoginForm == 1`) and redirects to login

## Routing

All routes defined in `lib/app/core/routes/app_routes.dart`. Navigation uses:
- `Get.toNamed(AppRoutes.someRoute, parameters: {...})`
- Helper methods like `AppRoutes.goToProductListPage()`
- Deep linking via `DeepLinkService` in `lib/main_extension.dart`

## Localization

- RTL auto-detected for language codes: `ar`, `ur`, `fa`, `he`
- Translation files are JSON, loaded dynamically from device storage
- Locale set via `LocalizationService` which extends `GetxService` and `Translations`

## Third-Party Services

- **Push Notifications:** OneSignal + Firebase Cloud Messaging + flutter_local_notifications
- **Analytics:** Firebase Analytics, Facebook App Events, TikTok Events SDK
- **Auth:** Google Sign-In, Apple Sign-In, Firebase Auth
- **Media:** media_kit for video playback
- **Deep Links:** app_links package

## Key Conventions

- API client files are **mixins**, not standalone classes
- `PrefStore` (in `lib/utils/pref_store.dart`) wraps SharedPreferences — use it for all persistent key-value storage
- `AppLoader` mixin provides loading state management for controllers
- `BaseResponse` in `lib/utils/base_response.dart` is the generic API response wrapper
- Font family is **Nunito** (weights 300-800)
- `AppConstants` preference keys follow camelCase naming
- The `respository` directory is intentionally misspelled (not `repository`) — do not rename without a coordinated refactor

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
