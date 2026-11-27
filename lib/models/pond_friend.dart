/// A buddy that was sent to the pond on a day the goal was reached.
class PondFriend {
  const PondFriend(this.buddyId, this.day);

  /// Which buddy it is (see kBuddies in data/catalog.dart).
  final String buddyId;

  /// The day it joined, as 'yyyy-mm-dd'.
  final String day;

  Map<String, Object> toJson() => {'buddyId': buddyId, 'day': day};

  factory PondFriend.fromJson(Map<String, dynamic> json) =>
      PondFriend(json['buddyId'] as String, json['day'] as String);
}
