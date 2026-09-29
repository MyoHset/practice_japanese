import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/widgets/coming_soon_screen.dart';
import 'package:practice_janpanese/features/home/presentation/screens/home_screen.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_mode.dart';
import 'package:practice_janpanese/features/library/presentation/screens/source_list_screen.dart';
import 'package:practice_janpanese/features/library/presentation/screens/unit_list_mode_screen.dart';
import 'package:practice_janpanese/features/library/presentation/screens/unit_list_screen.dart';

/// Top-level GoRouter instance configuring application routes per B3.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  errorBuilder: (context, state) => const HomeScreen(),
  routes: [
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

        return ComingSoonScreen(
          title: '${kind.label} · ${mode.title}',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.pastExam,
      builder: (context, state) => const ComingSoonScreen(
        title: AppStrings.pastExam,
      ),
    ),
  ],
);
