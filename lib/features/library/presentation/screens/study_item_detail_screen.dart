import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_janpanese/core/constants/app_radius.dart';
import 'package:practice_janpanese/core/constants/app_spacing.dart';
import 'package:practice_janpanese/core/theme/app_colors.dart';
import 'package:practice_janpanese/features/library/domain/content_kind.dart';
import 'package:practice_janpanese/features/library/domain/study_item.dart';
import 'package:practice_janpanese/features/library/presentation/providers/library_providers.dart';

/// Clean, classic detail view for study items with Next / Previous navigation.
class StudyItemDetailScreen extends ConsumerStatefulWidget {
  const StudyItemDetailScreen({
    super.key,
    required this.items,
    required this.initialIndex,
    required this.kind,
    this.title,
  });

  final List<StudyItem> items;
  final int initialIndex;
  final ContentKind kind;
  final String? title;

  @override
  ConsumerState<StudyItemDetailScreen> createState() =>
      _StudyItemDetailScreenState();
}

class _StudyItemDetailScreenState extends ConsumerState<StudyItemDetailScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  late List<StudyItem> _items;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _items = List.of(widget.items);
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPrevious() {
    if (_currentIndex > 0) {
      unawaited(
        _pageController.previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      unawaited(
        _pageController.nextPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        ),
      );
    }
  }

  Future<void> _toggleBookmark(StudyItem item) async {
    unawaited(HapticFeedback.lightImpact());
    final repo = ref.read(libraryRepositoryProvider);
    final isNow = await repo.toggleBookmark(
      kind: widget.kind,
      itemId: item.id,
    );

    setState(() {
      _items[_currentIndex] = item.copyWith(isBookmarked: isNow);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNow
                ? '"${item.primary}" ကို မေ့လွယ်သောစာရင်းထဲ ထည့်လိုက်ပါပြီ'
                : '"${item.primary}" ကို မေ့လွယ်သောစာရင်းမှ ဖယ်ထုတ်လိုက်ပါပြီ',
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title ?? 'အသေးစိတ်')),
        body: const Center(child: Text('အချက်အလက် မရှိပါ')),
      );
    }

    final currentItem = _items[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? widget.kind.label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Text(
              '${_currentIndex + 1} / ${_items.length}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSoft,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: currentItem.isBookmarked
                ? 'မေ့လွယ်သောစာရင်းမှ ဖယ်ထုတ်မည်'
                : 'မေ့လွယ်သောစာရင်းထဲ ထည့်မည်',
            icon: Icon(
              currentItem.isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: currentItem.isBookmarked
                  ? Colors.amber.shade700
                  : AppColors.textSoft,
              size: 24,
            ),
            onPressed: () => _toggleBookmark(currentItem),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _items.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final item = _items[index];
          return _buildItemDetailCard(context, item, index);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildItemDetailCard(
    BuildContext context,
    StudyItem item,
    int index,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.sm,
        AppSpacing.screenH,
        AppSpacing.lg,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top badges row (Order & Kind)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    widget.kind.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
                const Spacer(),
                if (item.isBookmarked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Colors.amber.shade800,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'မေ့လွယ်',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Hero Section: Reading & Primary Word
            Center(
              child: Column(
                children: [
                  // Reading / Secondary
                  if (item.secondary != null && item.secondary!.isNotEmpty) ...[
                    if (item.secondary!.contains('音読み:') ||
                        item.secondary!.contains('訓読み:')) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: [
                          for (final line in item.secondary!.split('\n'))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: line.startsWith('音読み:')
                                    ? AppColors.primarySoft
                                    : const Color(0xFFE0F2FE),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    line.startsWith('音読み:') ? '音' : '訓',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: line.startsWith('音読み:')
                                          ? AppColors.primary
                                          : const Color(0xFF0284C7),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    line
                                        .substring(line.indexOf(':') + 1)
                                        .trim(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: line.startsWith('音読み:')
                                          ? AppColors.primary
                                          : const Color(0xFF0369A1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ] else
                      Text(
                        item.secondary!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    const SizedBox(height: 6),
                  ],

                  // Main Expression
                  SelectableText(
                    item.primary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            // Burmese Meaning Section
            if (item.meaning != null && item.meaning!.isNotEmpty) ...[
              const Text(
                'မြန်မာအဓိပ္ပာယ်',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  item.meaning!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Connection (Grammar pattern)
            if (item.connection != null && item.connection!.isNotEmpty) ...[
              const Text(
                'သဒ္ဒါချိတ်ဆက်ပုံ (Connection)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  item.connection!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Example Sentence
            if (item.exampleJp != null && item.exampleJp!.isNotEmpty) ...[
              const Text(
                'ဥပမာ ဝါကျ (Example)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSoft,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '例文',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            item.exampleJp!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (item.exampleMy != null &&
                        item.exampleMy!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text(
                          item.exampleMy!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSoft,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final canPrev = _currentIndex > 0;
    final canNext = _currentIndex < _items.length - 1;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.divider)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: canPrev ? AppColors.primary : AppColors.divider,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  onPressed: canPrev ? _onPrevious : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text(
                    'ရှေ့သို့',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SizedBox(
                height: 46,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  onPressed: canNext ? _onNext : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text(
                    'နောက်သို့',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
