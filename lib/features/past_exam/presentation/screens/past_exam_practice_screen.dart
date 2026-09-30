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
import 'package:practice_janpanese/features/past_exam/domain/past_exam_question.dart';
import 'package:practice_janpanese/features/past_exam/presentation/providers/past_exam_providers.dart';

/// Interactive practice screen for JLPT Past Exam questions.
class PastExamPracticeScreen extends ConsumerStatefulWidget {
  const PastExamPracticeScreen({
    super.key,
    required this.sourceId,
    this.subject,
  });

  final int sourceId;
  final Subject? subject;

  @override
  ConsumerState<PastExamPracticeScreen> createState() =>
      _PastExamPracticeScreenState();
}

class _PastExamPracticeScreenState
    extends ConsumerState<PastExamPracticeScreen> {
  int _currentIndex = 0;
  int? _selectedPosition;
  bool _hasAnswered = false;
  int _correctCount = 0;
  int _wrongCount = 0;
  bool _isCompleted = false;
  bool _isPassageExpanded = true;

  void _onOptionSelected(PastExamQuestion question, int position) {
    if (_hasAnswered) return;

    final isCorrect = position == question.correctPosition;
    setState(() {
      _selectedPosition = position;
      _hasAnswered = true;
      if (isCorrect) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    });
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentIndex + 1 >= totalQuestions) {
      setState(() => _isCompleted = true);
    } else {
      setState(() {
        _currentIndex++;
        _selectedPosition = null;
        _hasAnswered = false;
        _isPassageExpanded = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedPosition = null;
      _hasAnswered = false;
      _correctCount = 0;
      _wrongCount = 0;
      _isCompleted = false;
      _isPassageExpanded = true;
    });
  }

  String _getSubjectLabel(Subject? subject) {
    switch (subject) {
      case Subject.vocab:
        return '文字・語彙';
      case Subject.grammar:
        return '文法';
      case Subject.reading:
        return '読解';
      case Subject.listening:
        return '聴解';
      case null:
        return 'All Sections (မေးခွန်းအားလုံး)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = (sourceId: widget.sourceId, subject: widget.subject);
    final questionsAsync = ref.watch(pastExamQuestionsProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: Text(_getSubjectLabel(widget.subject)),
        actions: [
          if (!_isCompleted)
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
      ),
      body: AsyncValueView(
        value: questionsAsync,
        isEmpty: (questions) => questions.isEmpty,
        emptyMessage: 'မေးခွန်းများ ရှာမတွေ့ပါ။',
        data: (questions) {
          if (_isCompleted) {
            return _buildCompletionScreen(context, questions.length);
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
                          'Q ${question.questionNo ?? (_currentIndex + 1)} / $totalQuestions',
                      color: AppColors.primary,
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
                if (_hasAnswered) ...[
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
    final isSelected = _selectedPosition == choice.position;
    final isCorrect = choice.isCorrect;

    Color bgColor = AppColors.surface;
    Color borderColor = AppColors.divider;
    Color textColor = AppColors.text;
    IconData? statusIcon;

    if (_hasAnswered) {
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
      onTap: _hasAnswered
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
            width: isSelected || (_hasAnswered && isCorrect) ? 2 : 1,
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
                  fontWeight: isSelected || (_hasAnswered && isCorrect)
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
    final isCorrect = _selectedPosition == question.correctPosition;

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

  Widget _buildCompletionScreen(BuildContext context, int totalQuestions) {
    final percentage = totalQuestions > 0
        ? ((_correctCount / totalQuestions) * 100).round()
        : 0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.accent,
                  size: 56,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'လေ့ကျင့်မှု ပြီးဆုံးပါပြီ!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _getSubjectLabel(widget.subject),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSoft,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: percentage >= 60
                          ? AppColors.secondary
                          : AppColors.error,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatBadge(
                    label: 'မှန်',
                    count: _correctCount,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _buildStatBadge(
                    label: 'မှား',
                    count: _wrongCount,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  _buildStatBadge(
                    label: 'စုစုပေါင်း',
                    count: totalQuestions,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _restartQuiz,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('ပြန်လည်ဖြေဆိုမည် (Retry)'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('မေးခွန်းဟောင်း စာရင်းသို့'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge({
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
