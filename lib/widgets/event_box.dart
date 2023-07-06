import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entity/event_entity.dart';
import 'package:http/http.dart' as http;

// Widget for event
class EventBox extends StatelessWidget {
  final EventEntity event;
  final Function() onDismissed;

  const EventBox({
    Key? key,
    required this.event,
    required this.onDismissed,
  }) : super(key: key);

  Future<void> removeEvent(int? id) async {
    if (id != null) {
      final response = await http.delete(Uri.parse(
          'http://192.168.1.120:9000/event-creator/events/delete?eventId=$id'));
      if (response.statusCode != 200) {
        print('Ошибка: ${response.statusCode}');
      }
    }
  }

  Future<void> archiveEvent(int? id) async {
    if (id != null) {
      final response = await http.put(Uri.parse(
          'http://192.168.1.120:9000/event-creator/events/archive?eventId=$id'));
      if (response.statusCode != 200) {
        print('Ошибка: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: Dismissible(
        key: Key(event.id.toString()),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            removeEvent(event.id);
          } else {
            archiveEvent(event.id);
          }
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            border: Border.all(width: 0, color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          child: const Icon(
            Icons.archive,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF741313),
            border: Border.all(width: 0, color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 35.0,
          ),
        ),
        child: Container(
          height: 82.0,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0, color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50.0,
                width: 50.0,
                margin: const EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(width: 0, color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${event.owner?.name} ${event.owner?.surname} - ${DateFormat('dd/MM/yyyy').format(event.eventDt)}",
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
