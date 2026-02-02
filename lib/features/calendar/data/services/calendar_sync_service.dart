import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

class CalendarSyncService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  List<Calendar> _availableCalendars = [];
  final Set<String> _syncedCalendarIds = {};

  List<Calendar> get availableCalendars => _availableCalendars;
  Set<String> get syncedCalendarIds => _syncedCalendarIds;

  /// Check and request calendar permissions
  Future<bool> requestPermissions() async {
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && (permissionsGranted.data ?? false)) {
      return true;
    }

    permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
    return permissionsGranted.isSuccess && (permissionsGranted.data ?? false);
  }

  /// Fetch available calendars from device
  Future<List<Calendar>> fetchCalendars() async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      return [];
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarsResult.isSuccess && calendarsResult.data != null) {
      _availableCalendars = calendarsResult.data!;
      return _availableCalendars;
    }
    return [];
  }

  /// Toggle sync for a specific calendar
  void toggleCalendarSync(String calendarId) {
    if (_syncedCalendarIds.contains(calendarId)) {
      _syncedCalendarIds.remove(calendarId);
    } else {
      _syncedCalendarIds.add(calendarId);
    }
  }

  /// Check if a calendar is synced
  bool isCalendarSynced(String calendarId) {
    return _syncedCalendarIds.contains(calendarId);
  }

  /// Fetch events from synced calendars
  Future<List<Event>> fetchSyncedEvents({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allEvents = <Event>[];

    for (final calendarId in _syncedCalendarIds) {
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
      );

      if (eventsResult.isSuccess && eventsResult.data != null) {
        allEvents.addAll(eventsResult.data!);
      }
    }

    return allEvents;
  }

  /// Create an event in a specific calendar
  Future<String?> createEvent({
    required String calendarId,
    required String title,
    required String description,
    required DateTime start,
    required DateTime end,
    String? location,
  }) async {
    final event = Event(
      calendarId,
      title: title,
      description: description,
      start: TZDateTime.from(start, local),
      end: TZDateTime.from(end, local),
      location: location,
    );

    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result?.isSuccess ?? false) {
      return result?.data;
    }
    return null;
  }

  /// Delete an event
  Future<bool> deleteEvent(String calendarId, String eventId) async {
    final result = await _deviceCalendarPlugin.deleteEvent(calendarId, eventId);
    return result.isSuccess;
  }

  /// Get calendar type info (for display)
  CalendarTypeInfo getCalendarTypeInfo(Calendar calendar) {
    final accountType = (calendar.accountType ?? '').toLowerCase();
    final accountName = (calendar.accountName ?? '').toLowerCase();

    if (accountType.contains('google') || accountName.contains('google') || accountName.contains('gmail')) {
      return CalendarTypeInfo(
        type: CalendarType.google,
        displayName: 'Google Calendar',
        icon: Icons.g_mobiledata,
        color: Colors.blue,
      );
    } else if (accountType.contains('icloud') || accountType.contains('apple') || accountName.contains('icloud')) {
      return CalendarTypeInfo(
        type: CalendarType.apple,
        displayName: 'Apple Calendar',
        icon: Icons.apple,
        color: Colors.grey.shade800,
      );
    } else if (accountType.contains('exchange') || accountType.contains('outlook') || accountName.contains('outlook')) {
      return CalendarTypeInfo(
        type: CalendarType.outlook,
        displayName: 'Outlook',
        icon: Icons.mail_outline,
        color: Colors.blue.shade700,
      );
    } else {
      return CalendarTypeInfo(
        type: CalendarType.local,
        displayName: 'Local Calendar',
        icon: Icons.calendar_today,
        color: Colors.green,
      );
    }
  }
}

enum CalendarType { google, apple, outlook, local }

class CalendarTypeInfo {
  final CalendarType type;
  final String displayName;
  final IconData icon;
  final Color color;

  CalendarTypeInfo({
    required this.type,
    required this.displayName,
    required this.icon,
    required this.color,
  });
}
