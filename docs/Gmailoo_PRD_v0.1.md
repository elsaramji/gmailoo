**Gmailoo**

Product Requirements Document (v0.1)

| Status | Draft for review |
| :---- | :---- |
| **Date** | 2 October 2026 |
| **Author** | Mahmoud Badawy |
| **Platform** | Flutter (iOS \+ Android), Firebase, Gmail API |
| **Locales** | Arabic (Egypt, ar-EG) and English (US, en-US), full RTL/LTR |

# **1\. Product Overview**

**One-liner:** An ephemeral, stress-free email client that shows only this week’s mail, sorts it for you, and only interrupts you when it truly matters.

**Problem:** Inbox Zero turns email into a to-do list that never ends. Gen Z and Gen Alpha avoid email because it feels like unpaid homework buried in promotions.

**Product principles**

* **Less, not more:** if it isn’t from this week, it isn’t here.

* **Quiet by default:** no notification unless it earns it.

* **Trust first:** the wipe is local only, and Gmail is never modified destructively.

* **Arabic is a first-class citizen**, not a translation.

**Audience:** Gen Z and older Gen Alpha (students, first-jobbers). **Flag:** Google accounts generally require users to be 13+, so realistic launch targeting is 13+. Review app-store age ratings and Egypt’s Personal Data Protection Law (151/2020).

**Non-goals (v1):** multi-account, non-Gmail providers, full-text search of history, desktop/web clients, AI summarization.

# **2\. Goals and Success Metrics**

*Targets below are hypotheses to be calibrated after beta.*

| Goal | Metric | Hypothesis target |
| :---- | :---- | :---- |
| Activation | Sign-in to first completed sync | ≥ 80% |
| Calm | Sessions per day (lower is not worse) | ≤ 3, avg session \< 2 min |
| Retention | Week-4 retention | ≥ 25% |
| Trust in filtering | Manual re-categorization rate | \< 10% of emails |
| Notification quality | Push-to-open rate / push opt-out rate | \> 40% / \< 10% |
| Reliability | Wipe success on cycle boundary | 100% |

# **3\. Personas**

* **Nour (17, student):** emails are mostly timetables, teacher messages, and scholarship promos. Wants exam schedules front and center.

* **Omar (22, first job):** a few people matter (manager, HR, client); everything else is noise. Wants “ping me only for these people.”

# **4\. Functional Requirements**

## **4.1 Auth and Permissions**

| ID | Story | Acceptance criteria |
| :---- | :---- | :---- |
| AU-1 | As a user, I sign in with Google. | Firebase Auth identity plus a separate Gmail OAuth grant; denial of the Gmail scope shows a clear retry state. |
| AU-2 | As a user, I can sign out and revoke. | Sign-out wipes the local DB, secure-storage keys, and FCM token registration. |

**Scopes (analysis):** gmail.modify (read and mark-read) and gmail.send. gmail.modify and gmail.readonly sit in the same restricted tier, so modify adds no extra verification cost and avoids read-state drift from Gmail.

## **4.2 Weekly Cycle (Time-Boxed Sync and Ephemeral Storage)**

**Rules**

* **Active window:** Saturday 00:00:00 to Thursday 23:59:59 in the user’s timezone (default Africa/Cairo). Use the timezone package, never a hardcoded UTC offset (Egypt has observed DST in recent years).

* **Friday \= Reset Day:** the wipe runs and the app shows a calm “Zen Day” screen.

* **Cycle ID** is the date of that cycle’s Saturday. All cached rows carry it.

* **Wipe scope:** message cache, bodies, attachment cache, VIP folder contents, derived categories. **Retained:** settings, VIP list, scheduled-send queue, auth state.

* **Wipe is local only.** Nothing is deleted in Gmail. State this in onboarding.

* **Trigger:** the source of truth is a cycleId check on app launch/resume. A background task is best-effort only, never the only mechanism. The wipe must be atomic and idempotent.

