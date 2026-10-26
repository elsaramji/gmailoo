// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'جيميلو';

  @override
  String get tagline => 'صندوق بريد هادئ ومؤقت';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get done => 'تم';

  @override
  String get back => 'رجوع';

  @override
  String get searchHint => 'ابحث في رسائل هذا الأسبوع...';

  @override
  String get openInGmail => 'فتح في Gmail';

  @override
  String get reply => 'رد';

  @override
  String get forward => 'إعادة توجيه';

  @override
  String get send => 'إرسال';

  @override
  String get compose => 'إنشاء رسالة';

  @override
  String get tabInbox => 'الوارد';

  @override
  String get tabTimetables => 'الجداول';

  @override
  String get tabVips => 'المميزون';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get splashSyncing => 'جاري مزامنة رسائل هذا الأسبوع...';

  @override
  String get splashSecurityFootnote =>
      'مشفر ومحلي فقط • مدعوم بواجهة Gmail API';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingTitle1 => 'بريد يتجدد كل أسبوع بهدوء. دون قلق.';

  @override
  String get onboardingBody1 =>
      'شاهد رسائل هذا الأسبوع فقط. يتم إخفاء العروض المزعجة، وتصعيد جداول الامتحانات، وكل جمعة بداية جديدة.';

  @override
  String get onboardingTitle2 => 'يوم الهدوء الجمعة: إعادة ضبط محلية تلقائية';

  @override
  String get onboardingBody2 =>
      'كل جمعة، يُفرغ صندوقك المحلي لتستمتع بعطلة نهاية أسبوع هادئة. رسائلك في Gmail تظل آمنة ولم تُمس.';

  @override
  String get onboardingTitle3 => 'تصنيفات ذكية وأولويات مهمة';

  @override
  String get onboardingBody3 =>
      'الجداول، والرسائل غير المقروءة المهمة، وجهات الاتصال المميزة تحصل على تمييز فوري. لا تنبيهات بدون داعٍ.';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get onboardingSignInPrompt => 'هل لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get authHeadline => 'تسجيل الدخول باستخدام Google';

  @override
  String get authSubtitle =>
      'اربط بريد Gmail بأمان لتجربة صندوق وارد مؤقت وخالٍ من التوتر.';

  @override
  String get authContinueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get authTrustPoint1 => 'يقرأ ويفرز رسائل الأسبوع الحالي فقط.';

  @override
  String get authTrustPoint2 => 'يرسل الردود ويجدول الرسائل بناءً على طلبك.';

  @override
  String get authTrustPoint3 =>
      'مسح محلي مؤقت فقط: لا تُحذف الرسائل الأصلية أبداً من Gmail.';

  @override
  String get authTrustPoint4 =>
      'لا تتبع طرف ثالث، لا إعلانات، ولا بيع للبيانات.';

  @override
  String get authOfficialScopeBadge =>
      'موثق رسمياً بنطاق معتمد من Google OAuth 2.0';

  @override
  String get authLegalFooter =>
      'متوافق مع قانون حماية البيانات الشخصية المصري (151/2020) وسياسة بيانات Google.';

  @override
  String get bucketAll => 'الكل';

  @override
  String get bucketImportantUnread => 'مهم غير مقروء';

  @override
  String get bucketImportant => 'مهم';

  @override
  String get bucketTimetables => 'الجداول والمواعيد';

  @override
  String get bucketMarketing => 'العروض الترويجية';

  @override
  String get bucketVip => 'VIP';

  @override
  String cycleStatusBadge(int days) {
    return 'هذا الأسبوع • متبقي $days أيام';
  }

  @override
  String get emptyInbox => 'أنت على اطلاع بكل جديد لهذا الأسبوع.';

  @override
  String get emptyFilter => 'لا توجد رسائل في هذا التصنيف.';

  @override
  String get syncedWithGmail => 'متزامن مع Gmail';

  @override
  String daysRemaining(int days) {
    return 'متبقي $days أيام';
  }

  @override
  String get addToCalendar => 'إضافة للتقويم';

  @override
  String get eventSynced => 'مضاف إلى تقويم Google';

  @override
  String get downloadAttachment => 'تحميل المرفق';

  @override
  String get timetablesTitle => 'الجداول والمواعيد';

  @override
  String get timetablesBanner =>
      'مواعيد موثقة مستخرجة من البريد • تُمسح محلياً يوم الجمعة';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterExams => 'امتحانات';

  @override
  String get filterLectures => 'محاضرات';

  @override
  String get filterDeadlines => 'تسليمات';

  @override
  String get vipsTitle => 'جهات الاتصال المميزة';

  @override
  String get vipsSubtitle =>
      'رسائل الـ VIP تتجاوز الفلاتر وتصلك تنبيهاتها دائماً.';

  @override
  String get addVip => 'إضافة جهة مميزة';

  @override
  String get vipProfessor => 'أستاذ جامعي';

  @override
  String get vipWork => 'عمل';

  @override
  String get zenDayTitle => 'أنهيت أسبوعك بنجاح.';

  @override
  String get zenDaySubtitleAr => 'صندوق وارد نظيف، بال هادئ';

  @override
  String get zenDayDescription =>
      'تم مسح رسائل هذا الأسبوع من هاتفك لتستمتع براحتك. تذكر دائماً، رسائلك الأصلية محفوظة في Gmail دون أدنى تغيير.';

  @override
  String get zenStatCleared => 'رسالة تم تصفيتها';

  @override
  String get zenStatVip => 'رسائل مميزة تم التعامل معها';

  @override
  String get zenStatTimetables => 'مواعيد أضيفت للتقويم';

  @override
  String get zenStatMarketing => 'عرض ترويجي تم إسكاته';

  @override
  String zenNextCycle(int hours) {
    return 'يبدأ الأسبوع الجديد السبت • يتجدد خلال $hours ساعة';
  }

  @override
  String get zenEnjoyWeekend => 'عطلة نهاية أسبوع سعيدة 🌿';

  @override
  String get zenTrustBadge => 'صفر قلق من التراكم • خصوصية مؤقتة 100%';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAccount => 'الحساب المرتبط';

  @override
  String get settingsAppearance => 'المظهر والعرض';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsThemeSystem => 'تلقائى (النظام)';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageAr => 'العربية (Arabic)';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsDigits => 'شكل الأرقام';

  @override
  String get settingsDigitsWestern => 'إنجليزية (0-9)';

  @override
  String get settingsDigitsIndic => 'مشرقية (٠-٩)';

  @override
  String get settingsNotifications => 'تنبيهات الهدوء';

  @override
  String get settingsNotificationsDesc => 'تنبيه فقط للرسائل المهمة والـ VIP';

  @override
  String get settingsQuietHours => 'ساعات الهدوء (10:00 م - 8:00 ص)';

  @override
  String get settingsStorage => 'التخزين المؤقت المحلي';

  @override
  String settingsCacheSize(String size) {
    return 'المساحة المحلية المستخدمة: $size';
  }

  @override
  String get settingsClearCache => 'مسح الذاكرة المؤقتة الآن';

  @override
  String get settingsSignOut => 'تسجيل الخروج ومسح البيانات المحلية';

  @override
  String get settingsVersion => 'إصدار جيميلو';

  @override
  String get composeTitle => 'رسالة جديدة';

  @override
  String get toField => 'إلى';

  @override
  String get subjectField => 'الموضوع';

  @override
  String get bodyField => 'اكتب رسالتك هنا...';

  @override
  String get scheduleSend => 'جدولة الإرسال';

  @override
  String get discard => 'حذف المسودة';
}
