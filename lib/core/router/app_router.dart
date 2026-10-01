import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/widgets/coming_soon_screen.dart';
import 'package:practice_janpanese/features/home/presentation/screens/home_screen.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/presentation/screens/flashcard_study_screen.dart';
import 'package:practice_janpanese/features/library/presentation/screens/quick_quiz_study_screen.dart';
import 'package:practice_janpanese/features/library/presentation/screens/source_list_screen.dart';
import 'package:practice_janpanese/features/library/presentation/screens/unit_list_mode_screen.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/features/library/presentation/screens/unit_list_screen.dart';
import 'package:practice_janpanese/features/past_exam/presentation/screens/past_exam_list_screen.dart';
import 'package:practice_janpanese/features/past_exam/presentation/screens/past_exam_practice_screen.dart';
import 'package:practice_janpanese/features/splash/presentation/screens/splash_screen.dart';

/// Top-level GoRouter instance configuring application routes per B3.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  errorBuilder: (context, state) => const HomeScreen(),
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.sourceListPattern,
      redirect: (context, state) {
        final kindSlug = state.pathParameters['kind'];
        if (kindSlug == null || ContentKind.tryFromSlug(kindSlug) == null) {
          return AppRoutes.home;
        }
        return null;
      },
      builder: (context, state) {
        final kind = ContentKind.fromSlug(state.pathParameters['kind']!);
        return SourceListScreen(kind: kind);
      },
    ),
    GoRoute(
      path: AppRoutes.unitListPattern,
      redirect: (context, state) {
        final kindSlug = state.pathParameters['kind'];
        final sourceIdStr = state.pathParameters['sourceId'];
        final kind =
            kindSlug != null ? ContentKind.tryFromSlug(kindSlug) : null;
        final sourceId = sourceIdStr != null ? int.tryParse(sourceIdStr) : null;
        if (kind == null || sourceId == null) {
          return AppRoutes.home;
        }
        return null;
      },
      builder: (context, state) {
        final kind = ContentKind.fromSlug(state.pathParameters['kind']!);
        final sourceId = int.parse(state.pathParameters['sourceId']!);
        return UnitListScreen(kind: kind, sourceId: sourceId);
      },
    ),
    GoRoute(
      path: AppRoutes.studyPattern,
      redirect: (context, state) {
        final kindSlug = state.pathParameters['kind'];
        final sourceIdStr = state.pathParameters['sourceId'];
        final unitIdStr = state.pathParameters['unitId'];
        final modeSlug = state.pathParameters['mode'];

        final kind =
            kindSlug != null ? ContentKind.tryFromSlug(kindSlug) : null;
        final sourceId = sourceIdStr != null ? int.tryParse(sourceIdStr) : null;
        final unitId = unitIdStr != null ? int.tryParse(unitIdStr) : null;
        final mode = modeSlug != null ? StudyMode.tryFromSlug(modeSlug) : null;

        if (kind == null ||
            sourceId == null ||
            unitId == null ||
            mode == null) {
          return AppRoutes.home;
        }
        return null;
      },
      builder: (context, state) {
        final kind = ContentKind.fromSlug(state.pathParameters['kind']!);
        final sourceId = int.parse(state.pathParameters['sourceId']!);
        final unitId = int.parse(state.pathParameters['unitId']!);
        final mode = StudyMode.fromSlug(state.pathParameters['mode']!);

        if (mode == StudyMode.list) {
          return UnitListModeScreen(
            kind: kind,
            sourceId: sourceId,
            unitId: unitId,
          );
        }

        if (mode == StudyMode.flashcard) {
          return FlashcardStudyScreen(
            kind: kind,
            sourceId: sourceId,
            unitId: unitId,
          );
        }

        if (mode == StudyMode.quick) {
          return QuickQuizStudyScreen(
            kind: kind,
            sourceId: sourceId,
            unitId: unitId,
          );
        }

        return ComingSoonScreen(
          title: '${kind.label} · ${mode.title}',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chapterStudyPattern,
      redirect: (context, state) {
        final kindSlug = state.pathParameters['kind'];
        final sourceIdStr = state.pathParameters['sourceId'];
        final chapterNumberStr = state.pathParameters['chapterNumber'];
        final modeSlug = state.pathParameters['mode'];

        final kind =
            kindSlug != null ? ContentKind.tryFromSlug(kindSlug) : null;
        final sourceId = sourceIdStr != null ? int.tryParse(sourceIdStr) : null;
        final chapterNumber =
            chapterNumberStr != null ? int.tryParse(chapterNumberStr) : null;
        final mode = modeSlug != null ? StudyMode.tryFromSlug(modeSlug) : null;

        if (kind == null ||
            sourceId == null ||
            chapterNumber == null ||
            mode == null) {
          return AppRoutes.home;
        }
        return null;
      },
      builder: (context, state) {
        final kind = ContentKind.fromSlug(state.pathParameters['kind']!);
        final sourceId = int.parse(state.pathParameters['sourceId']!);
        final chapterNumber = int.parse(state.pathParameters['chapterNumber']!);
        final mode = StudyMode.fromSlug(state.pathParameters['mode']!);

        if (mode == StudyMode.flashcard) {
          return FlashcardStudyScreen(
            kind: kind,
            sourceId: sourceId,
            chapterNumber: chapterNumber,
          );
        }

        if (mode == StudyMode.quick) {
          return QuickQuizStudyScreen(
            kind: kind,
            sourceId: sourceId,
            chapterNumber: chapterNumber,
          );
        }

        return ComingSoonScreen(
          title: '${kind.label} · Chapter $chapterNumber · ${mode.title}',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.pastExam,
      builder: (context, state) => const PastExamListScreen(),
    ),
    GoRoute(
      path: AppRoutes.pastExamFilteredPractice,
      builder: (context, state) => const PastExamPracticeScreen(
        useGlobalFilter: true,
      ),
    ),
    GoRoute(
      path: AppRoutes.pastExamPracticePattern,
      builder: (context, state) {
        final sourceId = int.parse(state.pathParameters['sourceId']!);
        final subjectStr = state.uri.queryParameters['subject'];
        final mondaiTypeStr = state.uri.queryParameters['mondaiType'];
        Subject? subject;
        if (subjectStr != null) {
          try {
            subject = Subject.values.byName(subjectStr);
          } catch (_) {}
        }
        MondaiType? mondaiType;
        if (mondaiTypeStr != null) {
          try {
            mondaiType = MondaiType.values.byName(mondaiTypeStr);
          } catch (_) {}
        }
        return PastExamPracticeScreen(
          sourceId: sourceId,
          subject: subject,
          mondaiType: mondaiType,
        );
      },
    ),
  ],
);
