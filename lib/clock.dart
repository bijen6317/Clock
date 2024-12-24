import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClockPage(),
    );
  }
}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late String _timeString;
  late String _dateString;
  late String _weekString;
  late String _condition;
  String _selectedDateFormat = 'dd-MMM-yyyy'; // Default format
  bool _isDarkMode = false; // Toggle for light/dark mode

  int _selectedIndex = 0; // Bottom Navigation Index

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _timeString = _formatTime(now);
    _dateString = _formatDate(now);
    _weekString = _formatWeek(now);
    _condition = _getCondition(now);
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = _formatTime(now);
      _dateString = _formatDate(now);
      _weekString = _formatWeek(now);
      _condition = _getCondition(now);
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat(_selectedDateFormat).format(dateTime);
  }

  String _formatWeek(DateTime dateTime) {
    return DateFormat('EEEE').format(dateTime); // EEEE gives full weekday name
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = _isDarkMode ? Colors.white : Colors.black;
    final Color backgroundColor =
        _isDarkMode ? const Color(0xFF2C2C2C) : Colors.white;
    final Color appBarColor =
        _isDarkMode ? const Color(0xFF444444) : const Color(0xFFF1F1F1);

    // Screens for BottomNavigationBar
    List<Widget> _screens = [
      _clockScreen(),
      _stopwatchScreen(),
      _alarmScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock'),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex], // Display the selected screen

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarm',
          ),
        ],
      ),
    );
  }

  Widget _clockScreen() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: _isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Greeting Condition (Larger Font)
                  Text(
                    _condition,
                    style: TextStyle(
                      fontSize: 48, // Make the greeting larger
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Current Time with Different Colors for Hour, Minute, and Second
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _timeString.split(':')[0], // Hour
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.red : Colors.deepOrange,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color:
                                  _isDarkMode ? Colors.black45 : Colors.white,
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        _timeString.split(':')[1], // Minute
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.lightGreen : Colors.green,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color:
                                  _isDarkMode ? Colors.black45 : Colors.white,
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        _timeString.split(':')[2].split(' ')[0], // Second
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.blue : Colors.lightBlue,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color:
                                  _isDarkMode ? Colors.black45 : Colors.white,
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Date and Week on the Same Line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showDateFormatMenu(context, details.globalPosition);
                        },
                        child: Text(
                          _dateString,
                          style: TextStyle(
                            fontSize: 24,
                            color: _isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _weekString,
                        style: TextStyle(
                          fontSize: 24,
                          color: _isDarkMode
                              ? Colors.white.withOpacity(0.7)
                              : Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder for Stopwatch Screen
  Widget _stopwatchScreen() {
    return Center(
      child: Text(
        "Stopwatch Screen",
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  // Placeholder for Alarm Screen
  Widget _alarmScreen() {
    return Center(
      child: Text(
        "Alarm Screen",
        style: TextStyle(fontSize: 24),
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
