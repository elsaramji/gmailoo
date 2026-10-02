# Gmailoo: AI Agent Implementation Plan

**Version:** 0.1 (draft) · **Audience:** AI coding agents (e.g., Claude Code) and the human reviewing them · **Stack:** Flutter, Clean Architecture, Firebase, Gmail API

This plan breaks Gmailoo into small, verifiable tasks an agent can execute one at a time. Every task lists what to read, what to build, how to prove it works, and when to stop and ask a human.

> **Sizing key:** S = a few hours of agent work, M = about a day, L = several days. Sizes are rough estimates (my analysis), not commitments.

---

## 0. How to Use This File

1. **Human:** complete the prerequisites in section 6 (accounts, keys, decisions) before the tasks that depend on them.
2. **Agent:** pick the next task whose dependencies are done, read its "Read first" files, implement it on its own branch, run the quality gates, and open a PR.
3. **Human:** review the PR against the task's acceptance criteria. Merge only when every box is checked.
4. Copy section 2 into the repo's `AGENTS.md` (or `CLAUDE.md`) so the rules load automatically in every session.

---

## 1. Source of Truth

Put these in `docs/` (agents read Markdown far better than `.docx`, so export the PRD with `pandoc Gmailoo_PRD_v0.1.docx -o docs/prd.md`):

| File | Governs |
|---|---|
| `docs/prd.md` | Product behavior, user stories, acceptance criteria (IDs like `WC-1`, `ZN-2`) |
| `docs/database/database-schema.md` | Every table, the wipe procedure, Firestore model |
| `docs/design-system/colors.md` | Color tokens, bucket colors, contrast rules |
| `docs/design-system/typography.md` | Fonts, type scale, RTL rules |
| `docs/agent-implementation-plan.md` | This file: order of work and task acceptance |

**Precedence when documents disagree:** database schema wins on storage, design system wins on visuals, PRD wins on behavior. **Never silently pick a side:** record the conflict in `docs/decisions/` and ask the human.

---

## 2. Agent Operating Rules

### Architecture (non-negotiable)
- **Dependency rule:** Presentation → Domain ← Data. `domain/` is pure Dart: no `package:flutter`, `firebase_*`, `googleapis`, or `drift` imports. A lint/test enforces this (T0.1).
- **SOLID:** one use case per class; split interfaces (`MailReader`, `MailSender`, `MailScheduler`); classification rules are pluggable `ClassificationRule` objects; dependencies are injected, never constructed inside a use case.
- **Time:** every "now" comes from an injected `Clock`. Every cycle boundary comes from `CycleClock`. Never call `DateTime.now()` in domain or data code.
- **Directional UI:** use `EdgeInsetsDirectional` and `AlignmentDirectional`; never `left`/`right` for layout or text alignment.

### Security and privacy
- OAuth tokens and the SQLCipher key live **only** in secure storage. Never in SQLite, logs, analytics, or Firestore.
- Never log email subjects, snippets, bodies, or addresses.
- Tests never call the real Gmail API. Use `FakeGmailApi` and fixtures with synthetic data.
- Never commit secrets: `google-services.json`, `GoogleService-Info.plist`, keystores, `.env`.

### Workflow
- One task = one branch (`task/T1.4-sync-engine`) = one PR. Conventional Commits (`feat:`, `fix:`, `test:`).
- Write the failing test first for domain and data logic.
- Keep diffs small. If a task needs more than ~600 changed lines (excluding generated code), stop and split it.
- Do not add a dependency, change an OAuth scope, or change the database schema without asking.
- Do not edit generated files (`*.g.dart`, `*.freezed.dart`, `app_localizations*.dart`) by hand.

### Stop and ask a human when
1. A requirement is ambiguous or two documents conflict (see Open Decisions, section 6).
2. The task needs a new package, permission, OAuth scope, or schema change.
3. A security or privacy trade-off appears that the docs don't cover.
4. A test fails and the cause is unclear after two focused attempts.
5. You are about to delete or rewrite code from an earlier task.

---

## 3. Tech Stack

*Use the latest stable versions and check each package's current API on pub.dev before coding; APIs change between major versions.*

