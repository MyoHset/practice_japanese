import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';

/// All route paths and typed path builder helpers per B3.
/// Widgets never build path strings by hand.
class AppRoutes {
  // ── Path patterns ──────────────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String home = '/';
  static const String sourceListPattern = '/library/:kind';
  static const String unitListPattern = '/library/:kind/source/:sourceId';
  static const String studyPattern =
      '/library/:kind/source/:sourceId/unit/:unitId/:mode';
  static const String chapterStudyPattern =
      '/library/:kind/source/:sourceId/chapter/:chapterNumber/:mode';
  static const String pastExam = '/past-exam';
  static const String pastExamPracticePattern = '/past-exam/:sourceId/practice';
  static const String pastExamFilteredPractice = '/past-exam/filtered-practice';

  // ── Typed path helpers ─────────────────────────────────────────────────────
  static String sourceList(ContentKind kind) => '/library/${kind.slug}';

  static String unitList(ContentKind kind, int sourceId) =>
      '/library/${kind.slug}/source/$sourceId';

  static String study(
    ContentKind kind,
    int sourceId,
    int unitId,
    StudyMode mode,
  ) =>
      '/library/${kind.slug}/source/$sourceId/unit/$unitId/${mode.slug}';

  static String chapterStudy(
    ContentKind kind,
    int sourceId,
    int chapterNumber,
    StudyMode mode,
  ) =>
      '/library/${kind.slug}/source/$sourceId/chapter/$chapterNumber/${mode.slug}';

  static String pastExamPractice(
    int sourceId, {
    Subject? subject,
    MondaiType? mondaiType,
  }) {
    final params = <String>[];
    if (subject != null) params.add('subject=${subject.name}');
    if (mondaiType != null) params.add('mondaiType=${mondaiType.name}');
    if (params.isNotEmpty) {
      return '/past-exam/$sourceId/practice?${params.join('&')}';
    }
    return '/past-exam/$sourceId/practice';
  }
}
