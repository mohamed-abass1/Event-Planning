class Event{
  static const String collectionName = "Event";
  String id;
  String title;
  String description;
  String image;
  String eventName;
  DateTime dateTime;
  String time;
  bool isFavorite;
  double? latitude;
  double? longitude;

  Event({
    this.id = "",
    required this.title,
    required this.description,
    required this.image,
    required this.dateTime,
    required this.eventName,
    required this.latitude,
    required this.longitude,
    required this.time,
    this.isFavorite = false,
  });

  Event.fromFireStore(Map<String, dynamic>? data)
      : this(
    latitude: _convertToDouble(data?["latitude"]),
    longitude: _convertToDouble(data?["longitude"]),
    id: data!["id"],
    title: data["title"],
    image: data["image"],
    eventName: data["eventName"],
    description: data["description"],
    dateTime: DateTime.fromMillisecondsSinceEpoch(data["dateTime"]),
    time: data["time"].toString(),
    isFavorite: data["isFavorite"],
  );

  Map<String, dynamic> toFireStore() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "id": id,
      "title": title,
      "description": description,
      "image": image,
      "eventName": eventName,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "time": time,
      "isFavorite": isFavorite,
    };
  }
}

double? _convertToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
