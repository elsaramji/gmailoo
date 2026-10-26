// lib/core/mock/mock_fixtures.dart
import '../../features/auth/domain/entities/auth_session.dart';
import '../../features/categorization/domain/entities/mail_bucket.dart';
import '../../features/mailbox/domain/entities/attachment.dart';
import '../../features/mailbox/domain/entities/email.dart';
import '../../features/mailbox/domain/entities/email_body.dart';

class MockUserFixture {
  static const currentSession = AuthSession(
    userId: 'usr_9823412',
    email: 'mahmoud@gmail.com',
    displayName: 'Mahmoud Badawy',
    photoUrl: null,
  );
}

class MockCycleFixture {
  static const activeDaysRemaining = 3;
  static const activeHoursRemaining = 14;
  static const activeMinutesRemaining = 22;
  static const cycleLabel = 'Cycle 39 • Oct 3 – Oct 8';
}

class ExtractedEvent {
  final String title;
  final String startTime;
  final String endTime;
  final String location;
  final bool isSynced;

  const ExtractedEvent({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.isSynced = false,
  });
}

class MockEmailDetail {
  final Email email;
  final EmailBody body;
  final bool isVip;
  final String? vipRole;
  final ExtractedEvent? event;

  const MockEmailDetail({
    required this.email,
    required this.body,
    this.isVip = false,
    this.vipRole,
    this.event,
  });
}

