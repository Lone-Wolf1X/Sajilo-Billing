class SaisaWarehouse {
  final int id;
  final String code;
  final String name;
  final bool defaultWarehouse;
  final bool active;

  const SaisaWarehouse({
    required this.id,
    required this.code,
    required this.name,
    required this.defaultWarehouse,
    required this.active,
  });

  factory SaisaWarehouse.fromJson(Map<String, dynamic> j) => SaisaWarehouse(
        id: (j['id'] as num).toInt(),
        code: j['code'] as String,
        name: j['name'] as String,
        defaultWarehouse: j['defaultWarehouse'] as bool? ?? false,
        active: j['active'] as bool? ?? true,
      );
}
