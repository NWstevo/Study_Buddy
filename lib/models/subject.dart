class Subject {
  const Subject({
    required this.id,
    required this.name,
    required this.colorHue,
    required this.createdAt,
    this.archivedAt,
  });

  final String id;
  final String name;

  /// One of the hues from DESIGN_TOKENS.md's subject tag palette — never an
  /// arbitrary user-picked value (see DATA_MODEL.md § Subject).
  final int colorHue;
  final DateTime createdAt;

  /// Soft-delete. Archived subjects drop out of pickers and the weekly view
  /// but stay in historical summary data — never hard-deleted.
  final DateTime? archivedAt;

  bool get isArchived => archivedAt != null;

  Subject copyWith({
    String? name,
    int? colorHue,
    DateTime? archivedAt,
    bool clearArchivedAt = false,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      colorHue: colorHue ?? this.colorHue,
      createdAt: createdAt,
      archivedAt: clearArchivedAt ? null : (archivedAt ?? this.archivedAt),
    );
  }
}