| ID | Story | Acceptance criteria |
| :---- | :---- | :---- |
| WC-1 | As a user, I only see mail from this week. | Initial sync queries after:/before: epoch bounds of the current window; nothing outside it is stored. |
| WC-2 | As a user, new mail arrives while I’m in the app. | Incremental sync via history.list(startHistoryId); on expired history (404), full resync of the window. |
| WC-3 | As a user, my data resets every week. | On cycle change: DB and cache dir deleted, new cycle synced, with a visible “fresh week” state. |
| WC-4 | As a user, I understand my mail isn’t gone. | “Open in Gmail” deep link on every message; onboarding states the local-only wipe. |

## **4.3 Smart Filtering**

Buckets are mutually exclusive per email. **First match wins:**

| \# | Bucket | Signals |
| :---- | :---- | :---- |
| 1 | **Marketing** (unless sender is VIP) | CATEGORY\_PROMOTIONS label, List-Unsubscribe header |
| 2 | **Timetables** | text/calendar part / .ics, or keywords EN (timetable, schedule, lecture, exam) and AR (جدول، محاضرة، امتحان، موعد) |
| 3 | **Important unread** | VIP sender or Gmail IMPORTANT label, and UNREAD |
| 4 | **Important** | Same as above, already read |
| 5 | Everything else | **Flag:** not in the original spec; see Risks |

Implement as a pluggable chain of ClassificationRule objects (Open/Closed) so rules can be added without touching the pipeline. Phase 2: an optional on-device ML classifier.

| ID | Story | Acceptance criteria |
| :---- | :---- | :---- |
| SF-1 | Mail is auto-sorted on arrival. | Classification runs on-device, \< 50 ms per email; deterministic for the same inputs. |
| SF-2 | I can correct a wrong category. | Long-press, “Move to…”; stored as a per-sender override that outranks rules. |
| SF-3 | Read mail leaves “Important unread.” | Opening a message moves it to “Important” and syncs UNREAD removal to Gmail. |

## **4.4 VIP Senders**

| ID | Story | Acceptance criteria |
| :---- | :---- | :---- |
| VIP-1 | I add a VIP from a message or by address. | Automatically creates a local folder named after the sender; routes past and future mail from that address within the cycle. |
| VIP-2 | I remove a VIP. | Folder is removed; mail falls back to normal bucket rules. |
| VIP-3 | VIP folders survive the wipe structurally. | Folder definitions persist; contents are wiped with the cycle. |

Folder membership is independent of bucket: a VIP email can be in “Important” and in the VIP folder.

## **4.5 Action Center (Create, Send, Schedule)**

| ID | Story | Acceptance criteria |
| :---- | :---- | :---- |
| AC-1 | I compose and send. | To/Cc/Bcc, subject, body, attachments; RTL/LTR auto-direction per field; sent via messages.send. |
| AC-2 | I save drafts. | Drafts autosave locally and survive the weekly wipe until sent or discarded. |
| AC-3 | I schedule a send. | Date/time picker; queue persists across the wipe; clear status (Scheduled / Sent / Failed \+ retry). |

## **4.6 Zen Notifications**

**Rule:** push only if a new email is from a **VIP sender** or lands in **Important unread**. Everything else is silent.

| ID | Story | Acceptance criteria |
| :---- | :---- | :---- |
| ZN-1 | I’m only pinged for what matters. | Non-eligible mail never produces a notification (verified by a test matrix). |
| ZN-2 | I control the quiet. | Quiet hours and per-VIP mute; notifications grouped, at most one summary per N minutes. |
| ZN-3 | I can see why I was pinged. | Notification subtitle shows “VIP” or “Important.” |

## **4.7 Localization**

ar-EG and en-US, switchable in-app, defaulting to the device locale.

* Use EdgeInsetsDirectional and AlignmentDirectional; mirror directional icons.

* **Per-item text direction detection** (subjects often mix Arabic with English/Franco).

* Dates and numbers via intl; digit style follows locale, with a toggle.

