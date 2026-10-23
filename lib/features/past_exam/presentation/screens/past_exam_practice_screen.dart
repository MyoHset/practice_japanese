import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/database/app_database.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/core/widgets/app_card.dart';
import 'package:practice_janpanese/core/widgets/app_pill.dart';
import 'package:practice_janpanese/core/widgets/app_progress_bar.dart';
import 'package:practice_janpanese/core/widgets/async_value_view.dart';
import 'package:practice_janpanese/features/level/presentation/providers/selected_level_provider.dart';
import 'package:practice_janpanese/core/extensions/build_context_x.dart';
import 'package:practice_janpanese/features/past_exam/domain/past_exam_question.dart';
import 'package:practice_janpanese/features/past_exam/presentation/providers/past_exam_providers.dart';

/// Interactive practice screen for JLPT Past Exam questions.
class PastExamPracticeScreen extends ConsumerStatefulWidget {
  const PastExamPracticeScreen({
    super.key,
    this.sourceId,
    this.subject,
    this.mondaiType,
    this.useGlobalFilter = false,
  });

  final int? sourceId;
  final Subject? subject;
  final MondaiType? mondaiType;
  final bool useGlobalFilter;

  @override
  ConsumerState<PastExamPracticeScreen> createState() =>
      _PastExamPracticeScreenState();
}

