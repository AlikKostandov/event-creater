import 'package:event_creater/entity/simple_user.dart';
import 'package:intl/intl.dart';

// Base Event Entity
class EventEntity {
  int? id;
  int type;
  String title;
  DateTime eventDt;
  String? eventTm;
  String? location;
  String? createDttm;
  SimpleUser? owner;

  EventEntity(
      {this.id,
      required this.type,
      required this.title,
      required this.eventDt,
      this.eventTm,
      this.location,
      this.createDttm,
      this.owner});

  // Json -> EventEntity
  factory EventEntity.fromJson(Map<String, dynamic> json) {
    final ownerData = json['owner'];
    final eventDtInfo = json['eventDt'];
    SimpleUser? owner;

    if (ownerData != null) {
      owner = SimpleUser.fromJson(ownerData);
    }

    DateFormat format = DateFormat('yyyy-MM-dd');
    DateTime dateTime = format.parse(eventDtInfo);
    return EventEntity(
        id: json['eventId'],
        type: json['eventTypeId'],
        title: json['eventName'],
        eventDt: dateTime,
        eventTm: json['eventTm'],
        location: json['eventLoc'],
        createDttm: json['createDttm'],
        owner: owner);
  }

  //EventEntity -> Json
  Map<String, dynamic> toJson() {
    String eventDtInCorrectFormat = DateFormat('yyyy-MM-dd').format(eventDt);

    return {
      'eventTypeId': type,
      'eventName': title,
      'eventDt': eventDtInCorrectFormat,
      'eventTm': eventTm,
      'eventLoc': location,
      'owner': owner?.toJsonForCreateEvent()
    };
  }
}
