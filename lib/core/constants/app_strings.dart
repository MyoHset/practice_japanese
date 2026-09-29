// ignore_for_file: avoid_classes_with_only_static_members

/// All user-facing strings in Burmese-first order.
/// Japanese terms remain Japanese. No literal strings in widgets.
class AppStrings {
  // ── App ──────────────────────────────────────────────────────────────────
  static const String appTitle = 'JLPT လေ့ကျင့်ရေး';
  static const String homeGreeting = '今日もがんばろう 🎌';
  static const String homeSubtitle = 'ဒီနေ့လည်း ဂပန်စာ လေ့ကျင့်ကြစို့';

  // ── Level ─────────────────────────────────────────────────────────────────
  static const String selectLevel = 'Level ရွေးပါ';
  static const String changeLevel = 'Level ပြောင်းရန်';

  // ── Review ────────────────────────────────────────────────────────────────
  static const String reviewToday = 'ဒီနေ့ ပြန်လေ့လာမည်';
  static const String reviewNone = 'ဒီနေ့ ပြန်လေ့လာစရာ မရှိပါ ✓';
  static String reviewCount(int n) => 'ဒီနေ့ $n ခု ပြန်လေ့လာပါ';

  // ── Categories ────────────────────────────────────────────────────────────
  static String levelCategories(String level) => '$level လေ့ကျင့်ခန်းများ';
  static const String categoryKanji = '漢字';
  static const String categoryKanjiSub = 'စာလုံးများ';
  static const String categoryVocab = '語彙';
  static const String categoryVocabSub = 'ဝေါဟာရများ';
  static const String categoryGrammar = '文法';
  static const String categoryGrammarSub = 'သဒ္ဒါစည်းမျဉ်းများ';
  static const String categoryPastExam = '過去問';
  static const String categoryPastExamSub = 'စာမေးပွဲဟောင်းများ';

  // ── Lists ──────────────────────────────────────────────────────────────────
  static const String sourcesEmpty = 'စာအုပ်/စာမေးပွဲ မရှိသေးပါ';
  static const String unitsEmpty = 'Unit မရှိသေးပါ';
  static String itemsCount(int n) => '$n ခု';
  static String masteredCount(int n) => '$n တတ်ပြီ';

  // ── Study modes ───────────────────────────────────────────────────────────
  static const String modeList = 'List';
  static const String modeQuick = 'Quick Quiz';
  static const String modeFlashcard = 'Flashcard';
  static const String modeListHint = 'အားလုံးကြည့်ပြီး လေ့လာပါ';
  static const String modeQuickHint = 'ရွေးချယ်ခွင့် ၄ ခုဖြင့် ဖြေဆိုပါ';
  static const String modeFlashcardHint = 'ကတ်ပြားဖြင့် ကျက်မှတ်ပါ';

  // ── General ───────────────────────────────────────────────────────────────
  static const String comingSoon = 'မကြာမီ လာမည်…';
  static const String comingSoonSubtitle =
      'ဒီ Feature ကို မကြာမီ ထည့်သွင်းပေးမည်';
  static const String retry = 'ထပ်ကြိုးစားပါ';
  static const String errorGeneric = 'တစ်ခုခုမှားနေသည်';
  static const String back = 'နောက်သို့';
  static const String units = 'Units';
  static const String sources = 'စာအုပ်များ';
  static const String pastExam = 'Past Exam';
  static const String levels = 'Level';
  static const String allLevels = 'N5–N1';

  // ── Level labels ─────────────────────────────────────────────────────────
  static const String levelN5 = 'N5 入門';
  static const String levelN4 = 'N4 初級';
  static const String levelN3 = 'N3 中級';
  static const String levelN2 = 'N2 中上級';
  static const String levelN1 = 'N1 上級';

  static String levelLabel(String level) {
    switch (level) {
      case 'N5':
        return levelN5;
      case 'N4':
        return levelN4;
      case 'N3':
        return levelN3;
      case 'N2':
        return levelN2;
      case 'N1':
        return levelN1;
      default:
        return level;
    }
  }
}
