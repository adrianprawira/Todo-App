class Task {
  int? id;
  String? title;
  DateTime? date;
  String? priority;
  String? location;
  int? status;

  Task({this.title, this.date, this.priority, this.location, this.status});
  Task.withID({this.id, this.title, this.date, this.priority, this.location, this.status});


  Map toMap() {
    final map = Map<String, dynamic>();

    if (id != null) {
      map["id"] = id;
    }

    map["title"] = title;
    map["date"] = date!.toIso8601String();
    map["priority"] = priority;
    map["location"] = location;
    map["status"] = status;

    return map;
  }

  factory Task.fromMap(Map map) {
    return Task.withID(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      priority: map['priority'],
      location: map['location'],
      status: map['status'],
    );
  }
}