* Pick an Arabic-friendly typeface (analysis: Cairo or IBM Plex Sans Arabic).

# **5\. Non-Functional Requirements**

* **Performance:** cold start \< 2 s; first-sync metadata for \~500 messages \< 10 s on 4G; 60 fps scrolling.

* **Offline:** read everything in the current cycle offline.

* **Privacy and security:** SQLCipher-encrypted DB (key in Keychain/Keystore via flutter\_secure\_storage); remote images blocked by default; HTML bodies sanitized in WebView; no email content in logs or analytics.

* **Accessibility:** WCAG 2.2 AA, dynamic text scaling, TalkBack/VoiceOver labels in both languages.

* **Compliance:** Google API Services User Data Policy (Limited Use), Egypt PDPL, store policies.

# **6\. Technical Architecture**

## **6.1 Layers**

Strict dependency rule: Presentation → Domain ← Data.

* **Presentation:** Flutter UI with flutter\_bloc (analysis: Cubits for simple screens).

* **Domain:** pure Dart. Entities, use-case classes, repository interfaces. No Flutter, Firebase, or Google imports.

* **Data:** repository implementations, Gmail/Firebase data sources, drift DB, mappers.

| Principle | Application |
| :---- | :---- |
| SRP | One use case per class (SyncCurrentCycle, ClassifyMessage, WipeCycle) |
| OCP | New categorization rules are new ClassificationRules, with no pipeline edits |
| LSP | Fake and real repositories are interchangeable in tests |
| ISP | Split MailReader, MailSender, MailScheduler instead of one fat MailRepository |
| DIP | Domain owns abstractions; get\_it \+ injectable wire implementations |

## **6.2 Sync Strategy**

* messages.list with q=after:\<epoch\> before:\<epoch\> for the window, batched.

* Fetch format=metadata (From, Subject, Date, List-Unsubscribe, labels) for list screens; fetch the full body lazily on open.

* Store historyId; incremental sync via history.list.

* Inject a CycleClock interface so boundary logic is unit-testable.

## **6.3 Push Pipeline**

Gmail → users.watch → Cloud Pub/Sub → Cloud Function → FCM.

**Flag:** the Pub/Sub payload carries only the email address and a historyId, not message content. So “is this Important?” has two possible answers:

|  | Option A: Client-side (privacy-first) | Option B: Server-side |
| :---- | :---- | :---- |
| **How** | Silent FCM data message; app wakes, syncs, classifies, posts a local notification | Server holds a refresh token, reads metadata, sends a visible push |
| **Pros** | No Gmail data or tokens on your servers | Reliable and instant, works if the app is killed |
| **Cons** | iOS background wake-ups are throttled, so pings may be delayed or missed | Server-side restricted-scope access means heavier compliance |

**Recommendation (analysis):** Option A for MVP (Android reliable via high-priority data messages, iOS best-effort), then evaluate Option B once you know how much iOS misses. Also: the Gmail watch expires and must be renewed. With Option A the server holds no tokens and cannot renew it, so renewal runs on the client (on app open plus a best-effort background task); the backend stores each user’s watch expiry and sends a silent “renew” push shortly before it lapses. Option B can renew server-side.

## **6.4 Scheduled Send**

As far as I know, the Gmail API has no native scheduled-send endpoint, so Gmailoo must implement it:

* **Option A (MVP):** local scheduling (workmanager / BGTaskScheduler). Reasonably reliable on Android; on iOS, fall back to a local notification at the scheduled time with a one-tap “Send now” action.

* **Option B (v1):** server-side via Cloud Tasks with an encrypted refresh token. Reliable, but carries the same compliance cost as push Option B.

## **6.5 Local Data**

drift \+ SQLCipher (analysis: more actively maintained than Isar). Tables: messages, buckets, vip\_senders, vip\_folders, overrides, outbox, sync\_state. Everything cycle-scoped carries cycleId.

# **7\. Proposed Folder Structure**

