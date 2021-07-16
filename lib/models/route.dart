class HikingRoute {
  final int id;
  final String name;
  final String name_en;
  final String district;
  final String district_en;
  final String description;
  final String description_en;
  final String image;
  final double difficulty;
  final double rating;
  final int duration; // minutes
  final double length;
  final String path;

  HikingRoute(
      this.id,
      this.name,
      this.name_en,
      this.district,
      this.district_en,
      this.description,
      this.description_en,
      this.image,
      this.difficulty,
      this.rating,
      this.duration,
      this.length,
      this.path);

  HikingRoute.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        name_en = json['name_en'],
        district = json['district'],
        district_en = json['district_en'],
        description = json['description'],
        description_en = json['description_en'],
        image = json['image'],
        difficulty = json['difficulty'],
        rating = json['rating'],
        duration = json['duration'],
        length = json['length'],
        path = json['path'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'name_en': name_en,
        'district': district,
        'district_en': district_en,
        'description': description,
        'description_en': description_en,
        'image': image,
        'difficulty': difficulty,
        'rating': rating,
        'duration': duration,
        'length': length,
        'path': path,
      };
}
