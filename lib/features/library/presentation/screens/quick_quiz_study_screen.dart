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
    this.chapterNumbers,
    this.questionLimit,
    this.isRandom = true,
  }) : assert(
          unitId != null || chapterNumber != null || chapterNumbers != null,
          'Either unitId, chapterNumber, or chapterNumbers must be provided',
        );

  final ContentKind kind;
  final int sourceId;
  final int? unitId;
  final int? chapterNumber;
  final List<int>? chapterNumbers;
  final int? questionLimit;
  final bool isRandom;

  @override
  ConsumerState<QuickQuizStudyScreen> createState() =>
      _QuickQuizStudyScreenState();
}

class _QuickQuizStudyScreenState extends ConsumerState<QuickQuizStudyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  bool _isCompleted = false;

  final Map<int, int> _selectedAnswers = {}; // _currentIndex -> selectedOptionIndex

  bool get _hasAnswered => _selectedAnswers.containsKey(_currentIndex);
  int? get _selectedOptionIndex => _selectedAnswers[_currentIndex];
  int get _correctCount => _selectedAnswers.entries.where((e) => _questions![e.key].correctIndex == e.value).length;
  int get _wrongCount => _selectedAnswers.length - _correctCount;

  List<QuizQuestion>? _questions;

  List<({StudyItem item, bool isCorrect, String selectedAnswer})> get _answerHistory {
    if (_questions == null) return [];
    return _selectedAnswers.entries.map((e) {
      final q = _questions![e.key];
      return (
        item: q.item,
        isCorrect: q.correctIndex == e.value,
        selectedAnswer: q.options[e.value],
      );
    }).toList();
  }

  void _generateQuestions(List<StudyItem> items) {
    if (_questions != null) return;

    final random = math.Random();
    var validItems = items
        .where((i) => i.meaning != null && i.meaning!.trim().isNotEmpty)
        .toList();

    if (validItems.isEmpty) {
      _questions = const [];
      _isCompleted = true;
      return;
    }

    // Shuffle items for quiz if random is requested
    if (widget.isRandom) {
      validItems.shuffle(random);
    }

    // Apply random question limit if specified
    if (widget.questionLimit != null &&
        widget.questionLimit! > 0 &&
        widget.questionLimit! < validItems.length) {
      validItems = validItems.take(widget.questionLimit!).toList();
    }

    String getCoreMeaning(StudyItem item) {
      final m = item.meaning?.trim() ?? '';
      if (m.contains('\n')) {
        return m.split('\n').first.trim();
      }
      return m;
    }

    final allMeanings = validItems
        .map(getCoreMeaning)
        .where((m) => m.isNotEmpty)
        .toSet()
        .toList();

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
    _selectedAnswers.clear();
    _isCompleted = false;
  }

  Future<void> _handleOptionSelected(int index) async {
    if (_hasAnswered || _questions == null || _questions!.isEmpty) return;

    final question = _questions![_currentIndex];
    final isCorrect = index == question.correctIndex;

    setState(() {
      _selectedAnswers[_currentIndex] = index;
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
    
    int nextUnanswered = -1;
    for (int i = 0; i < _questions!.length; i++) {
      if (!_selectedAnswers.containsKey(i)) {
        nextUnanswered = i;
        break;
      }
    }

    if (nextUnanswered == -1) {
      setState(() => _isCompleted = true);
    } else {
      setState(() {
        _currentIndex = nextUnanswered;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswers.clear();
      _isCompleted = false;
      _questions = null;
    });
  }

  Widget _buildQuestionGrid(BuildContext context, {bool isDrawer = false}) {
    if (_questions == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(_questions!.length, (index) {
          final isAnswered = _selectedAnswers.containsKey(index);
          final isCurrent = index == _currentIndex;
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = index);
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primary
                    : (isAnswered
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.surface),
                border: Border.all(
                  color: isCurrent
                      ? AppColors.primary
                      : (isAnswered
                          ? AppColors.primary
                          : AppColors.divider),
                  width: isCurrent ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrent
                      ? Colors.white
                      : (isAnswered
                          ? AppColors.primary
                          : AppColors.text),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showQuestionSelector(BuildContext context) {
    if (_questions == null || _questions!.isEmpty) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'မေးခွန်းရွေးရန်',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.6,
                ),
                child: _buildQuestionGrid(sheetContext),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'မေးခွန်းရွေးရန်',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Builder(
                builder: (drawerContext) => _buildQuestionGrid(drawerContext, isDrawer: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveChapters = widget.chapterNumbers ??
        (widget.chapterNumber != null ? [widget.chapterNumber!] : null);

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
            multiChapterItemsProvider(
              MultiChapterItemsParams(
                sourceId: widget.sourceId,
                chapterNumbers: effectiveChapters ?? const [],
                kind: widget.kind,
              ),
            ),
          );

    final sourceAsync = ref.watch(sourceProvider(widget.sourceId));
    final unitAsync =
        widget.unitId != null ? ref.watch(unitProvider(widget.unitId!)) : null;

    final String screenTitle;
    if (widget.unitId != null) {
      screenTitle = '${unitAsync?.value?.name ?? widget.kind.label} Quiz';
    } else {
      final chLabel = (effectiveChapters == null || effectiveChapters.isEmpty)
          ? 'All Chapters'
          : (effectiveChapters.length == 1
              ? 'Ch. ${effectiveChapters.first}'
              : 'Ch. ${effectiveChapters.join(", ")}');
      final limitLabel =
          widget.questionLimit != null ? ' (${widget.questionLimit} ပုဒ်)' : '';
      screenTitle =
          '${sourceAsync.value?.name ?? ''} · $chLabel$limitLabel Quiz';
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: _buildEndDrawer(context),
      appBar: AppBar(
        title: Text(
          screenTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        actions: [
          IconButton(
            tooltip: 'မေးခွန်းရွေးရန်',
            icon: const Icon(Icons.grid_view_rounded, color: AppColors.textSoft),
            onPressed: () {
              final isDesktop = MediaQuery.sizeOf(context).width >= 600;
              if (isDesktop) {
                _scaffoldKey.currentState?.openEndDrawer();
              } else {
                _showQuestionSelector(context);
              }
            },
          ),
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