class _PastExamPracticeScreenState
    extends ConsumerState<PastExamPracticeScreen> {
  int _currentIndex = 0;
  final Map<int, int> _answers = {};
  final Map<int, bool> _correctness = {};
  bool _isCompleted = false;
  bool _isPassageExpanded = true;

  /// Timer state
  Timer? _timer;
  int _secondsElapsed = 0;
  int? _countdownLimitSeconds; // null = stopwatch, positive = countdown
  bool _isPaused = false;

  /// When non-null, overrides the provider's questions (e.g. retry-wrong-only).
  List<PastExamQuestion>? _filteredQuestions;

  int get _correctCount => _correctness.values.where((c) => c).length;
  int get _wrongCount => _correctness.values.where((c) => !c).length;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isCompleted || _isPaused) return;

      setState(() {
        _secondsElapsed++;
        if (_countdownLimitSeconds != null &&
            _secondsElapsed >= _countdownLimitSeconds!) {
          _timer?.cancel();
          _isCompleted = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⏱️ အချိန်ပြည့်သွားပါပြီ! အဖြေများကို တင်လိုက်ပါပြီ။'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      });
    });
  }

  void _pauseResumeTimer() {
    setState(() => _isPaused = !_isPaused);
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onOptionSelected(PastExamQuestion question, int position) {
    if (_answers.containsKey(_currentIndex)) return;

    final isCorrect = position == question.correctPosition;
    setState(() {
      _answers[_currentIndex] = position;
      _correctness[_currentIndex] = isCorrect;
    });
  }

  void _jumpToQuestion(int index) {
    setState(() {
      _currentIndex = index;
      _isPassageExpanded = true;
    });
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentIndex + 1 >= totalQuestions) {
      _timer?.cancel();
      setState(() => _isCompleted = true);
    } else {
      setState(() {
        _currentIndex++;
        _isPassageExpanded = true;
      });
    }
  }

  Widget _buildQuestionGrid(
    BuildContext context,
    int totalQuestions, {
    bool isDrawer = false,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: List.generate(totalQuestions, (index) {
          final hasAnswered = _answers.containsKey(index);
          final isCurrent = index == _currentIndex;
          final isCorrect = _correctness[index] ?? false;

          Color bgColor = AppColors.surface;
          Color textColor = AppColors.text;
          Color borderColor = Colors.transparent;

          if (isCurrent) {
            bgColor = AppColors.primary;
            textColor = Colors.white;
          } else if (hasAnswered) {
            bgColor = isCorrect
                ? AppColors.secondary.withValues(alpha: 0.15)
                : AppColors.error.withValues(alpha: 0.15);
            textColor = isCorrect ? AppColors.secondary : AppColors.error;
            borderColor = isCorrect
                ? AppColors.secondary.withValues(alpha: 0.3)
                : AppColors.error.withValues(alpha: 0.3);
          } else {
            borderColor = AppColors.divider;
          }

          return InkWell(
            onTap: () {
              if (isDrawer) {
                Scaffold.of(context).closeEndDrawer();
              } else {
                Navigator.of(context).pop();
              }
              _jumpToQuestion(index);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent ? AppColors.primary : borderColor,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showQuestionNavigationSheet(BuildContext context, int totalQuestions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'မေးခွန်းရွေးချယ်ရန်',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.6,
              ),
              child: _buildQuestionGrid(
                sheetContext,
                totalQuestions,
                isDrawer: false,
              ),
            ),
          ],
        );
      },
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _answers.clear();
      _correctness.clear();
      _isCompleted = false;
      _isPassageExpanded = true;
      _filteredQuestions = null;
      _secondsElapsed = 0;
      _isPaused = false;
    });
    _startTimer();
  }

  /// Retry only the questions that were answered incorrectly.
  void _retryWrongOnly(List<PastExamQuestion> allQuestions) {
    final wrongQuestions = _correctness.entries
        .where((e) => !e.value)
        .map((e) => allQuestions[e.key])
        .toList();

    if (wrongQuestions.isEmpty) return;

    setState(() {
      _filteredQuestions = wrongQuestions;
      _currentIndex = 0;
      _answers.clear();
      _correctness.clear();
      _isCompleted = false;
      _isPassageExpanded = true;
      _secondsElapsed = 0;
      _isPaused = false;
    });
    _startTimer();
  }

  /// Retry questions belonging to weak Mondai Types.
  void _retryWeakOnly(
    List<PastExamQuestion> allQuestions,
    Set<MondaiType> weakMondaiTypes,
  ) {
    final weakQuestions = allQuestions
        .where((q) => weakMondaiTypes.contains(q.mondaiType))
        .toList();

    if (weakQuestions.isEmpty) return;

    setState(() {
      _filteredQuestions = weakQuestions;
      _currentIndex = 0;
      _answers.clear();
      _correctness.clear();
      _isCompleted = false;
      _isPassageExpanded = true;
      _secondsElapsed = 0;
      _isPaused = false;
    });
    _startTimer();
  }

  void _showTimerSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: AppColors.primary),
                      const SizedBox(width: AppSpacing.sm),
                      const Text(
                        'Mock Exam Timer ဆက်တင်',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'စာမေးပွဲ အချိန်သတ်မှတ်ချက် ရွေးချယ်ပါ:',
                    style: TextStyle(fontSize: 13, color: AppColors.textSoft),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTimerOption(
                        label: 'Stopwatch (အချိန်မကန့်သတ်)',
                        seconds: null,
                        sheetContext: sheetContext,
                      ),
                      _buildTimerOption(
                        label: '၁၅ မိနစ် (Quick Drill)',
                        seconds: 15 * 60,
                        sheetContext: sheetContext,
                      ),
                      _buildTimerOption(
                        label: '၃၀ မိနစ် (Vocab Session)',
                        seconds: 30 * 60,
                        sheetContext: sheetContext,
                      ),
                      _buildTimerOption(
                        label: '၆၀ မိနစ် (Grammar & Reading)',
                        seconds: 60 * 60,
                        sheetContext: sheetContext,
                      ),
                      _buildTimerOption(
                        label: '၁၀၅ မိနစ် (JLPT Full)',
                        seconds: 105 * 60,
                        sheetContext: sheetContext,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _pauseResumeTimer();
                        Navigator.pop(sheetContext);
                      },
                      icon: Icon(
                        _isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                      ),
                      label: Text(_isPaused ? 'Resume Timer' : 'Pause Timer'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimerOption({
    required String label,
    required int? seconds,
    required BuildContext sheetContext,
  }) {
    final isSelected = _countdownLimitSeconds == seconds;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _countdownLimitSeconds = seconds;
          _secondsElapsed = 0;
          _isPaused = false;
        });
        Navigator.pop(sheetContext);
      },
    );
  }

  Widget _buildTimerPill(BuildContext context) {
    final isCountdown = _countdownLimitSeconds != null;
    final int displaySeconds = isCountdown
        ? (_countdownLimitSeconds! - _secondsElapsed).clamp(0, 999999)
        : _secondsElapsed;
    final bool isUrgent =
        isCountdown && displaySeconds <= 180 && displaySeconds > 0;

    return Center(
      child: InkWell(
        onTap: () => _showTimerSettingsSheet(context),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isUrgent
                ? AppColors.error.withValues(alpha: 0.12)
                : AppColors.primarySoft,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: isUrgent
                  ? AppColors.error
                  : AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isPaused
                    ? Icons.pause_circle_rounded
                    : (isCountdown
                        ? Icons.timer_rounded
                        : Icons.timer_outlined),
                size: 14,
                color: isUrgent ? AppColors.error : AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDuration(displaySeconds),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: isUrgent ? AppColors.error : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubjectLabel(Subject? subject) {
    switch (subject) {
      case Subject.vocab:
        return '文字・語彙 (Vocabulary)';
      case Subject.grammar:
        return '文法 (Grammar)';
      case Subject.reading:
        return '読解 (Reading)';
      case Subject.listening:
        return '聴解 (Listening)';
      case null:
        return 'All Sections (မေးခွန်းအားလုံး)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final PastExamPracticeArgs args;
    final String title;
    final String? subtitle;

    if (widget.useGlobalFilter) {
      final level = ref.watch(selectedLevelProvider);
      final filter = ref.watch(pastExamFilterProvider);
      args = PastExamPracticeArgs(
        level: level,
        sessions: filter.selectedSessions,
        questionFrom: filter.questionFrom,
        questionTo: filter.questionTo,
        mondaiTypes: filter.selectedMondaiTypes,
      );
      if (filter.selectedMondaiTypes.length == 1) {
        final t = filter.selectedMondaiTypes.first;
        title = mondaiTypeLabel(t);
      } else if (filter.selectedMondaiTypes.length > 1) {
        title =
            'ရွေးချယ်ထားသော မေးခွန်းများ (${filter.selectedMondaiTypes.length} မျိုး)';
      } else {
        title = '$level စာမေးပွဲ မေးခွန်းအားလုံး';
      }
      subtitle = filter.selectedSessions.isNotEmpty
          ? '${filter.selectedSessions.join(", ")} ခုနှစ်'
          : '$level Past Exams';
    } else if (widget.mondaiType != null) {
      args = PastExamPracticeArgs(
        sourceId: widget.sourceId,
        mondaiTypes: {widget.mondaiType!},
      );
      title = mondaiTypeLabel(widget.mondaiType!);
      subtitle = mondaiTypeBurmeseDescription(widget.mondaiType!);
    } else if (widget.subject != null) {
      args = PastExamPracticeArgs(
        sourceId: widget.sourceId,
        subject: widget.subject,
      );
      title = _getSubjectLabel(widget.subject);
      subtitle = null;
    } else {
      final filter = ref.watch(pastExamFilterProvider);
      if (filter.selectedMondaiTypes.isNotEmpty) {
        args = PastExamPracticeArgs(
          sourceId: widget.sourceId,
          mondaiTypes: filter.selectedMondaiTypes,
        );
        title = filter.selectedMondaiTypes.length == 1
            ? mondaiTypeLabel(filter.selectedMondaiTypes.first)
            : 'ရွေးချယ်ထားသော မေးခွန်းများ (${filter.selectedMondaiTypes.length} မျိုး)';
        subtitle = null;
      } else {
        args = PastExamPracticeArgs(
          sourceId: widget.sourceId,
        );
        title = _getSubjectLabel(null);
        subtitle = null;
      }
    }

    final questionsAsync = ref.watch(pastExamPracticeQuestionsProvider(args));

    return Scaffold(
      endDrawer: !context.isMobile && questionsAsync.valueOrNull != null
          ? Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Text(
                        'မေးခွန်းရွေးချယ်ရန်',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Builder(
                        builder: (drawerContext) => _buildQuestionGrid(
                          drawerContext,
                          questionsAsync.valueOrNull!.length,
                          isDrawer: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              questionsAsync.valueOrNull != null
                  ? (subtitle != null
                      ? '$subtitle · စုစုပေါင်း ${questionsAsync.valueOrNull!.length} ပုဒ်'
                      : 'စုစုပေါင်း ${questionsAsync.valueOrNull!.length} ပုဒ်')
                  : (subtitle ?? ''),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSoft,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          if (!_isCompleted) ...[
            _buildTimerPill(context),
            const SizedBox(width: AppSpacing.xs),
            Builder(
              builder: (buttonContext) => IconButton(
                icon: const Icon(Icons.grid_view_rounded),
                onPressed: () {
                  if (questionsAsync.valueOrNull != null) {
                    if (context.isMobile) {
                      _showQuestionNavigationSheet(
                        context,
                        questionsAsync.valueOrNull!.length,
                      );
                    } else {
                      Scaffold.of(buttonContext).openEndDrawer();
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '✓ $_correctCount',
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '✗ $_wrongCount',
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
      body: AsyncValueView(
        value: questionsAsync,
        isEmpty: (questions) => questions.isEmpty,
        emptyMessage: 'ရွေးချယ်ထားသော မေးခွန်းများ ရှာမတွေ့ပါ။',
        data: (providerQuestions) {
          final questions = _filteredQuestions ?? providerQuestions;
          if (_isCompleted) {
            return _buildCompletionScreen(context, questions);
          }
          final currentQuestion = questions[_currentIndex];
          return _buildQuizContent(context, currentQuestion, questions.length);
        },
      ),
    );
  }

  Widget _buildQuizContent(
    BuildContext context,
    PastExamQuestion question,
    int totalQuestions,
  ) {
    final progress = (_currentIndex + 1) / totalQuestions;

    return Column(
      children: [
        // Top Progress Bar
        AppProgressBar(value: progress),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Question Header Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppPill(
                      label:
                          'မေးခွန်း ${_currentIndex + 1} / စုစုပေါင်း $totalQuestions ပုဒ်',
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    if (question.mondaiNo != null)
                      Text(
                        '問題 ${question.mondaiNo}: ${question.mondaiTypeNameJp}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSoft,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                  ],
                ),
                if (question.mondaiInstruction != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    question.mondaiInstruction!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSoft,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),

                // Passage Card (for reading / text grammar)
                if (question.passage != null &&
                    question.passage!.trim().isNotEmpty) ...[
                  _buildPassageCard(context, question.passage!),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Question Card
                _buildQuestionCard(context, question),
                const SizedBox(height: AppSpacing.lg),

                // 4 Choices
                ...question.choices.map(
                  (choice) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildChoiceButton(context, question, choice),
                  ),
                ),

                // Explanation & Next Button
                if (_answers.containsKey(_currentIndex)) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildExplanationCard(context, question, totalQuestions),
                ],
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassageCard(BuildContext context, String passage) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () =>
                setState(() => _isPassageExpanded = !_isPassageExpanded),
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.article_outlined,
                    size: 18,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.xs + 2),
                  Text(
                    'စာပိုဒ် (Passage)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                  ),
                  const Spacer(),
                  Icon(
                    _isPassageExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_isPassageExpanded) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SelectableText(
                passage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      fontSize: 14.5,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, PastExamQuestion question) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${question.questionNo ?? (_currentIndex + 1)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildQuestionContent(context, question),
              ),
            ],
          ),
          if (question.starPosition != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              '★ နေရာတွင် ဝင်ရမည့် အဖြေနံပါတ်ကို ရွေးချယ်ပါ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionContent(
    BuildContext context,
    PastExamQuestion question,
  ) {
    final baseStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.5,
          fontSize: 16.5,
        );

    final underlineStyle = baseStyle?.copyWith(
      decoration: TextDecoration.underline,
      decorationThickness: 2.2,
      decorationColor: AppColors.primary,
      fontWeight: FontWeight.bold,
    );

    final rawText = question.questionText;
    final targetWord = question.targetWord?.trim();

    // 1. If question is strictly just the target word (e.g., Mondai: Usage / 用法)
    if (targetWord != null &&
        targetWord.isNotEmpty &&
        rawText.trim() == targetWord) {
      return SelectableText(
        '【 $targetWord 】',
        style: baseStyle?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.primary,
        ),
      );
    }

    // 2. If targetWord is provided and present in text
    if (targetWord != null && targetWord.isNotEmpty) {
      final normalizedText = rawText
          .replaceAll('＿＿$targetWord＿＿', targetWord)
          .replaceAll('＿$targetWord＿', targetWord)
          .replaceAll('__${targetWord}__', targetWord)
          .replaceAll('_${targetWord}_', targetWord)
          .replaceAll('<u>$targetWord</u>', targetWord);

      if (normalizedText.contains(targetWord)) {
        final spans = <InlineSpan>[];
        int start = 0;
        int index = normalizedText.indexOf(targetWord, start);
        while (index != -1) {
          if (index > start) {
            spans.add(
              TextSpan(
                text: normalizedText.substring(start, index),
                style: baseStyle,
              ),
            );
          }
          spans.add(
            TextSpan(
              text: targetWord,
              style: underlineStyle,
            ),
          );
          start = index + targetWord.length;
          index = normalizedText.indexOf(targetWord, start);
        }
        if (start < normalizedText.length) {
          spans.add(
            TextSpan(
              text: normalizedText.substring(start),
              style: baseStyle,
            ),
          );
        }
        return SelectableText.rich(
          TextSpan(children: spans),
        );
      }
    }

    // 3. Fallback: Parse <u>...</u> or ＿＿word＿＿ if targetWord was not set
    final uTagRegex = RegExp(r'<u>(.*?)</u>');
    if (uTagRegex.hasMatch(rawText)) {
      final spans = <InlineSpan>[];
      int lastMatchEnd = 0;
      for (final match in uTagRegex.allMatches(rawText)) {
        if (match.start > lastMatchEnd) {
          spans.add(
            TextSpan(
              text: rawText.substring(lastMatchEnd, match.start),
              style: baseStyle,
            ),
          );
        }
        spans.add(
          TextSpan(
            text: match.group(1),
            style: underlineStyle,
          ),
        );
        lastMatchEnd = match.end;
      }
      if (lastMatchEnd < rawText.length) {
        spans.add(
          TextSpan(
            text: rawText.substring(lastMatchEnd),
            style: baseStyle,
          ),
        );
      }
      return SelectableText.rich(TextSpan(children: spans));
    }

    final underscoreRegex = RegExp(r'＿＿([^\s＿★]+)＿＿');
    if (underscoreRegex.hasMatch(rawText)) {
      final spans = <InlineSpan>[];
      int lastMatchEnd = 0;
      for (final match in underscoreRegex.allMatches(rawText)) {
        if (match.start > lastMatchEnd) {
          spans.add(
            TextSpan(
              text: rawText.substring(lastMatchEnd, match.start),
              style: baseStyle,
            ),
          );
        }
        spans.add(
          TextSpan(
            text: match.group(1),
            style: underlineStyle,
          ),
        );
        lastMatchEnd = match.end;
      }
      if (lastMatchEnd < rawText.length) {
        spans.add(
          TextSpan(
            text: rawText.substring(lastMatchEnd),
            style: baseStyle,
          ),
        );
      }
      return SelectableText.rich(TextSpan(children: spans));
    }

    // 4. Default plain text rendering (e.g. sentence order with blanks)
    return SelectableText(
      rawText,
      style: baseStyle,
    );
  }

  Widget _buildChoiceButton(
    BuildContext context,
    PastExamQuestion question,
    PastExamChoice choice,
  ) {
    final isSelected = _answers[_currentIndex] == choice.position;
    final isCorrect = choice.isCorrect;

    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.divider;
    Color textColor = AppColors.text;
    IconData? statusIcon;

    if (_answers.containsKey(_currentIndex)) {
      if (isCorrect) {
        bgColor = AppColors.secondary.withValues(alpha: 0.12);
        borderColor = AppColors.secondary;
        textColor = AppColors.secondary;
        statusIcon = Icons.check_circle_rounded;
      } else if (isSelected) {
        bgColor = AppColors.error.withValues(alpha: 0.12);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        statusIcon = Icons.cancel_rounded;
      } else {
        textColor = AppColors.textSoft;
      }
    }

    return InkWell(
      onTap: _answers.containsKey(_currentIndex)
          ? null
          : () => _onOptionSelected(question, choice.position),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: borderColor,
            width:
                isSelected || (_answers.containsKey(_currentIndex) && isCorrect)
                    ? 2
                    : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: borderColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${choice.position}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                choice.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ||
                          (_answers.containsKey(_currentIndex) && isCorrect)
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
            if (statusIcon != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(statusIcon, color: textColor, size: 22),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(
    BuildContext context,
    PastExamQuestion question,
    int totalQuestions,
  ) {
    final isCorrect = _answers[_currentIndex] == question.correctPosition;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.secondary.withValues(alpha: 0.08)
            : AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isCorrect
              ? AppColors.secondary.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.error_outline,
                color: isCorrect ? AppColors.secondary : AppColors.error,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isCorrect ? 'မှန်ကန်ပါသည်!' : 'မှားယွင်းပါသည်!',
                style: TextStyle(
                  color: isCorrect ? AppColors.secondary : AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                'အမှန်: နံပါတ် (${question.correctPosition})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (question.explanation != null &&
              question.explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'ရှင်းလင်းချက် (Explanation):',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            SelectableText(
              question.explanation!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 14,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: () => _nextQuestion(totalQuestions),
            icon: Icon(
              _currentIndex + 1 >= totalQuestions
                  ? Icons.assignment_turned_in_rounded
                  : Icons.arrow_forward_rounded,
            ),
            label: Text(
              _currentIndex + 1 >= totalQuestions
                  ? 'ရလဒ်ကြည့်မည် (Finish)'
                  : 'နောက်တစ်ပုဒ် (Next Question)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(
    BuildContext context,
    List<PastExamQuestion> questions,
  ) {
    final totalQuestions = questions.length;
    final percentage = totalQuestions > 0
        ? ((_correctCount / totalQuestions) * 100).round()
        : 0;
    final isPassed = percentage >= 60;

    // ── Analytics Calculation ──────────────────────────────────────────────
    // 1. Group by Subject
    final Map<Subject, ({int correct, int total})> subjectStats = {};
    // 2. Group by MondaiType
    final Map<MondaiType, ({int correct, int total})> mondaiStats = {};

    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      final isCorrect = _correctness[i] ?? false;

      // Subject stats
      final prevSubject = subjectStats[q.subject] ?? (correct: 0, total: 0);
      subjectStats[q.subject] = (
        correct: prevSubject.correct + (isCorrect ? 1 : 0),
        total: prevSubject.total + 1,
      );

      // Mondai stats
      final prevMondai = mondaiStats[q.mondaiType] ?? (correct: 0, total: 0);
      mondaiStats[q.mondaiType] = (
        correct: prevMondai.correct + (isCorrect ? 1 : 0),
        total: prevMondai.total + 1,
      );
    }

    // Identify weak Mondais (accuracy < 60%)
    final List<MapEntry<MondaiType, ({int correct, int total})>> weakMondais =
        mondaiStats.entries.where((e) {
      if (e.value.total == 0) return false;
      return (e.value.correct / e.value.total) < 0.6;
    }).toList()
          ..sort(
            (a, b) => (a.value.correct / a.value.total)
                .compareTo(b.value.correct / b.value.total),
          );

    final weakMondaiTypes = weakMondais.map((e) => e.key).toSet();
    final weakQuestionsCount =
        questions.where((q) => weakMondaiTypes.contains(q.mondaiType)).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          // ── 1. Result Header Card ─────────────────────────────────────────
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isPassed ? AppColors.secondary : AppColors.error)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPassed
                        ? Icons.emoji_events_rounded
                        : Icons.psychology_alt_rounded,
                    color: isPassed ? AppColors.secondary : AppColors.error,
                    size: 48,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isPassed
                      ? 'ဂုဏ်ယူပါသည်! အောင်မှတ်ရရှိပါသည်'
                      : 'လေ့ကျင့်မှု ပြီးဆုံးပါပြီ (ထပ်မံကြိုးစားပါ)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getSubjectLabel(widget.subject),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSoft,
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w800,
                    color: isPassed ? AppColors.secondary : AppColors.error,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Key metrics row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatBadge(
                      label: 'ကြာမြင့်ချိန်',
                      countStr: _formatDuration(_secondsElapsed),
                      color: AppColors.primary,
                      icon: Icons.timer_outlined,
                    ),
                    _buildStatBadge(
                      label: 'အမှန်',
                      countStr: '$_correctCount',
                      color: AppColors.secondary,
                      icon: Icons.check_circle_rounded,
                    ),
                    _buildStatBadge(
                      label: 'အမှား',
                      countStr: '$_wrongCount',
                      color: AppColors.error,
                      icon: Icons.cancel_rounded,
                    ),
                    _buildStatBadge(
                      label: 'စုစုပေါင်း',
                      countStr: '$totalQuestions',
                      color: AppColors.textSoft,
                      icon: Icons.format_list_numbered_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── 2. Subject Breakdown Card (ဘာသာရပ်အလိုက် စွမ်းဆောင်ရည်) ─────────
          if (subjectStats.length > 1) ...[
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.donut_small_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'ဘာသာရပ်အလိုက် စွမ်းဆောင်ရည် (Subject Breakdown)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final entry in subjectStats.entries) ...[
                    Builder(
                      builder: (context) {
                        final subRatio = entry.value.total > 0
                            ? entry.value.correct / entry.value.total
                            : 0.0;
                        final subPct = (subRatio * 100).round();
                        final isSubPass = subPct >= 60;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _getSubjectLabel(entry.key),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${entry.value.correct}/${entry.value.total} ($subPct%)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSubPass
                                          ? AppColors.secondary
                                          : AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              AppProgressBar(
                                value: subRatio,
                                color: isSubPass
                                    ? AppColors.secondary
                                    : AppColors.error,
                                height: 5,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // ── 3. Weakness Analysis Card (⚠️ အားနည်းချက် သုံးသပ်ချက်) ─────────
          if (weakMondais.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E7),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFB78103),
                        size: 20,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        'အားနည်းချက် သုံးသပ်ချက် (Weakness Insights)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A5400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'အောက်ပါ မေးခွန်းအပိုင်းများတွင် အမှတ်ရနည်းနေသဖြင့် ထပ်မံလေ့ကျင့်ရန် လိုအပ်ပါသည်:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8D6200),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: weakMondais.map((entry) {
                      final acc = ((entry.value.correct / entry.value.total) * 100).round();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: const Color(0xFFFFD54F)),
                        ),
                        child: Text(
                          '${mondaiTypeShortLabel(entry.key)}: ${entry.value.correct}/${entry.value.total} ($acc%)',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9E6600),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // ── 4. Detailed Mondai Breakdown (မေးခွန်း အမျိုးအစားအလိုက်) ───────
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.analytics_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'မေးခွန်း အမျိုးအစားအလိုက် အမှတ်စာရင်း',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final entry in mondaiStats.entries) ...[
                  Builder(
                    builder: (context) {
                      final mRatio = entry.value.total > 0
                          ? entry.value.correct / entry.value.total
                          : 0.0;
                      final mPct = (mRatio * 100).round();
                      final isMPass = mPct >= 60;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mondaiTypeLabel(entry.key),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    mondaiTypeBurmeseDescription(entry.key),
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: AppColors.textSoft,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: (isMPass
                                        ? AppColors.secondary
                                        : AppColors.error)
                                    .withValues(alpha: 0.12),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                '${entry.value.correct}/${entry.value.total} ($mPct%)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isMPass
                                      ? AppColors.secondary
                                      : AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (entry.key != mondaiStats.keys.last)
                    const Divider(height: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── 5. Action Buttons ─────────────────────────────────────────────
          if (weakMondais.isNotEmpty && weakQuestionsCount > 0) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _retryWeakOnly(questions, weakMondaiTypes),
                icon: const Icon(Icons.gps_fixed_rounded, size: 18),
                label: Text(
                  'အားနည်းသည့် အပိုင်းများသာ သီးသန့်ပြန်ဖြေမည် ($weakQuestionsCount ပုဒ်)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (_wrongCount > 0) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => _retryWrongOnly(questions),
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: Text(
                  'မှားခဲ့သည့်များ ပြန်ဖြေမည် ($_wrongCount ပုဒ်)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _restartQuiz,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('အားလုံး ပြန်လည်ဖြေဆိုမည် (Retry All)'),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('မေးခွန်းဟောင်း စာရင်းသို့ ပြန်သွားမည်'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required String label,
    required String countStr,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 2),
        Text(
          countStr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
