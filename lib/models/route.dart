class Route {
  final String name;
  final DateTime updatedAt;

  Route(this.name, this.updatedAt);

  Route.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        updatedAt = json['updatedAt'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'updatedAt': updatedAt,
      };
}
