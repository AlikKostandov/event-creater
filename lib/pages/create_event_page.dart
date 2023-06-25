import 'dart:convert';
import 'dart:io';

import 'package:event_creater/entity/event_entity.dart';
import 'package:event_creater/entity/simple_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/header_widget.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final double _headerHeight = 150;
  late int userId;
  User? user;

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
    final int? receivedUserId =
        ModalRoute.of(context)!.settings.arguments as int?;
    if (receivedUserId != null) {
      userId = receivedUserId;
    }
  }

  // Function for select event date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2027));
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

  /// The function of save event in the database
  Future<void> saveEvent() async {
    EventEntity event = EventEntity(
        type: types[_typeController.text]!,
        title: _titleController.text,
        eventDt: currentDate,
        eventTm: _timeController.text,
        location: _locationController.text,
        owner: SimpleUser(id: userId));
    var jsonBody = jsonEncode(event.toJson());
    final response = await http.post(
        Uri.parse('http://192.168.1.120:9000/event-creator/events/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonBody);
    if (response.statusCode != 200) {
      throw HttpException;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //Header
        Stack(children: <Widget>[
          SizedBox(
            height: _headerHeight,
            child: HeaderWidget(
                _headerHeight), //let's create a common header widget
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 35.0)),
                SizedBox(
                  width: 220.0,
                  child: TextField(
                    controller: _titleController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        hintText: 'Event Title',
                        hintStyle: TextStyle(color: Color(0xFF9F9797)),
                        border: InputBorder.none),
                    style: const TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'Lobster',
                        color: Colors.white),
                  ),
                ),
                TextButton(
                    onPressed: () => {saveEvent(), Navigator.pop(context)},
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
                    child: TextField(
                      controller: _dateController,
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
    ));
  }
}
