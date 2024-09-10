class NewWeapon {
  final String id;

  final String name;

  final int order;

  bool show;

  NewWeapon(
      {required this.id,
      required this.name,
      required this.order,
      required this.show});

  factory NewWeapon.fromJson(String key, Map<String, dynamic> json) {
    return NewWeapon(
      id: key,
      name: json['name'] as String,
      order: json['order'] as int,
      show: json['show'] as bool,
    );
  }
}
