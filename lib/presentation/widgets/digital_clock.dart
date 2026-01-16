import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  final int? utcOffsetSeconds; // New: Offset in seconds

  const DigitalClock({super.key, this.utcOffsetSeconds});

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateTime();
        });
      }
    });
  }

  void _updateTime() {
    if (widget.utcOffsetSeconds != null) {
      // Calculate local time based on UTC + offset
      _currentTime = DateTime.now().toUtc().add(Duration(seconds: widget.utcOffsetSeconds!));
    } else {
      _currentTime = DateTime.now();
    }
  }

  @override
  void didUpdateWidget(covariant DigitalClock oldWidget) {
     super.didUpdateWidget(oldWidget);
     _updateTime(); // Update immediately if offset changes
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(_currentTime);
    
    // Calculate display timezone (e.g. GMT+7)
    String timeZoneString = '';
    if (widget.utcOffsetSeconds != null) {
       final offsetHours = widget.utcOffsetSeconds! / 3600;
       final sign = offsetHours >= 0 ? '+' : '';
       // Format to check if integer or half
       final offsetDetails = offsetHours.toStringAsFixed(offsetHours.truncateToDouble() == offsetHours ? 0 : 1);
       timeZoneString = 'GMT$sign$offsetDetails';
    } else {
       final timeZone = _currentTime.timeZoneOffset.inHours;
       final sign = timeZone >= 0 ? '+' : '';
       timeZoneString = 'GMT$sign$timeZone';
    }

    return Text(
      '$timeString $timeZoneString',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}
