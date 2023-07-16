import 'dart:convert';
import 'dart:io';

import '../entity/event_entity.dart';
import 'package:http/http.dart' as http;

class EventService {
  // Get events list by SimpleUser's id
  static Future<List<EventEntity>?> getUserEvents(int? id) async {
    final response = await http.get(
        Uri.parse('http://192.168.1.120:9000/event-creator/events?userId=$id'));
    if (response.statusCode == 200) {
      String jsonBody = response.body;
      final parsed = jsonDecode(jsonBody).cast<Map<String, dynamic>>();
      return parsed
          .map<EventEntity>((json) => EventEntity.fromJson(json))
          .toList();
    } else {
      throw const HttpException('Failed to get user\'s events');
    }
  }

  // The function of save event in the db
  static Future<void> saveEvent(EventEntity event) async {
    var jsonBody = jsonEncode(event.toJson());
    final response = await http.post(
        Uri.parse('http://192.168.1.120:9000/event-creator/events/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonBody);
    if (response.statusCode != 200) {
      throw const HttpException('Failed to save event');
    }
  }

  // Remove event from db
  static Future<void> removeEvent(int? id) async {
    if (id != null) {
      final response = await http.delete(Uri.parse(
          'http://192.168.1.120:9000/event-creator/events/delete?eventId=$id'));
      if (response.statusCode != 200) {
        throw const HttpException('Failed to remove event');
      }
    }
  }

  // Update event archive-status
  static Future<void> archiveEvent(int? id) async {
    if (id != null) {
      final response = await http.put(Uri.parse(
          'http://192.168.1.120:9000/event-creator/events/archive?eventId=$id'));
      if (response.statusCode != 200) {
        throw const HttpException('Failed to archive event');
      }
    }
  }
}
