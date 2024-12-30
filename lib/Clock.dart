import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  TimeOfDay _currentTime = TimeOfDay.now();
  DateTime _currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = TimeOfDay.now();
        _currentDateTime = DateTime.now();
      });
    });
  }

  String _getGreeting() {
    final hour = _currentDateTime.hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clock',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Greeting
                  Text(
                    _getGreeting(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Current Time
                  Text(
                    _formatTime(_currentDateTime),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Current Date
                  Text(
                    _formatDate(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.grey[200],
                ),
                child: CustomPaint(
                  size: const Size(230, 230), // Outer ring size
                  painter: ClockPainter(_currentDateTime),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $period';
  }

  String _formatDate() {
    final now = DateTime.now();
    return '${now.weekday.weekdayName}, ${now.day} ${_monthName(now.month)}';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;

  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Draw the outer circle
    canvas.drawCircle(center, radius, paint);

    // Draw the clock numbers
    _drawClockNumbers(canvas, center, radius);

    final handPaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // Hour hand
    final hourAngle = (time.hour % 12 + time.minute / 60) * 30 * pi / 180;
    final hourHandLength = radius * 0.5;
    final hourHand = Offset(
      center.dx + hourHandLength * cos(hourAngle - pi / 2),
      center.dy + hourHandLength * sin(hourAngle - pi / 2),
    );
    canvas.drawLine(center, hourHand, handPaint);

    // Minute hand
    final minuteAngle = time.minute * 6 * pi / 180;
    final minuteHandLength = radius * 0.7;
    final minuteHand = Offset(
      center.dx + minuteHandLength * cos(minuteAngle - pi / 2),
      center.dy + minuteHandLength * sin(minuteAngle - pi / 2),
    );
    handPaint.strokeWidth = 4;
    canvas.drawLine(center, minuteHand, handPaint);

    // Second hand
    final secondAngle = time.second * 6 * pi / 180;
    final secondHandLength = radius * 0.9;
    final secondHand = Offset(
      center.dx + secondHandLength * cos(secondAngle - pi / 2),
      center.dy + secondHandLength * sin(secondAngle - pi / 2),
    );
    final secondPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, secondHand, secondPaint);
  }

  void _drawClockNumbers(Canvas canvas, Offset center, double radius) {
    final textStyle = TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30) * pi / 180;
      final numberX = center.dx + (radius - 25) * cos(angle - pi / 2);
      final numberY = center.dy + (radius - 25) * sin(angle - pi / 2);
      final textSpan = TextSpan(
        text: '$i',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(numberX - textPainter.width / 2,
              numberY - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return oldDelegate.time != time;
  }
}

extension WeekdayExtension on int {
  String get weekdayName {
    const weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return weekdays[this - 1];
  }
}
