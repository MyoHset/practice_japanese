import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/constants/app_strings.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_pill.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';

/// Single multiple-choice quiz question generated from a [StudyItem].
class QuizQuestion {
  const QuizQuestion({
    required this.item,
    required this.options,
    required this.correctIndex,
  });

  final StudyItem item;
  final List<String> options;
  final int correctIndex;
}

/// Interactive 4-choice Quick Quiz screen for Section and Chapter study.
class QuickQuizStudyScreen extends ConsumerStatefulWidget {
  const QuickQuizStudyScreen({
    super.key,
    required this.kind,
    required this.sourceId,
    this.unitId,
    this.chapterNumber,
  }) : assert(
          unitId != null || chapterNumber != null,
          'Either unitId or chapterNumber must be provided',
        );

  final ContentKind kind;
  final int sourceId;
  final int? unitId;
  final int? chapterNumber;

  @override
  ConsumerState<QuickQuizStudyScreen> createState() =>
      _QuickQuizStudyScreenState();
}

class _QuickQuizStudyScreenState extends ConsumerState<QuickQuizStudyScreen> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _hasAnswered = false;
  int _correctCount = 0;
  int _wrongCount = 0;
  bool _isCompleted = false;

  List<QuizQuestion>? _questions;
  final List<({StudyItem item, bool isCorrect, String selectedAnswer})>
      _answerHistory = [];

  void _generateQuestions(List<StudyItem> items) {
    if (_questions != null && _questions!.length == items.length) return;

    final random = math.Random();
    final validItems = items
        .where((i) => i.meaning != null && i.meaning!.trim().isNotEmpty)
        .toList();

    if (validItems.isEmpty) {
      _questions = const [];
      _isCompleted = true;
      return;
    }

    String getCoreMeaning(StudyItem item) {
      final m = item.meaning?.trim() ?? '';
      if (m.contains('\n')) {
        return m.split('\n').first.trim();
      }
      return m;
    }

    final allMeanings = validItems.map(getCoreMeaning).where((m) => m.isNotEmpty).toSet().toList();

    _questions = validItems.map((item) {
      final correctMeaning = getCoreMeaning(item);

      // Pick 3 distractor meanings distinct from correctMeaning
      final distractors = allMeanings.where((m) => m != correctMeaning).toList()
        ..shuffle(random);

      final pickedDistractors = distractors.take(3).toList();

      // If we don't have 3 distractors, fill with generic fillers
      var fillerIndex = 1;
      while (pickedDistractors.length < 3) {
        pickedDistractors.add('အခြားအဓိပ္ပာယ် $fillerIndex');
        fillerIndex++;
      }

      final options = [correctMeaning, ...pickedDistractors]..shuffle(random);
      final correctIndex = options.indexOf(correctMeaning);

      return QuizQuestion(
        item: item,
        options: options,
        correctIndex: correctIndex,
      );
    }).toList();

    _currentIndex = 0;
    _selectedOptionIndex = null;
    _hasAnswered = false;
    _correctCount = 0;
    _wrongCount = 0;
    _isCompleted = false;
    _answerHistory.clear();
  }

  Future<void> _handleOptionSelected(int index) async {
    if (_hasAnswered || _questions == null || _questions!.isEmpty) return;

    final question = _questions![_currentIndex];
    final isCorrect = index == question.correctIndex;

    setState(() {
      _selectedOptionIndex = index;
      _hasAnswered = true;
      if (isCorrect) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
      _answerHistory.add(
        (
          item: question.item,
          isCorrect: isCorrect,
          selectedAnswer: question.options[index],
        ),
      );
    });

    // Record review in database
    final repo = ref.read(libraryRepositoryProvider);
    await repo.recordReview(
      kind: widget.kind,
      itemId: question.item.id,
      remembered: isCorrect,
    );
  }

  void _nextQuestion() {
    if (_questions == null) return;
    if (_currentIndex + 1 >= _questions!.length) {
      setState(() => _isCompleted = true);
    } else {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedOptionIndex = null;
      _hasAnswered = false;
      _correctCount = 0;
      _wrongCount = 0;
      _isCompleted = false;
      _answerHistory.clear();
      _questions = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<StudyItem>> itemsAsync = widget.unitId != null
        ? ref.watch(
            unitItemsProvider(
              (
                unitId: widget.unitId!,
                kind: widget.kind,
              ),
            ),
          )
        : ref.watch(
            chapterItemsProvider(
              (
                sourceId: widget.sourceId,
                chapterNumber: widget.chapterNumber!,
                kind: widget.kind,
              ),
            ),
          );

    final sourceAsync = ref.watch(sourceProvider(widget.sourceId));
    final unitAsync = widget.unitId != null
        ? ref.watch(unitProvider(widget.unitId!))
        : null;

    final String screenTitle = widget.chapterNumber != null
        ? '${sourceAsync.value?.name ?? ''} · Ch. ${widget.chapterNumber} Quiz'
        : '${unitAsync?.value?.name ?? widget.kind.label} Quiz';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          screenTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.retryQuiz,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSoft),
            onPressed: _restartQuiz,
          ),
        ],
      ),
      body: AsyncValueView<List<StudyItem>>(
        value: itemsAsync,
        isEmpty: (items) => items.isEmpty,
        emptyMessage: AppStrings.itemsCount(0),
        data: (items) {
          _generateQuestions(items);

          if (_questions == null || _questions!.isEmpty) {
            return Center(
              child: Text(
                AppStrings.itemsCount(0),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          if (_isCompleted) {
            return _buildResultView(context);
          }

          final question = _questions![_currentIndex];
          final progressRatio = (_currentIndex + 1) / _questions!.length;

          return SafeArea(
            child: Column(
              children: [
                // Top Progress and Score indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenH,
                    vertical: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${AppStrings.questionCount} ${_currentIndex + 1} / ${_questions!.length}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSoft,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_correctCount',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              const Icon(
                                Icons.cancel_rounded,
                                size: 14,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_wrongCount',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppProgressBar(value: progressRatio),
                    ],
                  ),
                ),

                // Question Card & Options
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenH,
                      vertical: AppSpacing.md,
                    ),
                    children: [
                      // Question Prompt Card
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          children: [
                            AppPill(
                              label: widget.kind.label,
                              color: AppColors.primarySoft,
                              textColor: AppColors.primary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            if (question.item.secondary != null &&
                                question.item.secondary!.isNotEmpty) ...[
                              Text(
                                question.item.secondary!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                            ],
                            Text(
                              question.item.primary,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.text,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 4 Multiple Choice Options
                      ...List.generate(question.options.length, (optIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: _buildOptionTile(
                            context,
                            index: optIndex,
                            text: question.options[optIndex],
                            question: question,
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // Bottom Next Question Bar (visible when answered)
                if (_hasAnswered)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenH,
                      vertical: AppSpacing.md,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        onPressed: _nextQuestion,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(
                          _currentIndex + 1 >= _questions!.length
                              ? 'ရလဒ်ကြည့်မည်'
                              : AppStrings.nextQuestion,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Single option button tile with instant color feedback upon selection.
  Widget _buildOptionTile(
    BuildContext context, {
    required int index,
    required String text,
    required QuizQuestion question,
  }) {
    final letters = ['A', 'B', 'C', 'D'];
    final letter = index < letters.length ? letters[index] : '${index + 1}';

    Color backgroundColor = AppColors.surface;
    Color borderColor = AppColors.divider;
    Color letterBg = AppColors.primarySoft;
    Color letterColor = AppColors.primary;
    Widget? trailingIcon;

    if (_hasAnswered) {
      if (index == question.correctIndex) {
        // Correct answer is always green
        backgroundColor = const Color(0xFFE8F7EE);
        borderColor = AppColors.secondary;
        letterBg = AppColors.secondary;
        letterColor = Colors.white;
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: AppColors.secondary,
          size: 22,
        );
      } else if (index == _selectedOptionIndex) {
        // Chosen wrong answer is red
        backgroundColor = const Color(0xFFFDE8E8);
        borderColor = AppColors.error;
        letterBg = AppColors.error;
        letterColor = Colors.white;
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: AppColors.error,
          size: 22,
        );
      }
    }

    return InkWell(
      onTap: _hasAnswered ? null : () => _handleOptionSelected(index),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: letterBg,
                shape: BoxShape.circle,
              ),
              child: Text(
                letter,
                style: TextStyle(
                  color: letterColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      height: 1.3,
                    ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }

  /// Results summary screen displayed upon finishing the quiz.
  Widget _buildResultView(BuildContext context) {
    final total = _questions?.length ?? 1;
    final percentage = ((_correctCount / total) * 100).toInt();

    String performanceLabel = AppStrings.keepPracticing;
    String badgeEmoji = '💪';
    if (percentage >= 85) {
      performanceLabel = AppStrings.excellentJob;
      badgeEmoji = '🏆';
    } else if (percentage >= 60) {
      performanceLabel = AppStrings.goodJob;
      badgeEmoji = '🌟';
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenH),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text(
                badgeEmoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.quizCompletedTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                performanceLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Score Box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$_correctCount / $total',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          AppStrings.quizScore,
                          style: TextStyle(
                            color: AppColors.textSoft,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(height: 36, width: 1, color: AppColors.divider),
                    Column(
                      children: [
                        Text(
                          '$percentage%',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'တိကျမှု',
                          style: TextStyle(
                            color: AppColors.textSoft,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  onPressed: _restartQuiz,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    AppStrings.retryQuiz,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    AppStrings.backToUnits,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Question-by-question review section
        Text(
          'အဖြေများ ပြန်လည်စစ်ဆေးရန်',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),

        ..._answerHistory.map((ans) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    ans.isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    color:
                        ans.isCorrect ? AppColors.secondary : AppColors.error,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ans.item.primary,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        if (ans.item.meaning != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            ans.item.meaning!,
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (!ans.isCorrect) ...[
                          const SizedBox(height: 2),
                          Text(
                            'သင်ရွေးချယ်ခဲ့သည်: ${ans.selectedAnswer}',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