class MockEmailFixtures {
  static final List<MockEmailDetail> allMockEmails = [
    MockEmailDetail(
      email: Email(
        id: 'msg_001',
        threadId: 'th_001',
        from: 'Dr. Tarek Hegazy <tarek.hegazy@eng.asu.edu.eg>',
        to: 'mahmoud@gmail.com',
        subject: 'CS402 Exam Schedule & Midterm Guidelines',
        snippet: 'Please review the updated lecture hall allocations and schedule for next Sunday. Attendance is mandatory...',
        receivedAt: DateTime.now().subtract(const Duration(hours: 2)),
        isUnread: true,
        bucket: MailBucket.timetables,
        attachments: const [
          Attachment(
            id: 'att_001',
            filename: 'CS402_Midterm_Seat_Distribution.pdf',
            mimeType: 'application/pdf',
            sizeBytes: 1887436,
          ),
        ],
      ),
      body: const EmailBody(
        messageId: 'msg_001',
        textPlain: '''Dear Senior Students,

Please find below the confirmed room allocations and timetable for the upcoming Midterm Examinations scheduled for Sunday, October 5th.

⚠️ Key Instructions:
1. Attendance is strictly required 15 minutes before the exam slot.
2. Bring your physical university ID card.
3. No electronic devices are permitted inside the hall.

Best regards,
Dr. Tarek Hegazy''',
      ),
      isVip: true,
      vipRole: 'VIP Professor',
      event: const ExtractedEvent(
        title: 'CS402 Distributed Systems Midterm',
        startTime: 'Sunday, Oct 5 • 10:00 AM',
        endTime: '12:00 PM',
        location: 'Hall 3B • Engineering Campus',
        isSynced: true,
      ),
    ),
    MockEmailDetail(
      email: Email(
        id: 'msg_002',
        threadId: 'th_002',
        from: 'إدارة الكلية (Faculty Admin) <admin@eng.asu.edu.eg>',
        to: 'mahmoud@gmail.com',
        subject: 'جدول المحاضرات والسكاشن المعدل للأسبوع الحالي',
        snippet: 'تم تحديث مواعيد قاعات المحاضرات لتبدأ من الساعة 9:00 صباحاً بدلاً من 8:30 بمدرج 4...',
        receivedAt: DateTime.now().subtract(const Duration(days: 1)),
        isUnread: false,
        bucket: MailBucket.timetables,
        attachments: const [
          Attachment(
            id: 'att_002',
            filename: 'CS_Cohort_Schedule.pdf',
            mimeType: 'application/pdf',
            sizeBytes: 1258291,
          ),
        ],
      ),
      body: const EmailBody(
        messageId: 'msg_002',
        textPlain: '''أعزاءنا الطلاب،

نحيطكم علماً بأنه قد تم تعديل جدول المحاضرات للأسبوع الحالي وفقاً لاقتراحات ممثلي الدفعات. تبدأ المحاضرات بقاعة 4 ابتداءً من يوم الاثنين القادم الساعة 9:00 صباحاً.

يرجى تحميل الجدول المرفق للاطلاع على التفاصيل الكاملة.''',
      ),
      event: const ExtractedEvent(
        title: 'محاضرة نظم التشغيل المتقدمة',
        startTime: 'Monday, Oct 6 • 09:00 AM',
        endTime: '11:00 AM',
        location: 'مدرج 4 - المبنى الرئيسي',
        isSynced: false,
      ),
    ),
    MockEmailDetail(
      email: Email(
        id: 'msg_003',
        threadId: 'th_003',
        from: 'Sarah Jenkins <s.jenkins@innovatetech.io>',
        to: 'mahmoud@gmail.com',
        subject: 'Sprint 4 Final Review: Ready for staging',
        snippet: 'The pull requests are approved and ready to merge before Thursday. Please test staging endpoints...',
        receivedAt: DateTime.now().subtract(const Duration(days: 2)),
        isUnread: false,
        bucket: MailBucket.important,
        attachments: const [],
      ),
      body: const EmailBody(
        messageId: 'msg_003',
        textPlain: '''Team,

The automated QA suites passed on Sprint 4. The branch is staged and ready for client sign-off. Please complete regression passes by Wednesday 5 PM.

Thanks!
Sarah''',
      ),
      event: const ExtractedEvent(
        title: 'Sprint 4 Deliverables & Staging Deadline',
        startTime: 'Wednesday, Oct 8 • 05:00 PM',
        endTime: '06:00 PM',
        location: 'Remote / Slack',
        isSynced: true,
      ),
    ),
    MockEmailDetail(
      email: Email(
        id: 'msg_004',
        threadId: 'th_004',
        from: 'Omar Khaled ⭐ <omar.k@gmailoo.co>',
        to: 'mahmoud@gmail.com',
        subject: 'Quick sync before the investor pitch',
        snippet: 'Hey, got the updated deck. Let me know when you have 5 minutes to run through slide 7...',
        receivedAt: DateTime.now().subtract(const Duration(days: 3)),
        isUnread: true,
        bucket: MailBucket.importantUnread,
        attachments: const [],
      ),
      body: const EmailBody(
        messageId: 'msg_004',
        textPlain: '''Hey Mahmoud,

The deck looks super crisp. Can we sync briefly for 5 mins to align on the ephemeral local wipe metrics?

Talk soon,
Omar''',
      ),
      isVip: true,
      vipRole: 'Co-Founder',
    ),
    MockEmailDetail(
      email: Email(
        id: 'msg_005',
        threadId: 'th_005',
        from: 'GitHub Notifications <notifications@github.com>',
        to: 'mahmoud@gmail.com',
        subject: 'Your weekly digest: 4 PRs merged in flutter/flutter',
        snippet: 'Here is what happened across your subscribed repositories this week. Flutter 3.24 released...',
        receivedAt: DateTime.now().subtract(const Duration(days: 4)),
        isUnread: false,
        bucket: MailBucket.marketing,
        attachments: const [],
      ),
      body: const EmailBody(
        messageId: 'msg_005',
        textPlain: '''GitHub Digest:
- 4 pull requests merged
- 2 releases published
- Check out trending Flutter repositories.''',
      ),
    ),
  ];

  static List<Email> get emails => allMockEmails.map((e) => e.email).toList();

  static MockEmailDetail findById(String id) {
    return allMockEmails.firstWhere(
      (e) => e.email.id == id,
      orElse: () => allMockEmails.first,
    );
  }
}

class MockZenDayFixture {
  static const totalEmailsCleared = 48;
  static const vipEmailsResolved = 4;
  static const timetablesSynced = 12;
  static const marketingMuted = 32;
  static const hoursSaved = 3.5;
  static const hoursRemainingUntilReset = 14;
}

class MockSettingsFixture {
  static const storageCachedSize = '14.2 MB';
  static const version = '1.0.0 (build 42)';
}
