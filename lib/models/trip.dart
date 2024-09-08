
class Trip{

  String tripId = '';
  int startedAt = 0;

  Trip({required this.tripId, required this.startedAt});

  Trip.fromJson(Map<Object?, Object?> json) {
    tripId = json['tripId'].toString();
    startedAt = json['startedAt'] as int;
  }

}