| Area | Packages / tools |
|---|---|
| State | `flutter_bloc` (Cubits for simple screens) |
| DI | `get_it` + `injectable` |
| Routing | `go_router` |
| Local DB | `drift`, `sqlcipher_flutter_libs`, `drift_dev`, `build_runner` |
| Secure storage | `flutter_secure_storage` |
| Time | `timezone`, `flutter_timezone` |
| i18n | `flutter_localizations`, `intl`, `flutter gen-l10n` |
| Auth | `firebase_auth`, `google_sign_in` (verify its current auth + authorization flow; recent major versions changed it) |
| Gmail | `googleapis` + `extension_google_sign_in_as_googleapis_auth` or an `http` client with the access token |
| Push | `firebase_messaging`, `flutter_local_notifications` |
| Background | `workmanager` |
| HTML mail | `webview_flutter`, `html` (for sanitizing) |
| Testing | `flutter_test`, `bloc_test`, `mocktail`, `integration_test`, `alchemist` or `golden_toolkit` |
| Backend | Firebase Cloud Functions (TypeScript, 2nd gen), Firestore, Pub/Sub, Firebase Emulator Suite |

**Result type:** default to a small sealed `Result<T>` (`Ok`/`Err` with a `Failure`) to avoid an extra dependency. If you prefer `fpdart`, record it in an ADR in T0.2.

---

## 4. Target Repository Layout

Follows PRD §7, with the design-system and database code placed in `core/`:

```
lib/
├── main.dart · bootstrap.dart
├── app/            (router, theme, di)
├── core/
│   ├── error/ · usecase/ · result/ · time/ (Clock, CycleClock) · network/ · logging/
│   ├── design_system/   (colors.dart, typography.dart, theme.dart)
│   └── database/
│       ├── core/        (CoreDatabase + tables)
│       └── cycle/       (CycleDatabase + tables)
├── l10n/               (app_ar.arb, app_en.arb)
└── features/
    ├── auth/ · weekly_cycle/ · mailbox/ · categorization/
    ├── vip/ · compose/ · notifications/ · settings/
    └── (each: data/ domain/ presentation/)
test/                   (mirrors lib/; fixtures in test/fixtures/)
functions/              (Cloud Functions, TypeScript)
docs/                   (source-of-truth documents, decisions/)
tool/                   (check_coverage.sh, check_domain_purity.sh)
```

---

## 5. Global Definition of Done

Every task must pass **all** of these before its PR is mergeable:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze --fatal-infos
dart run build_runner build --delete-conflicting-outputs   # if the task touches generated code
flutter gen-l10n                                           # if the task touches .arb files
flutter test --coverage
tool/check_domain_purity.sh                                # no forbidden imports in domain/
tool/check_coverage.sh                                     # domain >= 90%, overall >= 70% (hypothesis targets)
```

Plus: acceptance criteria all checked, no `TODO` without an issue link, no PII in logs, UI tasks include goldens for **`en-US` LTR + `ar-EG` RTL × light + dark**.

---

## 6. Human-Gated Prerequisites and Open Decisions

An agent **cannot** do these. Do them early; several are on the critical path.

| # | Prerequisite | Needed by | Notes |
|---|---|---|---|
| H1 | **Google Cloud project**, Gmail API enabled, OAuth consent screen, scopes `gmail.modify` + `gmail.send` | T1.1 | Restricted scopes require Google verification and a security assessment; this takes weeks. **Start now.** Until verified, you are limited to 100 test users. Confirm current requirements with Google. |
| H2 | **Firebase project** (dev + prod), Auth (Google provider), Firestore, Cloud Messaging, Functions; `google-services.json` / `GoogleService-Info.plist` | T1.1, T1.13 | Add Android SHA-1/SHA-256 fingerprints. |
| H3 | **Apple:** developer account, APNs auth key uploaded to Firebase, push + background modes capabilities | T1.14 | iOS push cannot be tested without it. |
| H4 | **Pub/Sub topic** for Gmail push; grant `gmail-api-push@system.gserviceaccount.com` the Publisher role | T1.13 | Required by Gmail's push mechanism. |
| H5 | **Fonts downloaded** (Cairo 600/700, IBM Plex Sans Arabic 400/500/600) with license files into `assets/fonts/` | T0.3 | Verify license terms at download time. |
| H6 | **Test Gmail accounts** (2 to 3) with seeded mail: marketing, timetable, VIP-like, Arabic and English | T1.2 onward (manual QA) | Never use personal mail. |
| H7 | **Store accounts** (Play Console, App Store Connect) and privacy-policy URL | T2.4 | Data-safety / privacy forms need Limited Use language. |

**Open decisions** (agent must not guess; each blocks a specific task):

| # | Decision | Blocks | Default if you don't answer |
|---|---|---|---|
| D1 | **Friday mail:** excluded, or included in the next cycle's first sync? | T0.5, T1.4 | Strict (excluded); revisit after beta |
| D2 | Do **Timetable** emails from Gmail-important senders trigger a push? | T1.12 | No, unless VIP |
| D3 | Add the **"Everything else"** fallback bucket? | T1.5, T1.7 | Yes (schema already has `other`) |
| D4 | **Keep/pin** emails across the wipe? | post-MVP | Not in v1 |
| D5 | Per-cycle **message cap** and behavior at the cap | T1.4 | Newest first, cap 2,000, show a banner |

---

## 7. Phase Overview and Milestones

| Phase | Goal | Tasks | Exit criteria (milestone) |
|---|---|---|---|
| **P0 Foundations** | Runnable skeleton with design system, DBs, time logic | T0.1 to T0.8 | **M0:** app boots in ar/en, light/dark; DB + wipe unit-tested; CI green |
| **P1 MVP** | Core product on Android (iOS best-effort) | T1.1 to T1.16 | **M1 (internal alpha):** a tester signs in, sees this week's sorted mail, sends mail, gets Zen pushes |
| **P2 v1** | Scheduled send, overrides, quiet hours, release prep | T2.1 to T2.5 | **M2 (closed beta):** store-ready builds, verification progress |
| **P3 v2** | Backlog | see section 11 | n/a |

### Dependency graph

```
T0.1 ─┬─ T0.2 ─┬─ T0.5 ───────────────┐
      ├─ T0.3 ─┤                      │
      ├─ T0.4  │                      │
      └─ T0.8 ─┴─ T0.6 ─ T0.7 ────────┤
                                      ▼
