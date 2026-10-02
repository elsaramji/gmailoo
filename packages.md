# Gmailoo: Packages and Services Specification

**Project:** Gmailoo (Ephemeral, Stress-Free Email Client)  
**Target Platforms:** Flutter (iOS & Android)  
**Architecture:** Clean Architecture (Domain, Data, Presentation) & SOLID Principles  
**References:**
- PRD: [Gmailoo_PRD_v0.1.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/Gmailoo_PRD_v0.1.md)
- Implementation Plan: [agent-implementation-plan.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/agent-implementation-plan.md)
- Database Schema: [database-schema.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/database-schema.md)
- UI Specification: [ui-design-spec.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/ui-design-spec.md)
- Design System: [colors.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/colors.md) & [typography.md](file:///d:/mobile%20development%20%20advance/gmailoo/docs/typography.md)

---

## 1. Executive Summary

Based on an exhaustive review of all documentation and specifications in `docs/`, **Gmailoo** is a privacy-first, ephemeral mobile email client designed for Gen Z and Gen Alpha. It limits the inbox strictly to the current week's emails (Saturday 00:00:00 to Thursday 23:59:59 in the user's timezone, defaulting to `Africa/Cairo`), executes a complete local wipe every Friday ("Zen Day"), categorizes incoming emails into 5 smart buckets on-device, and only interrupts the user with notifications for VIP senders or Important Unread mail.

To implement this application in strict adherence to Clean Architecture and SOLID principles, the required packages and services are categorized below.

---

## 2. Production Dependencies (`dependencies`)

### 2.1 Architecture, State Management & DI
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `flutter_bloc` | `^8.1.6` | **Presentation Layer:** Manages reactive state across screens (Inbox, Auth, Timetables, VIPs, Settings, Compose) using BLoCs and Cubits. |
| `get_it` | `^7.7.0` | **Core / DI Layer:** Inversion-of-Control service locator for dependency injection. |
| `injectable` | `^2.4.4` | **Core / DI Layer:** Code-generation annotations for registering Repositories, DataSources, UseCases, and Blocs. |
| `equatable` | `^2.0.5` | **Domain & Presentation:** Value equality for entities, events, states, and value objects without boilerplate. |
| `fpdart` | `^1.1.0` | **Domain & Data:** Functional programming constructs (`Either<Failure, T>`, `Option`) ensuring type-safe failure handling without uncaught runtime exceptions. |

### 2.2 Navigation & Routing
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `go_router` | `^14.2.0` | **App / Presentation:** Declarative URL-driven routing supporting deep links (`Open in Gmail`), authentication redirection guards, and `StatefulShellRoute.indexedStack` for bottom navigation tabs. |

### 2.3 Local Persistence & Secure Storage (Data Layer)
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `drift` | `^2.20.0` | **Data Layer:** Reactive, type-safe persistence engine managing two distinct SQLite database files: `gmailoo_core.sqlite` (persistent) and `gmailoo_cycle.sqlite` (ephemeral). |
| `sqlcipher_flutter_libs` | `^0.5.24` | **Data Layer:** Native SQLCipher encrypted SQLite binaries enabling 256-bit AES encryption at rest for both local databases. |
| `sqlite3` | `^2.4.5` | **Data Layer:** Low-level SQLite C-bindings required by Drift NativeDatabase. |
| `flutter_secure_storage` | `^9.2.2` | **Core / Security:** Hardware-backed keychain/keystore storage for the SQLCipher 256-bit encryption key and Google OAuth refresh/access tokens. Prevents leakage to SQLite, logs, or cloud backups. |
| `path_provider` | `^2.1.4` | **Data Layer:** Resolves OS-specific paths: Application Support Directory (for encrypted DBs and outbox files) and Cache Directory (for ephemeral attachments wiped on Friday). |
| `path` | `^1.9.0` | **Core / Data:** Filesystem path operations and URI resolution across platforms. |

### 2.4 Google Sign-In & Gmail REST API Integration
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `firebase_core` | `^3.6.0` | **Core:** Initializes Firebase services across iOS and Android. |
| `firebase_auth` | `^5.3.1` | **Data / Auth:** Handles user authentication identity via Google OAuth credentials. |
| `google_sign_in` | `^6.2.1` | **Data / Auth:** Native Google Sign-In SDK requesting incremental OAuth scopes (`gmail.modify` and `gmail.send`). |
| `googleapis` | `^13.2.0` | **Data / Network:** Official Google client library providing typed access to Gmail API v1 endpoints (`users.messages`, `users.history`, `users.watch`). |
| `extension_google_sign_in_as_googleapis_auth` | `^2.0.12` | **Data / Network:** Authenticates Google APIs requests using active `GoogleSignIn` credentials without manually refreshing tokens. |
| `http` | `^1.2.2` | **Data / Network:** Authenticated HTTP client handling attachment downloads, exponential backoff, and jitter on HTTP 429/5xx errors. |

