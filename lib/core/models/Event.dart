class Event {
  final String id;
  final String image;
  final String title;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String latitude;
  final String longitude;
  final String locationTitle;
  final String address;
  final String details;

  Event(
      {this.id,
      this.image,
      this.title,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.latitude,
      this.longitude,
      this.address,
      this.locationTitle,
      this.details});

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
        'startDate': startDate,
        'endDate': endDate,
        'startTime': startTime,
        'endTime': endTime,
        'latitude': latitude,
        'longitude': longitude,
        'locationTitle': locationTitle,
        'address': address,
        'details': details,
      };

  Event.fromJson(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        image = parsedJSON['image'],
        title = parsedJSON['title'],
        startDate = parsedJSON['startDate'],
        endDate = parsedJSON['endDate'],
        startTime = parsedJSON['startTime'],
        endTime = parsedJSON['endTime'],
        latitude = parsedJSON['endTime'],
        longitude = parsedJSON['longitude'],
        address = parsedJSON['address'],
        details = parsedJSON['details'],
        locationTitle = parsedJSON['locationTitle'];
}
