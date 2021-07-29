class Region {
  final int id;
  final String name_zh;
  final String name_en;

  Region(
    this.id,
    this.name_zh,
    this.name_en,
  );

  Region.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name_zh = json['name_zh'],
        name_en = json['name_en'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_zh': name_zh,
        'name_en': name_en,
      };
}