lib/  
├── main.dart  
├── bootstrap.dart  
├── app/  
│   ├── app.dart  
│   ├── router/                  \# go\_router  
│   ├── theme/  
│   └── di/                      \# get\_it \+ injectable  
├── core/  
│   ├── error/                   \# failures, exceptions  
│   ├── usecase/                 \# UseCase\<T, Params\> base  
│   ├── time/                    \# CycleClock, timezone utils  
│   ├── network/                 \# authenticated Google http client  
│   └── utils/  
├── l10n/  
│   ├── app\_ar.arb  
│   └── app\_en.arb  
└── features/  
    ├── auth/  
    │   ├── data/         (datasources, models, repositories)  
    │   ├── domain/       (entities, repositories, usecases)  
    │   └── presentation/ (cubit, pages, widgets)  
    ├── weekly\_cycle/            \# cycle state, wipe, sync orchestration  
    ├── mailbox/  
    │   ├── data/  
    │   │   ├── datasources/     \# gmail\_remote\_ds, mail\_local\_ds (drift)  
    │   │   ├── models/          \# DTOs \+ mappers  
    │   │   └── repositories/  
    │   ├── domain/  
    │   │   ├── entities/        \# Email, Attachment, MailBucket  
    │   │   ├── repositories/    \# MailReader, MailSender  
    │   │   └── usecases/        \# SyncCycle, GetBucket, MarkRead  
    │   └── presentation/        \# inbox, thread, widgets  
    ├── categorization/          \# ClassificationRule chain \+ overrides  
    ├── vip/                     \# senders, local folders  
    ├── compose/                 \# Action Center: compose, drafts, schedule  
    ├── notifications/           \# NotificationPolicy, FCM, local notifs  
    └── settings/                \# language, quiet hours, cycle info  
test/                            \# mirrors lib/, with fakes per interface  
functions/                       \# Firebase Cloud Functions (Pub/Sub \-\> FCM)

# **8\. Release Plan**

| Phase | Scope |
| :---- | :---- |
| **0: Foundations** | Google OAuth verification kickoff, Pub/Sub \+ FCM spike, CycleClock \+ wipe spike, design system with RTL |
| **MVP** | Auth, weekly sync \+ wipe, 4 buckets, VIP folders, basic compose/send, Zen push (Option A), ar/en |
| **v1** | Scheduled send, overrides, quiet hours, drafts polish, evaluate server-side Option B |
| **v2** | On-device ML classifier, multi-account, home-screen widgets |

# **9\. Risks**

1. **Google verification is on the critical path.** Gmail’s read scopes are restricted, which triggers a CASA Tier 2 security assessment by a Google-approved assessor, and restricted-scope verification can take several weeks. Per Google’s own guidance, an annual security assessment applies if the app accesses restricted-scope data from or through a third-party server, which is why client-side Option A matters. Until verified, you are capped at 100 test users. Start in Phase 0 and confirm current rules with Google, since they change.

2. **Push reliability on iOS** (see 6.3). Set expectations in the beta.

3. **Scheduled send has no native API** (see 6.4).

4. **Coverage gap:** the four buckets don’t cover everything (personal mail, receipts, updates). Without a fallback they disappear, and users will think Gmailoo lost their mail. Recommendation: add a quiet “Everything else” tab.

5. **Wipe anxiety:** users may fear losing something important. Mitigate with “Open in Gmail” links and an optional “Keep” pin (see Open Questions).

6. **Age and privacy:** 13+ gating and a Limited-Use-compliant privacy policy.

# **10\. Open Questions**

1. **Friday mail:** the strict reading drops it. Recommended: the Saturday sync includes Friday onward so nothing is orphaned. Decide.

2. Should **Timetable** emails from Gmail-important senders trigger a push? As written, they don’t unless VIP.

3. Should users be able to **“Keep”** (pin) a few emails across the wipe?

4. Is the **cycle configurable** (e.g., Sun–Thu) for non-Egypt users?

5. Do we need **attachments** offline, or fetch on demand only?