import 'package:flutter/material.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final events = [
      _Event(
        title: 'Court Hearing - Kamau vs State',
        time: '9:00 AM',
        date: 'Today',
        location: 'Milimani Law Courts',
        type: EventType.court,
      ),
      _Event(
        title: 'Client Meeting - Jane Wanjiku',
        time: '2:00 PM',
        date: 'Today',
        location: 'Office',
        type: EventType.meeting,
      ),
      _Event(
        title: 'Filing Deadline - Civil Case 234',
        time: '5:00 PM',
        date: 'Tomorrow',
        location: '',
        type: EventType.deadline,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Events',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...events.map((event) => _EventTile(event: event)),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  final _Event event;

  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: event.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(event.icon, color: event.color, size: 24),
        ),
        title: Text(
          event.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${event.date} at ${event.time}${event.location.isNotEmpty ? ' • ${event.location}' : ''}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

enum EventType { court, meeting, deadline }

class _Event {
  final String title;
  final String time;
  final String date;
  final String location;
  final EventType type;

  _Event({
    required this.title,
    required this.time,
    required this.date,
    required this.location,
    required this.type,
  });

  IconData get icon {
    switch (type) {
      case EventType.court:
        return Icons.gavel;
      case EventType.meeting:
        return Icons.people;
      case EventType.deadline:
        return Icons.timer;
    }
  }

  Color get color {
    switch (type) {
      case EventType.court:
        return Colors.red;
      case EventType.meeting:
        return Colors.blue;
      case EventType.deadline:
        return Colors.orange;
    }
  }
}
