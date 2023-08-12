import 'package:event_creater/entity/event_entity.dart';
import 'package:event_creater/entity/simple_user.dart';
import 'package:event_creater/services/event_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/header_widget.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final double _headerHeight = 150;
  final _formKey = GlobalKey<FormState>();
  int? userId;
  User? user;
  EventEntity? event;

  Map<String, int> types = {
    'Other': 0,
    'Birthday': 1,
    'Picnic': 2,
    'Barbecue': 3,
    'New Year': 4,
    'Christmas celebration': 5,
    'Halloween': 6,
    'Corporate': 7,
    'Party': 8,
    'Friendly meeting': 9,
    'Date': 10,
    'Trip': 11,
    'Easter': 12,
    'Wedding': 13,
  };

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _typeController =
      TextEditingController(text: 'Other');
  final TextEditingController _locationController = TextEditingController();

  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();

  // Get arguments from other page
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is int) {
      userId = args;
    } else if (args is EventEntity) {
      event = args;
      _titleController.text = event!.title;
      _dateController.text = DateFormat('dd.MM.yyyy').format(event!.eventDt);
      _timeController.text =
          event!.eventTm != null ? event!.eventTm!.substring(0, 5) : '';
      _typeController.text = types.keys.elementAt(event!.type);
      _locationController.text = event?.location ?? '';
    }
  }

  // Function for select event date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: currentDate.add(const Duration(days: 365 * 3)));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        _dateController.text = DateFormat('dd.MM.yyyy').format(currentDate);
      });
    }
  }

  // Function for select event time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (pickedTime != null && pickedTime != currentTime) {
      DateTime currentDateTime = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        currentDateTime = selectedDateTime;
        _timeController.text = DateFormat('HH:mm').format(selectedDateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //Header
            Stack(children: <Widget>[
              SizedBox(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () =>
                            {Navigator.pushReplacementNamed(context, '/home')},
                        icon: const Icon(Icons.arrow_back_ios, size: 35.0)),
                    SizedBox(
                      width: 220.0,
                      child: TextFormField(
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Give a name to the event';
                          } else {
                            return null;
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            hintText: 'Event Title',
                            hintStyle: TextStyle(color: Color(0xFF9F9797)),
                            border: InputBorder.none),
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontFamily: 'Lobster',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (event == null) {
                              await EventService.saveEvent(EventEntity(
                                  type: types[_typeController.text]!,
                                  title: _titleController.text,
                                  eventDt: currentDate,
                                  eventTm: _timeController.text,
                                  location: _locationController.text,
                                  owner: SimpleUser(id: userId)));
                            } else {
                              await EventService.editEvent(EventEntity(
                                id: event!.id,
                                type: types[_typeController.text]!,
                                title: _titleController.text,
                                eventDt: currentDate,
                                eventTm: _timeController.text,
                                location: _locationController.text,
                              ));
                            }
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ))
                  ],
                ),
              ),
            ]),
            // Form for create event
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  // Choose Date
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                          iconSize: 40.0),
                      SizedBox(
                        width: 220.0,
                        child: TextFormField(
                          controller: _dateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Set a date for the event';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Event Date',
                            hintStyle: TextStyle(color: Color(0xFF9F9797)),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                              fontSize: 26.0,
                              fontFamily: 'Lobster',
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                // Choose Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => _selectTime(context),
                        icon: const Icon(Icons.access_time),
                        iconSize: 40.0),
                    SizedBox(
                      width: 220.0,
                      child: TextField(
                        controller: _timeController,
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: const InputDecoration(
                          hintText: 'Event Time',
                          hintStyle: TextStyle(color: Color(0xFF9F9797)),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 26.0,
                            fontFamily: 'Lobster',
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                // Separate line
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                // Various for event type
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Event Type:',
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: 22.0,
                            color: Color(0xFF9F9797),
                          )),
                      Column(
                        children: [
                          DropdownButton<String>(
                            value: _typeController.text,
                            underline: Container(
                              height: 0.0,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _typeController.text = newValue!;
                              });
                            },
                            items: types.keys
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            icon: const Icon(
                              Icons.add,
                              size: 0.0,
                            ),
                            menuMaxHeight: 200.0,
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Lobster',
                                fontSize: 24.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // TextField for choose location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => print('Click'),
                        icon: const Icon(Icons.map_outlined),
                        iconSize: 40.0),
                    SizedBox(
                      width: 220.0,
                      child: TextField(
                        controller: _locationController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Location',
                          hintStyle: TextStyle(color: Color(0xFF9F9797)),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 26.0,
                            fontFamily: 'Lobster',
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
                // Button for additional parameters
                Container(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: const <Widget>[
                      Text('Additional Parameters'),
                      Icon(Icons.keyboard_double_arrow_down_sharp)
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
