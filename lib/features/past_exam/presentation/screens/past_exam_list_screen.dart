import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/router/app_routes.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_pill.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/core/widgets/level_chip.dart';
import 'package:practice_janpanese/core/widgets/level_picker_button.dart';
import 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_question.dart';
import 'package:practice_janpanese/features/past_exam/presentation/providers/past_exam_providers.dart';

/// Screen listing JLPT Past Exams for the active level.
class PastExamListScreen extends ConsumerWidget {
  const PastExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLevel = ref.watch(selectedLevelProvider);
    final examsAsync = ref.watch(currentLevelPastExamsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Exam (真題)'),
        actions: const [LevelPickerButton()],
      ),
      body: AsyncValueView(
        value: examsAsync,
        isEmpty: (exams) => exams.isEmpty,
        emptyMessage: '$activeLevel အတွက် Past Exam မေးခွန်းများ မရှိသေးပါ။',
        data: (exams) => ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH,
            vertical: AppSpacing.screenV,
          ),
          children: [
            _buildHeaderBanner(context, activeLevel),
            const SizedBox(height: AppSpacing.lg),
            ...exams.map(
              (source) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: _PastExamCard(source: source),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context, String level) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.level(level).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.level(level).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.level(level).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.quiz_outlined,
              color: AppColors.level(level),
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level စာမေးပွဲ မေးခွန်းဟောင်းများ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'JLPT အစစ်အမှန် မေးခွန်းများကို ရှင်းလင်းချက် အပြည့်အစုံဖြင့် လေ့ကျင့်ပါ',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSoft,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PastExamCard extends ConsumerWidget {
  const _PastExamCard({required this.source});

  final Source source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(pastExamSummaryProvider(source.id));
    final stripeColor = AppColors.level(source.jlptLevel);

    return AppCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: stripeColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: summaryAsync.when(
                    data: (summary) => _buildCardContent(context, summary),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => _buildCardBasic(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBasic(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          source.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LevelChip(level: source.jlptLevel ?? AppStrings.allLevels),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: () => context.push(AppRoutes.pastExamPractice(source.id)),
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('စတင်ဖြေဆိုမည်'),
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context, PastExamSummary? summary) {
    final totalQ = summary?.totalQuestions ?? 0;
    final vocabCount = summary?.subjectCounts[Subject.vocab] ?? 0;
    final grammarCount = summary?.subjectCounts[Subject.grammar] ?? 0;
    final readingCount = summary?.subjectCounts[Subject.reading] ?? 0;
    final listeningCount = summary?.subjectCounts[Subject.listening] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                source.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            AppPill(
              label: '$totalQ Questions',
              color: AppColors.level(source.jlptLevel),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            LevelChip(level: source.jlptLevel ?? AppStrings.allLevels),
            const SizedBox(width: AppSpacing.sm),
            if (source.examYear != null)
              Text(
                '${source.examYear} ခုနှစ် ${source.examMonth} လပိုင်း စာမေးပွဲ',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSoft,
                    ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.md),
        Text(
          'အပိုင်းအလိုက် လေ့ကျင့်ရန် ရွေးချယ်ပါ:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _buildSectionChip(
              context,
              title: '文字・語彙 ($vocabCount)',
              subject: Subject.vocab,
              color: AppColors.secondary,
            ),
            _buildSectionChip(
              context,
              title: '文法 ($grammarCount)',
              subject: Subject.grammar,
              color: AppColors.primaryLight,
            ),
            _buildSectionChip(
              context,
              title: '読解 ($readingCount)',
              subject: Subject.reading,
              color: AppColors.accent,
            ),
            _buildSectionChip(
              context,
              title: '聴解 ($listeningCount)',
              subject: Subject.listening,
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.push(
              AppRoutes.pastExamPractice(source.id),
            ),
            icon: const Icon(Icons.rocket_launch_rounded),
            label: Text('စာမေးပွဲ မေးခွန်းအားလုံး ဖြေဆိုမည် ($totalQ ပုဒ်)'),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionChip(
    BuildContext context, {
    required String title,
    required Subject subject,
    required Color color,
  }) {
    return InkWell(
      onTap: () => context.push(
        AppRoutes.pastExamPractice(source.id, subject),
      ),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xs + 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