### 2.5 Push Notifications & Background Scheduling
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `firebase_messaging` | `^15.1.3` | **Data / Notifications:** Receives silent, data-only FCM push payloads (`{type: "sync", historyId}`) and watch-renewal nudges (`{type: "renew_watch"}`). |
| `flutter_local_notifications` | `^17.2.2` | **Presentation / Notifications:** Displays notification banners with localized subtitles ("VIP" / "Important") only when an email passes the Zen Notification policy. |
| `workmanager` | `^0.5.2` | **Data / Background:** Background task runner for Android to execute scheduled email sends, periodic Gmail watch renewals, and weekly wipe validation. |

### 2.6 Time, Timezones & Localization (i18n / l10n)
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `timezone` | `^0.9.4` | **Domain & Core:** Complete IANA timezone database calculations ensuring cycle bounds (Sat 00:00:00 to Thu 23:59:59) and quiet hours remain accurate across Daylight Saving Time (DST) shifts in Egypt (`Africa/Cairo`). |
| `flutter_timezone` | `^3.0.1` | **Core / Time:** Detects device's current native IANA timezone identifier at startup. |
| `intl` | `^0.19.0` | **Presentation & Core:** Date, time, and number formatting for Arabic (`ar-EG`) and English (`en-US`), including locale-aware Western vs. Arabic-Indic digit toggles. |
| `flutter_localizations` | `sdk: flutter` | **Presentation:** Built-in Flutter localization delegates for Material, Cupertino, and Widgets. |

### 2.7 Content Rendering, MIME Handling & Utilities
| Package | Version | Purpose & Layer Placement |
|---|---|---|
| `webview_flutter` | `^4.9.0` | **Presentation:** Sandboxed HTML email body rendering with **JavaScript disabled**, remote images blocked by default, and strict Content Security Policy (CSP). |
| `html` | `^0.15.4` | **Data / Sanitization:** Parses and sanitizes HTML email bodies, stripping `<script>`, `<iframe>`, and inline event handlers before rendering. |
| `crypto` | `^3.0.5` | **Core / Security:** Computes SHA-256 hashes of email addresses for backend device registration without exposing plaintext email addresses. |
| `uuid` | `^4.5.1` | **Domain & Data:** Generates UUID v4 identifiers for local outbox rows, drafts, and scheduled messages. |
| `mime` | `^1.0.6` | **Data / Compose:** MIME type lookup and boundary generation for RFC 5322 multipart message assembly. |
| `url_launcher` | `^6.3.0` | **Presentation:** Launches external deep links, including the "Open in Gmail" fallback action. |
| `cupertino_icons` | `^1.0.8` | **Presentation:** iOS-styled glyphs complementary to Material Symbols. |

---

## 3. Development & Testing Dependencies (`dev_dependencies`)

| Package | Version | Purpose |
|---|---|---|
| `flutter_lints` | `^6.0.0` | Enforces idiomatic Flutter and Dart styling rules. |
| `build_runner` | `^2.4.12` | Code generation build orchestration. |
| `drift_dev` | `^2.20.0` | Code generator for Drift tables, queries, DAOs, and schema dump validations. |
| `injectable_generator` | `^2.6.1` | Generates service locator registrations for `get_it`. |
| `flutter_test` | `sdk: flutter` | Unit and widget test framework. |
| `bloc_test` | `^9.1.7` | Standard testing suite for Cubits and BLoCs. |
| `mocktail` | `^1.0.4` | Type-safe mocking for data sources and repositories without code generation. |
| `golden_toolkit` | `^0.15.0` | Golden snapshot testing across LTR (`en-US`), RTL (`ar-EG`), Light, and Dark themes. |
| `integration_test` | `sdk: flutter` | End-to-end device integration testing (wipes, authentication cycles). |

---

## 4. Required External Cloud & Platform Services

