class Event {
  final String name;
  final DateTime date;

  Event(this.name, this.date);

  Event.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
      };
}
