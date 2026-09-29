/// Domain model for a category card shown on the home screen.
class HomeCategory {
  const HomeCategory({
    required this.label,
    required this.route,
    required this.emoji,
  });

  final String label;
  final String route;
  final String emoji;
}