### 4.1 Google Cloud Platform (GCP)
1. **Google Cloud Project & OAuth 2.0 Client IDs:**
   - Android Client ID (configured with package name and SHA-1/SHA-256 signing fingerprints).
   - iOS Client ID (configured with bundle identifier).
   - OAuth 2.0 Consent Screen configured with restricted scopes:
     - `https://www.googleapis.com/auth/gmail.modify` (Read and mark read/unread).
     - `https://www.googleapis.com/auth/gmail.send` (Send and schedule emails).
   - CASA Tier 2 Cloud Application Security Assessment (required for restricted scopes before exceeding 100 test users).
2. **Gmail API v1:**
   - Enabled in GCP Console.
   - Endpoint quotas configured for batch requests (max 50 IDs per batch).
3. **Google Cloud Pub/Sub:**
   - Dedicated Pub/Sub topic created for Gmail push notifications (`users.watch`).
   - IAM Permission: Grant `gmail-api-push@system.gserviceaccount.com` the role **Pub/Sub Publisher**.

### 4.2 Firebase Ecosystem
1. **Firebase Authentication:**
   - Google Sign-In Provider enabled.
   - Linking Google ID tokens with Firebase Auth User credentials.
2. **Cloud Firestore (Push Routing Directory):**
   - Collections: `users/{uid}` and `users/{uid}/devices/{deviceId}`.
   - Stores: SHA-256 `emailHash`, FCM token, platform, `watchExpiresAt`, and 60-day TTL `expireAt`.
   - Security Rules: Strictly disallow direct client writes (writes permitted exclusively via Admin SDK in Cloud Functions).
3. **Firebase Cloud Messaging (FCM):**
   - High-priority data-only messages for Android background wakeup.
   - APNs bridge configuration for iOS background notification payloads (`content-available: 1`).
4. **Firebase Cloud Functions (2nd Gen, TypeScript):**
   - `onGmailPush`: Triggered by Pub/Sub topic; hashes incoming email address, queries Firestore for registered devices, and dispatches data-only FCM push.
   - `registerDevice`: HTTPS Callable function verifying Auth token and securely recording FCM token with hashed email.
   - `unregisterDevice`: HTTPS Callable function deleting device tokens upon user sign-out.
   - `renewNudge`: Scheduled cron function sending silent wake-up pushes to devices whose Gmail watch expires within 24 hours.

### 4.3 Apple Developer & APNs
1. **APNs Authentication Key (.p8):** Generated in Apple Developer portal and uploaded to Firebase Project Settings.
2. **App Capabilities:**
   - Push Notifications.
   - Background Modes: **Remote notifications**, **Background fetch**, and **Background processing**.

---

## 5. Required Internal Clean Architecture Services & Abstractions

To enforce strict layer separation (Domain pure Dart, Data handling integrations, Presentation rendering UI), the following services and interfaces must be implemented:

```
Domain Layer (Pure Dart - Abstractions & UseCases)
       ▲
       │ implements / depends on
Data Layer (DataSources, Drift, Firebase, Gmail API)
       ▲
       │ consumes via UseCases
Presentation Layer (BLoCs, Cubits, Screens, Widgets)
```

### 5.1 Domain Layer Interfaces (Pure Dart)
- **`CycleClock`**: Timezone-aware domain interface calculating active weekly windows, cycle IDs (`YYYY-MM-DD`), and Friday Zen Day detection.
- **`Clock`**: Abstract clock provider enabling deterministic time injection and unit testing without `DateTime.now()`.
- **`MailReader`**: Interface for paginating messages, fetching threads, and reading headers.
- **`MailSender`**: Interface for sending immediate messages and dispatching drafts.
- **`MailScheduler`**: Interface for scheduling messages, cancelling queued items, and checking due sends.
- **`CycleRepository`**: Interface for cycle transition state, wipe triggering, and cycle metadata retrieval.
- **`VipRepository`**: Interface for managing VIP contacts, mute states, and virtual VIP folder streams.
- **`SettingsRepository`**: Interface for managing appearance, locale, quiet hours, and notification preferences.
- **`ClassificationRule`**: Open/Closed pluggable interface for message categorization rules (`MarketingRule`, `TimetableRule`, `ImportantRule`, `OtherRule`).
- **`NotificationPolicy`**: Evaluates whether a new email qualifies for an audible/visual notification.

