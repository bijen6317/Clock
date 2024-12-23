import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _timeString;
  late String _dateString;
  late String _condition;
  String _selectedDateFormat = 'dd-MMM-yyyy'; // Default format

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    _condition = _getCondition(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = _formatTime(now);
      _dateString = _formatDate(now);
      _condition = _getCondition(now);
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat(_selectedDateFormat).format(dateTime);
  }

  String _getCondition(DateTime dateTime) {
    if (dateTime.hour < 12) {
      return "Good Morning";
    } else if (dateTime.hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000428), Color(0xFF004E92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Greeting Condition
              Text(
                _condition,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Current Time
              Text(
                _timeString,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              // Current Date
              GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showDateFormatMenu(context, details.globalPosition);
                },
                child: Text(
                  _dateString,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateFormatMenu(BuildContext context, Offset position) {
    final List<String> dateFormats = [
      'dd-MMM-yyyy',
      'MMM-dd-yyyy',
      'yyyy-MMM-dd'
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, 0),
      items: dateFormats.map((String format) {
        return PopupMenuItem<String>(
          value: format,
          child: Text(
            format,
            style: TextStyle(
              color: format == _selectedDateFormat ? Colors.blue : Colors.black,
              fontWeight: format == _selectedDateFormat
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    ).then((String? selectedFormat) {
      if (selectedFormat != null && selectedFormat != _selectedDateFormat) {
        setState(() {
          _selectedDateFormat = selectedFormat;
          _dateString = _formatDate(DateTime.now());
        });
      }
    });
  }
}
