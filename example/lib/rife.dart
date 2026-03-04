class Rife {
  Rife({
    required this.id,
    required this.title,
    required this.frequencies,
  });

  final int id;
  final String title;
  final List<double> frequencies;
}

final rifes = Rife(
    id: 1,
    title: 'Abscess',
    frequencies: [428, 444, 450, 660, 760, 820, 1550]
  );