### 5.2 Data Layer Services & Data Sources
- **`GmailRemoteDataSource`**: Wraps the Google Gmail API; implements message batching (≤ 50), exponential backoff with jitter, RFC 2047 MIME parsing, and history pagination.
- **`AuthRemoteDataSource`**: Coordinates Google Sign-In authentication, credential exchange with Firebase Auth, and token storage.
- **`SecureStorageService`**: Manages secure read/write operations for encryption keys and OAuth tokens via `flutter_secure_storage`.
- **`CoreDatabase` (Drift)**: Persistent database managing tables:
  - `session`
  - `app_settings`
  - `vip_senders`
  - `sender_overrides`
  - `outbox_messages`
  - `outbox_attachments`
  - `pending_gmail_ops`
  - `cycle_log`
- **`CycleDatabase` (Drift)**: Ephemeral database managing tables:
  - `cycle_meta`
  - `messages`
  - `message_bodies`
  - `attachments`
  - `notification_log`
- **`CycleDatabaseFactory`**: Handles the physical creation, encryption key application, and atomic deletion of the cycle database file and attachment directories during the Friday wipe.
- **`SyncEngine`**: Orchestrates initial window sync (`messages.list`), incremental sync (`history.list`), 404 recovery resyncs, and background queue flushing.
- **`MimeBuilderService`**: Constructs RFC 5322 compliant messages with UTF-8 base64url encoded subjects for transmission.
- **`LocalNotificationService`**: Wraps `flutter_local_notifications` for presenting classified notifications with Android channel grouping.

---

## 6. Assets & System Resources

1. **Custom Typography (Bundled locally to prevent runtime requests):**
   - `assets/fonts/Cairo-SemiBold.ttf` (Weight: 600)
   - `assets/fonts/Cairo-Bold.ttf` (Weight: 700)
   - `assets/fonts/IBMPlexSansArabic-Regular.ttf` (Weight: 400)
   - `assets/fonts/IBMPlexSansArabic-Medium.ttf` (Weight: 500)
   - `assets/fonts/IBMPlexSansArabic-SemiBold.ttf` (Weight: 600)
   - Font license files: `assets/fonts/OFL.txt`
2. **Localization ARB Files:**
   - `lib/l10n/app_ar.arb` (Arabic - Egypt, RTL)
   - `lib/l10n/app_en.arb` (English - US, LTR)
   - Config file: `l10n.yaml`

---

## 7. Recommended `pubspec.yaml` Specification

Below is the complete configuration to be updated in [pubspec.yaml](file:///d:/mobile%20development%20%20advance/gmailoo/pubspec.yaml):

```yaml
name: gmailoo
description: "An ephemeral, stress-free email client for Gen Z and Gen Alpha."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: '>=3.19.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Architecture, State Management & DI
  flutter_bloc: ^8.1.6
  get_it: ^7.7.0
  injectable: ^2.4.4
  equatable: ^2.0.5
  fpdart: ^1.1.0

  # Navigation & Routing
  go_router: ^14.2.0

  # Persistence & Secure Storage
  drift: ^2.20.0
  sqlcipher_flutter_libs: ^0.5.24
  sqlite3: ^2.4.5
  flutter_secure_storage: ^9.2.2
  path_provider: ^2.1.4
  path: ^1.9.0

  # Authentication & Google / Gmail APIs
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  google_sign_in: ^6.2.1
  googleapis: ^13.2.0
  extension_google_sign_in_as_googleapis_auth: ^2.0.12
  http: ^1.2.2

  # Push Notifications & Background
  firebase_messaging: ^15.1.3
  flutter_local_notifications: ^17.2.2
  workmanager: ^0.5.2

  # Time, Timezone & Localization
  timezone: ^0.9.4
  flutter_timezone: ^3.0.1
  intl: ^0.19.0

  # Rendering, MIME & Utilities
  webview_flutter: ^4.9.0
  html: ^0.15.4
  crypto: ^3.0.5
  uuid: ^4.5.1
  mime: ^1.0.6
  url_launcher: ^6.3.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.12
  drift_dev: ^2.20.0
  injectable_generator: ^2.6.1
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  golden_toolkit: ^0.15.0
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true
  generate: true # Enables automatic flutter gen-l10n

  assets:
    - assets/fonts/

  fonts:
    - family: Cairo
      fonts:
        - asset: assets/fonts/Cairo-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Cairo-Bold.ttf
          weight: 700
    - family: IBMPlexSansArabic
      fonts:
        - asset: assets/fonts/IBMPlexSansArabic-Regular.ttf
          weight: 400
        - asset: assets/fonts/IBMPlexSansArabic-Medium.ttf
          weight: 500
        - asset: assets/fonts/IBMPlexSansArabic-SemiBold.ttf
          weight: 600
```