T1.1 ─ T1.2 ─ T1.3 ─ T1.4 ─ T1.5 ─┬─ T1.7 ─ T1.8
                                  ├─ T1.6 ─ T1.9
                                  ├─ T1.10 ─ T1.11
                                  └─ T1.12 ─ T1.13 ─ T1.14
T1.15, T1.16 close out P1 · T2.x after M1
```

---

## 8. Phase 0: Foundations

### T0.1 Project bootstrap and CI · S
- **Goal:** empty app that builds, lints, and tests in CI.
- **Steps:** `flutter create` (org id from human); flavors `dev`/`prod`; strict `analysis_options.yaml`; folder skeleton from section 4; `tool/check_domain_purity.sh` (fails if any file under `lib/**/domain/` imports `package:flutter`, `firebase_`, `googleapis`, or `drift`); `tool/check_coverage.sh`; GitHub Actions workflow running the section 5 gates.
- **Acceptance:** [ ] `flutter run --flavor dev` boots a placeholder screen · [ ] CI green on a clean checkout · [ ] purity script fails when a forbidden import is added (prove with a temporary test) · [ ] `AGENTS.md` contains section 2.

### T0.2 Core primitives · S
- **Depends on:** T0.1 · **Read first:** PRD §6.1.
- **Build:** `Failure` hierarchy (`NetworkFailure`, `AuthFailure`, `QuotaFailure`, `StorageFailure`, `ValidationFailure`), `Result<T>`, `UseCase<T, P>`, `Clock` interface + `SystemClock` + `FakeClock`, `get_it` bootstrap, a logger that **rejects** PII (redacts anything resembling an email address).
- **Acceptance:** [ ] unit tests for `Result` mapping/folding · [ ] logger test proves addresses are redacted · [ ] ADR in `docs/decisions/` for the Result approach.

### T0.3 Design system tokens and theme · M
- **Depends on:** T0.1, H5 · **Read first:** `colors.md`, `typography.md`.
- **Build:** `GmailooColors` `ThemeExtension` (light + dark, five bucket palettes), `gmailooTextTheme(Locale, Color)`, `buildTheme(Brightness, Locale)`, font assets in `pubspec.yaml`, a debug-only "design gallery" screen showing every token and text style.
- **Acceptance:** [ ] token hex values match `colors.md` exactly (a test reads the md table and compares) · [ ] a test recomputes WCAG contrast for the pairs listed in `colors.md` and asserts ≥ 4.5:1 (text) / ≥ 3:1 (graphics) · [ ] `letterSpacing == 0` for every style (test) · [ ] goldens: gallery in en/ar × light/dark.

### T0.4 Localization and RTL scaffolding · S
- **Depends on:** T0.3.
- **Build:** `app_en.arb` / `app_ar.arb` with the first strings (app name, bucket names, tab labels); locale switcher (system / ar-EG / en-US); `directionOf(String)` helper for per-item text direction; digit-style formatter (locale / Western / Arabic-Indic).
- **Acceptance:** [ ] switching locale flips layout direction · [ ] `directionOf` tests: Arabic, English, mixed, URL/digits-only · [ ] a lint-style test greps `lib/` for `Alignment.centerLeft|centerRight`, `EdgeInsets.only(left|right` outside allowed files and fails.

### T0.5 CycleClock and cycle math · M
- **Depends on:** T0.2 · **Read first:** PRD §4.2, `database-schema.md` §4, decision D1.
- **Build:** pure-Dart `CycleClock`: `cycleIdFor(now, tz)` (the local date of the cycle's Saturday), `windowFor(cycleId, tz)` returning UTC-ms start (Sat 00:00:00 local) and end (Thu 23:59:59.999 local), `isResetDay(now, tz)` (Friday), `isWithin(window, instant)`. Use the `timezone` package; **never** a hardcoded UTC offset.
- **Acceptance:** [ ] table-driven tests for every weekday and boundary instant (Thu 23:59:59.999, Fri 00:00:00, Sat 00:00:00) · [ ] a DST changeover week in `Africa/Cairo` still yields local Sat 00:00 and Thu 23:59:59.999 · [ ] a second timezone (e.g., `Asia/Riyadh`, no DST) tested · [ ] ≥ 95% coverage on this class.

### T0.6 Core database · M
- **Depends on:** T0.2, T0.8 · **Read first:** `database-schema.md` §4, §5, §11, §13.
- **Build:** `CoreDatabase` (drift) with tables `session`, `app_settings`, `vip_senders`, `sender_overrides`, `outbox_messages`, `outbox_attachments`, `pending_gmail_ops`, `cycle_log`; SQLCipher setup; key generation + storage in secure storage; `PRAGMA foreign_keys = ON; journal_mode = WAL`; `drift_dev schema dump`; step-by-step migration scaffolding.
- **Acceptance:** [ ] table/column/CHECK definitions match the SQL in §5 (a test runs the md's SQL against an in-memory DB and compares `sqlite_master` with drift's generated schema) · [ ] CHECK tests: uppercase emails rejected, `scheduled` without `scheduled_at` rejected, `sent` without `sent_at` rejected · [ ] cascade test: deleting an outbox row deletes its attachments · [ ] key is never written to disk outside secure storage.

### T0.7 Cycle database · M
- **Depends on:** T0.6 · **Read first:** `database-schema.md` §6, §8, §9.
- **Build:** `CycleDatabase` with `cycle_meta`, `messages`, `message_bodies`, `attachments`, `notification_log` and the three indexes; a `CycleDatabaseFactory` that opens/creates/deletes the file (including `-wal`, `-shm`, `-journal`); the "schema version mismatch → delete and recreate" rule.
- **Acceptance:** [ ] query tests Q1 to Q10 from §8 against seeded data · [ ] `EXPLAIN QUERY PLAN` test asserts Q1 and Q4 use their indexes · [ ] deleting a message cascades to bodies, attachments, and notification log · [ ] factory test: after `delete()`, no `gmailoo_cycle.sqlite*` files remain.

### T0.8 Domain model and repository interfaces · M
- **Depends on:** T0.2 · **Read first:** PRD §4, §6.1.
- **Build (pure Dart):** entities `Email`, `EmailAddress`, `Attachment`, `MailBucket` (`importantUnread` is a derived view), `VipSender`, `OutboxMessage`, `CycleWindow`; interfaces `MailReader`, `MailSender`, `MailScheduler`, `CycleRepository`, `VipRepository`, `SettingsRepository`, `NotificationPolicy`, `ClassificationRule`; use-case classes as empty shells with signatures.
- **Acceptance:** [ ] no imports outside `dart:` and the project's own domain · [ ] immutable entities with value equality · [ ] each interface has a `Fake*` in `test/` for later tasks.

---

## 9. Phase 1: MVP

### T1.1 Authentication · M
- **Depends on:** T0.6, T0.4, H1, H2 · **PRD:** AU-1, AU-2.
- **Build:** Google sign-in requesting `gmail.modify` and `gmail.send`; Firebase Auth identity; tokens kept in secure storage; `SignIn`, `SignOut`, `GetSession` use cases; auth Cubit; sign-in screen (ar/en); sign-out that deletes both DB files, outbox files, secure-storage keys, and (after T1.13) the device document.
- **Acceptance:** [ ] denying the Gmail scope shows a retry state (bloc test) · [ ] sign-out leaves no `gmailoo_*.sqlite*` file (integration test) · [ ] no token appears in any DB or log (test scans both) · [ ] manual QA on a real device with H6 account.

### T1.2 Gmail remote data source · M
- **Depends on:** T1.1, T0.8 · **Read first:** PRD §6.2.
- **Build:** `GmailRemoteDataSource` with `listMessageIds(afterEpoch, beforeEpoch, pageToken)`, `getMetadata(ids)` (headers `From`, `To`, `Cc`, `Subject`, `Date`, `Message-ID`, `References`, `List-Unsubscribe`), `getFull(id)`, `listHistory(startHistoryId)`, `modifyLabels`, `send(raw)`; query uses epoch seconds in `after:`/`before:`; batched calls (keep batches ≤ 50); exponential backoff with jitter on 429/5xx; DTO → domain mappers; MIME walker that detects `text/calendar` parts and attachments. Ship `FakeGmailApi` + JSON fixtures.
- **Acceptance:** [ ] mapper tests with fixtures: Arabic subject, RFC 2047-encoded subject, multipart/alternative, calendar invite, missing headers · [ ] backoff test with a fake clock (no real sleeping) · [ ] HTTP 404 from `listHistory` maps to a typed `HistoryExpired` failure · [ ] address normalization lowercases and trims.

### T1.3 Cycle manager and wipe · M
- **Depends on:** T0.5, T0.7, T1.2 · **Read first:** `database-schema.md` §9 · **PRD:** WC-3.
- **Build:** `CycleManager.ensureCurrentCycle()` implementing the 11-step wipe procedure exactly (provisional `wipe_failed`, close, delete files, delete attachment cache, purge `sent` outbox rows and their files, recreate with new `cycle_meta`, finalize `cycle_log`); mutex; runs on launch and resume; a `workmanager` periodic task as a best-effort bonus; "Zen Day" state exposed for Fridays.
- **Acceptance:** [ ] crash-injection test: abort after each numbered step, relaunch, assert convergence to a clean cycle (invariant 6) · [ ] retained tables unchanged after wipe (invariant 1) · [ ] `cycle_log` records `message_count` and duration, no content · [ ] idempotent: running twice in a row is a no-op the second time.

### T1.4 Sync engine · L
- **Depends on:** T1.3 · **PRD:** WC-1, WC-2 · **Read first:** PRD §6.2, decisions D1, D5.
- **Build:** `SyncCurrentCycle` (full: paginate ids in window → metadata → classify → insert in transactions; stores `history_id`), `SyncIncremental` (`history.list`; on `HistoryExpired` fall back to full resync), `ApplyRemoteChanges` (new, label-changed, deleted → Q10); window enforcement (never insert outside `[window_start_utc, window_end_utc]`); cap per D5; sync state exposed to UI.
- **Acceptance:** [ ] a message outside the window is never stored (invariant 2) · [ ] incremental sync applies add / read-state change / delete · [ ] history-expired path triggers a full resync exactly once · [ ] sync is resumable after a mid-run kill · [ ] pending `mark_read` ops flush after sync (offline test).

### T1.5 Classification engine · M
- **Depends on:** T0.8, T1.2 · **PRD:** SF-1 · **Read first:** PRD §4.3, decisions D2, D3.
- **Build:** `ClassificationPipeline` running an ordered list of `ClassificationRule`s, first match wins: `MarketingRule` (promotions label or `List-Unsubscribe`, skipped for VIP) → `TimetableRule` (calendar part or EN/AR keyword list) → `ImportantRule` (Gmail important label or VIP) → `OtherRule`. Each result carries `matchedRule`. Keyword lists live in a single config file, not inline. Sender overrides (when present) short-circuit the pipeline.
- **Acceptance:** [ ] fixture-driven tests: ≥ 10 synthetic emails per bucket in Arabic, English, and mixed · [ ] precedence tests (a VIP email containing "schedule" lands in Timetables yet still notifies as VIP) · [ ] deterministic: same input, same output (property test) · [ ] < 50 ms per email (benchmark test with generous CI margin) · [ ] adding a rule requires no change to the pipeline class (demonstrated by a test-only rule).

### T1.6 VIP domain and data · S
- **Depends on:** T0.6, T1.5 · **PRD:** VIP-1, VIP-2, VIP-3.
- **Build:** `AddVip`, `RemoveVip`, `MuteVip`, `WatchVipFolders` (stream); on add/remove, reclassify the cycle's messages from that sender (Q8-style update driven by the pipeline); virtual folder query (Q4).
- **Acceptance:** [ ] adding a VIP immediately pulls that sender's existing messages into the VIP folder · [ ] removing a VIP returns them to normal bucket rules · [ ] folder definitions survive a wipe, contents don't (invariant 1).

### T1.7 Mailbox UI: tabs and list · L
- **Depends on:** T1.4, T1.5, T0.3 · **PRD:** SF-3 (display side) · **Read first:** `colors.md` §4, `typography.md` §3.
- **Build:** bucket tabs (Important unread, Important, Timetables, Marketing, + Everything else per D3) with badge counts (Q5); list rows per the design system (leading accent bar/dot + icon + label, unread = weight 600 + dot, per-item text direction); pull-to-refresh; empty/offline/error/syncing states; Zen Day screen on Fridays.
- **Acceptance:** [ ] goldens for every state in en/ar × light/dark · [ ] bucket accent is never used as text color (test greps widget code) · [ ] list scrolls at 60 fps with 500 rows (profile-mode measurement recorded in the PR) · [ ] text scale 200% doesn't overflow (golden) · [ ] TalkBack/VoiceOver labels exist for icon-only elements.

### T1.8 Message detail and safe HTML rendering · M
- **Depends on:** T1.7 · **PRD:** WC-4, SF-3.
- **Build:** thread view (Q6); lazy body fetch (`getFull`, store in `message_bodies`); sanitize HTML (strip scripts, event handlers, `<iframe>`, `<form>`); render in a WebView with **JavaScript disabled** and a CSP that blocks remote content by default (`img-src data: cid:`), with a per-message "Load images" button; mark-as-read on open (write `pending_gmail_ops` first, then update the message); "Open in Gmail" deep link; attachment list with on-demand download into the cycle cache.
- **Acceptance:** [ ] a tracking pixel is not requested until the user taps "Load images" (test with a local HTTP server) · [ ] `<script>` and `onerror` payloads in fixtures never execute · [ ] opening an unread Important message moves it from Q1 to Q2 with no other write (invariant 3) · [ ] Arabic/English mixed bodies render with correct direction.

### T1.9 VIP UI · S
- **Depends on:** T1.6, T1.7.
- **Build:** "Add as VIP" action on a message and by typing an address; VIP folders section on the main screen; mute toggle.
- **Acceptance:** [ ] goldens en/ar · [ ] adding/removing a VIP updates all lists live · [ ] address validation errors localized.

### T1.10 Compose and send · M
- **Depends on:** T1.2, T0.6 · **PRD:** AC-1.
- **Build:** compose screen (To/Cc/Bcc chips, subject, body, attachments ≤ 25 MB total, reply/forward prefill using thread id + `Message-ID`/`References` headers); `MimeBuilder` producing RFC 5322 messages with **RFC 2047 encoded UTF-8 subjects**, correct `Content-Type` charset, base64url for the Gmail API; per-field text direction.
- **Acceptance:** [ ] MIME tests: Arabic subject and body, long subject folding, attachment, reply headers · [ ] output decodes back to the original text (round-trip test) · [ ] send failure leaves the message in the outbox as `failed` with a retry action · [ ] manual QA: mail sent from the app arrives correctly threaded in Gmail.

### T1.11 Drafts autosave · S
- **Depends on:** T1.10 · **PRD:** AC-2.
- **Acceptance:** [ ] drafts save locally within 1 s of the last edit (debounced) and survive app kill and the weekly wipe · [ ] discarding deletes the outbox row and its attachment files.

### T1.12 Notification policy and local notifications · M
- **Depends on:** T1.5, T1.6, T0.7 · **PRD:** ZN-1, ZN-3 · **Read first:** `database-schema.md` Q9, decision D2.
- **Build:** domain `NotificationPolicy` returning `{reason, outcome}` (`vip` wins over `important_unread`; muted VIP suppresses entirely); `notification_log` writes (one row per message); local notification with subtitle "VIP" / "Important"; Android channel setup; permission request flow (Android 13+, iOS).
- **Acceptance:** [ ] **exhaustive decision-table test** over (VIP?, muted?, bucket, unread?, notifications enabled?) proving non-eligible mail never notifies (invariant 4) · [ ] re-delivery of the same message creates no second notification or log row (invariant 5) · [ ] Q9 integration test with seeded data.

### T1.13 Firebase backend · M
- **Depends on:** H2, H4 · **Read first:** `database-schema.md` §10.
- **Build (`functions/`, TypeScript):** `onGmailPush` (Pub/Sub → hash address → look up users → data-only FCM `{type:"sync", historyId}` → delete device docs on `UNREGISTERED`); `registerDevice` callable (verifies the Auth token email, writes `emailHash` and the device doc); `unregisterDevice` callable; `renewNudge` scheduled function (silent `{type:"renew_watch"}` for users whose `watchExpiresAt` is within ~24 h); Firestore rules from §10 (client writes denied); TTL policy on `devices.expireAt`.
- **Acceptance:** [ ] emulator tests: push for an unknown address is a no-op, known address fans out to all devices · [ ] rules tests: a client cannot write another user's document or its own `emailHash` · [ ] no log line contains an email address or `historyId` payload beyond what's needed · [ ] function payload contains no subject/sender/body.

### T1.14 Push client and Gmail watch · M
- **Depends on:** T1.12, T1.13, H3 · **PRD:** ZN-1.
- **Build:** FCM setup (permissions, token refresh → `registerDevice`); background/terminated data-message handler that runs `SyncIncremental`, classifies locally, and posts local notifications through the policy; `users.watch` registration after sign-in, store `watch_expires_at`, renew on app open and on `renew_watch` pushes; Android high-priority handling; iOS `content-available` handling.
- **Acceptance:** [ ] with the emulator + a fake push, a VIP email produces exactly one notification and a marketing email produces none · [ ] a manual device test matrix is recorded in the PR: Android foreground/background/killed, iOS foreground/background/killed, with observed latency · [ ] watch renewal fires when expiry is < 24 h · [ ] known iOS limitation is documented in the PR, not hidden.

### T1.15 Settings, onboarding, Zen Day · S
- **Depends on:** T1.3, T1.12.
- **Build:** onboarding (3 screens: what Gmailoo is, **"your mail stays in Gmail; we only clear this device"**, permissions); settings (language, theme, digits, notifications on/off, cycle info); Zen Day screen.
- **Acceptance:** [ ] onboarding states the local-only wipe in ar and en (PRD WC-4) · [ ] goldens en/ar × light/dark · [ ] settings persist in `app_settings`.

### T1.16 Alpha hardening · M
- **Depends on:** all P1 tasks.
- **Build:** offline behavior pass, error-state pass, accessibility pass (WCAG 2.2 AA, TalkBack/VoiceOver, 200% text), performance pass (cold start < 2 s, first sync of ~500 messages < 10 s on 4G, recorded), crash reporting with PII scrubbing, backup exclusion (Android `allowBackup="false"` or data-extraction rules; iOS `isExcludedFromBackup`).
- **Acceptance:** [ ] measured numbers in the PR description · [ ] a test (or manifest check in CI) proves the DB directory is excluded from backups · [ ] M1 checklist signed off by the human.

---

## 10. Phase 2: v1

### T2.1 Scheduled send · L
- **Depends on:** M1 · **PRD:** AC-3 · **Read first:** PRD §6.4.
- **Build:** schedule picker; `MailScheduler` implementation using `workmanager` on Android; **iOS fallback:** a local notification at the scheduled time with a one-tap "Send now" action; statuses Scheduled / Sending / Sent / Failed with retry; surviving the weekly wipe; due-send query Q11.
- **Acceptance:** [ ] a due `scheduled` row is sent exactly once (invariant 7; idempotency key on `outbox_messages.id`) · [ ] Android: sent within a documented tolerance when the app is killed · [ ] iOS: fallback notification appears and one tap sends · [ ] UI states clearly say "best-effort: your phone must be able to run Gmailoo" until Option B ships.

### T2.2 Sender overrides ("Move to…") · S
- **PRD:** SF-2.
- **Acceptance:** [ ] long-press → bucket picker writes `sender_overrides` and applies Q8 · [ ] override outranks every rule (test) · [ ] undo is available.

### T2.3 Quiet hours and notification grouping · S
- **PRD:** ZN-2.
- **Acceptance:** [ ] quiet hours spanning midnight (e.g., 23:00 to 07:00) handled with `CycleClock`/timezone, not UTC math · [ ] suppressed mail logs `suppressed_quiet_hours` and surfaces in a morning summary · [ ] grouping respects `notify_group_window_min`.

### T2.4 Release engineering · M
- **Depends on:** H7.
- **Build:** signing configs, app icons/splash (from the design system), Fastlane or Actions for Play internal testing and TestFlight, store listings (ar + en), privacy policy and data-safety answers using Google's Limited Use language, crash-free-sessions dashboard.
- **Acceptance:** [ ] a tagged commit produces signed builds in both stores' test tracks · [ ] privacy policy matches actual data flows (the database doc §11 is the reference).

### T2.5 Decision spike: push/scheduling Option B · S
- **Output:** an ADR comparing Option A reliability data collected in beta against server-side processing cost (security assessment, token custody). **The agent writes the analysis; a human decides.**

---

## 11. Phase 3 Backlog (v2)

On-device ML classifier · multi-account (adds `account_id` columns) · home-screen widgets · opt-in encrypted sync for VIP list and settings · FTS5 search in the cycle DB · "Keep" pin across the wipe (decision D4).

---

## 12. PRD Traceability

| PRD ID | Task(s) |
|---|---|
| AU-1, AU-2 | T1.1 |
| WC-1, WC-2 | T1.4 |
| WC-3 | T1.3 |
| WC-4 | T1.8, T1.15 |
| SF-1 | T1.5 |
| SF-2 | T2.2 |
| SF-3 | T1.4, T1.7, T1.8 |
| VIP-1, VIP-2, VIP-3 | T1.6, T1.9 |
| AC-1 | T1.10 |
| AC-2 | T1.11 |
| AC-3 | T2.1 |
| ZN-1, ZN-3 | T1.12, T1.14 |
| ZN-2 | T2.3 |
| Localization (§4.7) | T0.3, T0.4 and every UI task's goldens |

---

## 13. Reusable Agent Prompt

Paste this at the start of each task, filling in the bracketed parts:

```text
You are implementing task [T1.4 Sync engine] of the Gmailoo project.

1. Read AGENTS.md, then these files in full: [docs/prd.md §4.2 and §6.2,
   docs/database/database-schema.md §8-§9, and the task section in
   docs/agent-implementation-plan.md].
2. Confirm the task's dependencies are merged. If not, stop and tell me.
3. Create branch task/[T1.4-sync-engine]. Write failing tests first for domain
   and data logic, then implement.
4. Follow the architecture and security rules in AGENTS.md. Do not add
   dependencies, OAuth scopes, or schema changes without asking.
5. Run every command in section 5 (Definition of Done) and fix failures.
6. Open a PR whose description lists each acceptance criterion with a
   checked box and the evidence (test name, golden path, or measurement).
7. If anything is ambiguous or blocked by an open decision (D1 to D5),
   stop and ask instead of guessing.
```

---

## 14. PR Checklist (put in `.github/pull_request_template.md`)

```markdown
## Task
T?.? : <title>

## Acceptance criteria
- [ ] (copy each box from the task, with evidence)

## Quality gates
- [ ] format · analyze · tests · coverage · domain-purity all pass
- [ ] goldens updated for en-US/ar-EG × light/dark (UI tasks)
- [ ] no PII in logs; no secrets committed
- [ ] no new dependency / scope / schema change (or approved: <link>)

## Notes for reviewer
<trade-offs, measurements, known limitations>
```

---

## 15. CI Sketch (`.github/workflows/ci.yml`)

```yaml
name: ci
on: [pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { channel: stable, cache: true }
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter gen-l10n
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter analyze --fatal-infos
      - run: flutter test --coverage
      - run: tool/check_domain_purity.sh
      - run: tool/check_coverage.sh
  functions:
    runs-on: ubuntu-latest
    defaults: { run: { working-directory: functions } }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: npm, cache-dependency-path: functions/package-lock.json }
      - run: npm ci
      - run: npm run build
      - run: npm test   # Firebase emulator suite
```

*Pin action versions and Flutter/Node versions to what the team uses; the values above are placeholders.*
