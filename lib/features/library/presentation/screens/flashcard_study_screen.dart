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

/// Interactive Flashcard study screen supporting Section-level and Chapter-level review.
class FlashcardStudyScreen extends ConsumerStatefulWidget {
  const FlashcardStudyScreen({
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
  ConsumerState<FlashcardStudyScreen> createState() =>
      _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends ConsumerState<FlashcardStudyScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  int _currentIndex = 0;
  bool _isFlipped = false;
  bool _showReadingHint = false;
  late bool _isShuffled = widget.isRandom;
  bool _isCompleted = false;

  int _rememberedCount = 0;
  int _needsReviewCount = 0;

  List<StudyItem>? _activeDeck;
  List<StudyItem>? _originalDeck;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _syncDeck(List<StudyItem> items) {
    if (_originalDeck == null) {
      var deck = List.of(items);
      if (widget.questionLimit != null &&
          widget.questionLimit! > 0 &&
          widget.questionLimit! < deck.length) {
        deck.shuffle(math.Random());
        deck = deck.take(widget.questionLimit!).toList();
      }
      _originalDeck = deck;
      _activeDeck =
          _isShuffled ? (List.of(deck)..shuffle(math.Random())) : List.of(deck);
      _currentIndex = 0;
      _isFlipped = false;
      _showReadingHint = false;
      _isCompleted = deck.isEmpty;
      _rememberedCount = 0;
      _needsReviewCount = 0;
    }
  }

  void _toggleFlip() {
    if (_isFlipped) {
      _flipController.reverse();
      setState(() => _isFlipped = false);
    } else {
      _flipController.forward();
      setState(() => _isFlipped = true);
    }
  }

  void _toggleShuffle() {
    if (_originalDeck == null) return;
    setState(() {
      _isShuffled = !_isShuffled;
      if (_isShuffled) {
        _activeDeck = List.of(_originalDeck!)..shuffle(math.Random());
      } else {
        _activeDeck = List.of(_originalDeck!);
      }
      _currentIndex = 0;
      _isFlipped = false;
      _showReadingHint = false;
      _isCompleted = false;
      _rememberedCount = 0;
      _needsReviewCount = 0;
      _flipController.reset();
    });
  }

  void _restartDeck() {
    setState(() {
      _currentIndex = 0;
      _isFlipped = false;
      _showReadingHint = false;
      _isCompleted = false;
      _rememberedCount = 0;
      _needsReviewCount = 0;
      _originalDeck = null;
      _activeDeck = null;
      _flipController.reset();
    });
  }

  Widget _buildCardGrid(BuildContext context, int deckLength, {bool isDrawer = false}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(deckLength, (index) {
          final isCurrent = index == _currentIndex;
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              if (_isFlipped) _flipController.reverse();
              setState(() {
                _currentIndex = index;
                _isFlipped = false;
                _showReadingHint = false;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.primary
                    : AppColors.surface,
                border: Border.all(
                  color: isCurrent
                      ? AppColors.primary
                      : AppColors.divider,
                  width: isCurrent ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrent ? Colors.white : AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showCardSelector(BuildContext context, int deckLength) {
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
                'ကတ်ရွေးရန်',
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
                child: _buildCardGrid(sheetContext, deckLength),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEndDrawer(BuildContext context, int deckLength) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'ကတ်ရွေးရန်',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Builder(
                builder: (drawerContext) => _buildCardGrid(drawerContext, deckLength, isDrawer: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _answerCard(bool remembered) async {
    if (_activeDeck == null || _activeDeck!.isEmpty) return;

    final currentItem = _activeDeck![_currentIndex];

    // Record review in database
    final repo = ref.read(libraryRepositoryProvider);
    await repo.recordReview(
      kind: widget.kind,
      itemId: currentItem.id,
      remembered: remembered,
    );

    if (remembered) {
      _rememberedCount++;
    } else {
      _needsReviewCount++;
    }

    if (_currentIndex + 1 >= _activeDeck!.length) {
      setState(() {
        _isCompleted = true;
      });
    } else {
      if (_isFlipped) {
        await _flipController.reverse();
      }
      setState(() {
        _currentIndex++;
        _isFlipped = false;
        _showReadingHint = false;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      if (_isFlipped) {
        _flipController.reverse();
      }
      setState(() {
        _currentIndex--;
        _isFlipped = false;
        _showReadingHint = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveChapters = widget.chapterNumbers ??
        (widget.chapterNumber != null ? [widget.chapterNumber!] : null);

    // Watch items from appropriate provider
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

    // Watch source title or unit name for header
    final sourceAsync = ref.watch(sourceProvider(widget.sourceId));
    final unitAsync =
        widget.unitId != null ? ref.watch(unitProvider(widget.unitId!)) : null;

    final String screenTitle;
    if (widget.unitId != null) {
      screenTitle = unitAsync?.value?.name ?? widget.kind.label;
    } else {
      final chLabel = (effectiveChapters == null || effectiveChapters.isEmpty)
          ? 'All Chapters'
          : (effectiveChapters.length == 1
              ? 'Chapter ${effectiveChapters.first}'
              : 'Chapters ${effectiveChapters.join(", ")}');
      final limitLabel =
          widget.questionLimit != null ? ' (${widget.questionLimit} ခု)' : '';
      screenTitle = '${sourceAsync.value?.name ?? ''} · $chLabel$limitLabel';
    }

    // Get active deck length early to pass to endDrawer if needed
    final int activeDeckLength;
    if (_activeDeck != null) {
      activeDeckLength = _activeDeck!.length;
    } else if (itemsAsync.valueOrNull != null) {
      activeDeckLength = widget.questionLimit != null && widget.questionLimit! > 0 && widget.questionLimit! < itemsAsync.valueOrNull!.length 
          ? widget.questionLimit! 
          : itemsAsync.valueOrNull!.length;
    } else {
      activeDeckLength = 0;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: activeDeckLength > 0 ? _buildEndDrawer(context, activeDeckLength) : null,
      appBar: AppBar(
        title: Text(
          screenTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        actions: [
          IconButton(
            tooltip: 'ကတ်ရွေးရန်',
            icon: const Icon(Icons.grid_view_rounded, color: AppColors.textSoft),
            onPressed: () {
              if (activeDeckLength == 0) return;
              final isDesktop = MediaQuery.sizeOf(context).width >= 600;
              if (isDesktop) {
                _scaffoldKey.currentState?.openEndDrawer();
              } else {
                _showCardSelector(context, activeDeckLength);
              }
            },
          ),
          IconButton(
            tooltip:
                _isShuffled ? AppStrings.orderedDeck : AppStrings.shuffleDeck,
            icon: Icon(
              Icons.shuffle_rounded,
              color: _isShuffled ? AppColors.secondary : AppColors.textSoft,
            ),
            onPressed: _toggleShuffle,
          ),
          IconButton(
            tooltip: AppStrings.restartDeck,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textSoft,
            ),
            onPressed: _restartDeck,
          ),
        ],
      ),
      body: AsyncValueView<List<StudyItem>>(
        value: itemsAsync,
        isEmpty: (items) => items.isEmpty,
        emptyMessage: AppStrings.itemsCount(0),
        data: (items) {
          _syncDeck(items);
          final deck = _activeDeck ?? items;
          if (deck.isEmpty) {
            return Center(
              child: Text(
                AppStrings.itemsCount(0),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          if (_isCompleted) {
            return _buildCompletionView(context, deck.length);
          }

          final currentItem = deck[_currentIndex];
          final progressRatio = (_currentIndex + 1) / deck.length;

          return SafeArea(
            child: Column(
              children: [
                // Top Progress indicator
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
                            'Card ${_currentIndex + 1} of ${deck.length}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSoft,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Text(
                            '${(progressRatio * 100).toInt()}%',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppProgressBar(value: progressRatio),
                    ],
                  ),
                ),

                // Main Flashcard Area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenH,
                      vertical: AppSpacing.md,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _toggleFlip,
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity != null &&
                              details.primaryVelocity! > 200) {
                            _previousCard();
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            final angle = _flipAnimation.value * math.pi;
                            final isUnder = _flipAnimation.value >= 0.5;

                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isUnder
                                  ? Transform(
                                      transform: Matrix4.identity()
                                        ..rotateY(math.pi),
                                      alignment: Alignment.center,
                                      child: _buildBackCard(
                                        context,
                                        currentItem,
                                        _currentIndex + 1,
                                        deck.length,
                                      ),
                                    )
                                  : _buildFrontCard(
                                      context,
                                      currentItem,
                                      _currentIndex + 1,
                                      deck.length,
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Action Controls
                _buildActionControls(context),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Front face of the card showing the Japanese word/kanji with optional reading hint.
  Widget _buildFrontCard(
    BuildContext context,
    StudyItem item,
    int index,
    int total,
  ) {
    return AppCard(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 340),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppPill(
                  label: widget.kind.label,
                  color: AppColors.levelSoft('N3'),
                  textColor: AppColors.primary,
                ),
                if (item.isMastered)
                  const AppPill(
                    label: '✓ တတ်ပြီး',
                    color: Color(0xFFD8F3DC),
                    textColor: AppColors.secondary,
                  )
                else if (item.streak > 0)
                  AppPill(
                    label: '🔥 Streak ${item.streak}',
                    color: const Color(0xFFFDE2E4),
                    textColor: AppColors.accent,
                  ),
                Text(
                  '$index / $total',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSoft,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            // Center Japanese Word & Reading Reveal
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.secondary != null && item.secondary!.isNotEmpty) ...[
                  if (_showReadingHint)
                    _buildReadingsDisplay(context, item.secondary!)
                  else
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        setState(() => _showReadingHint = true);
                      },
                      icon: const Icon(
                        Icons.visibility_outlined,
                        size: 16,
                        color: AppColors.textSoft,
                      ),
                      label: Text(
                        AppStrings.revealReading,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSoft,
                            ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(
                  item.primary,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                        fontSize: 40,
                      ),
                ),
              ],
            ),

            // Bottom flip hint
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: AppColors.textSoft,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    AppStrings.flipCardHint,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSoft,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Back face of the card showing the meaning, reading, and usage.
  Widget _buildBackCard(
    BuildContext context,
    StudyItem item,
    int index,
    int total,
  ) {
    return AppCard(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 340),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: AppColors.primaryLight.withAlpha(50),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppPill(
                  label: 'အဓိပ္ပာယ်',
                  color: AppColors.primarySoft,
                  textColor: AppColors.primary,
                ),
                Text(
                  '$index / $total',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSoft,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            // Word, Reading & Burmese Meaning
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.primary,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                      ),
                      if (item.secondary != null &&
                          item.secondary!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        _buildReadingsDisplay(context, item.secondary!),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Divider(color: AppColors.divider, height: 1),
                      ),
                      if (item.meaning != null && item.meaning!.isNotEmpty)
                        Text(
                          item.meaning!,
                          textAlign: item.meaning!.contains('\n')
                              ? TextAlign.start
                              : TextAlign.center,
                          style: item.meaning!.contains('\n')
                              ? Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  )
                              : Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                  ),
                        ),
                      if (item.connection != null &&
                          item.connection!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            item.connection!,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSoft,
                                    ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Tap to flip back hint
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.flip_to_front_rounded,
                  size: 14,
                  color: AppColors.textSoft,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  AppStrings.tapToFlipBack,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSoft,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Displays readings with line-by-line distinction for Onyomi and Kunyomi when available.
  Widget _buildReadingsDisplay(BuildContext context, String secondary) {
    if (!secondary.contains('音読み:') && !secondary.contains('訓読み:')) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          secondary,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
    }

    final lines = secondary.split('\n');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: lines.map((line) {
        final isOnyomi = line.startsWith('音読み:');
        final isKunyomi = line.startsWith('訓読み:');
        final label = isOnyomi
            ? '音読み'
            : isKunyomi
                ? '訓読み'
                : '';
        final value = line.contains(':')
            ? line.substring(line.indexOf(':') + 1).trim()
            : line;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (label.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isOnyomi
                        ? AppColors.primarySoft
                        : const Color(0xFFE8F4F8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isOnyomi
                          ? AppColors.primary
                          : const Color(0xFF0077B6),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Action buttons at the bottom: Don't Know, Flip, Know.
  Widget _buildActionControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: [
          if (_currentIndex > 0) ...[
            IconButton(
              tooltip: AppStrings.back,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.textSoft,
              ),
              onPressed: _previousCard,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          // Don't Know Button
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                onPressed: () => _answerCard(false),
                icon: const Icon(Icons.close_rounded),
                label: const Text(
                  AppStrings.dontKnow,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Flip Button
          InkWell(
            onTap: _toggleFlip,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.flip_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Know / Remembered Button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                onPressed: () => _answerCard(true),
                icon: const Icon(Icons.check_rounded),
                label: const Text(
                  AppStrings.know,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Completion summary view when user completes all cards in the deck.
  Widget _buildCompletionView(BuildContext context, int totalCards) {
    final masteryPercentage =
        totalCards == 0 ? 0 : ((_rememberedCount / totalCards) * 100).toInt();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: AppCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '🎉',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.completedDeckTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.completedDeckSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSoft,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Statistics row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        context,
                        label: 'စုစုပေါင်း',
                        value: '$totalCards',
                        color: AppColors.primary,
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: AppColors.divider,
                      ),
                      _buildStatColumn(
                        context,
                        label: AppStrings.know,
                        value: '$_rememberedCount',
                        color: AppColors.secondary,
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: AppColors.divider,
                      ),
                      _buildStatColumn(
                        context,
                        label: AppStrings.dontKnow,
                        value: '$_needsReviewCount',
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'တိကျမှု: $masteryPercentage%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Action buttons
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
                    onPressed: _restartDeck,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(
                      AppStrings.restartDeck,
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
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSoft,
              ),
        ),
      ],
    );
  }
}
