import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  EventType? _filterType;

  final Map<DateTime, List<CalendarEvent>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  void _loadEvents() {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    _events[normalizedToday] = [
      CalendarEvent(
        id: '1',
        title: 'Court Hearing',
        subtitle: 'Kamau vs State',
        time: '9:00 AM',
        type: EventType.court,
        location: 'Milimani Law Courts',
        caseNumber: 'CR/2024/001',
      ),
      CalendarEvent(
        id: '2',
        title: 'Client Meeting',
        subtitle: 'Jane Wanjiku',
        time: '2:00 PM',
        type: EventType.meeting,
        location: 'Office - Room 3',
      ),
      CalendarEvent(
        id: '3',
        title: 'Filing Deadline',
        subtitle: 'Civil Case 234 Response',
        time: '5:00 PM',
        type: EventType.deadline,
        location: '',
      ),
    ];

    _events[normalizedToday.add(const Duration(days: 1))] = [
      CalendarEvent(
        id: '4',
        title: 'Court Mention',
        subtitle: 'Ochieng Matter',
        time: '10:00 AM',
        type: EventType.court,
        location: 'High Court',
        caseNumber: 'CV/2024/102',
      ),
    ];

    _events[normalizedToday.add(const Duration(days: 3))] = [
      CalendarEvent(
        id: '5',
        title: 'Land Tribunal',
        subtitle: 'Wanjiku Land Dispute',
        time: '10:00 AM',
        type: EventType.court,
        location: 'Environment & Land Court',
        caseNumber: 'ELC/2024/045',
      ),
      CalendarEvent(
        id: '6',
        title: 'CLE Seminar',
        subtitle: 'New Evidence Act Updates',
        time: '2:00 PM',
        type: EventType.other,
        location: 'LSK Offices',
      ),
    ];

    _events[normalizedToday.add(const Duration(days: 5))] = [
      CalendarEvent(
        id: '7',
        title: 'Payment Due',
        subtitle: 'Office Rent',
        time: '12:00 PM',
        type: EventType.deadline,
        location: '',
      ),
    ];
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  List<CalendarEvent> get _filteredEvents {
    final events = _selectedDay != null ? _getEventsForDay(_selectedDay!) : <CalendarEvent>[];
    if (_filterType == null) return events;
    return events.where((e) => e.type == _filterType).toList();
  }

  int get _totalUpcoming {
    int count = 0;
    final today = DateTime.now();
    _events.forEach((date, events) {
      if (!date.isBefore(DateTime(today.year, today.month, today.day))) {
        count += events.length;
      }
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _CalendarHeader(
              focusedDay: _focusedDay,
              onTodayPressed: () => setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              }),
              onAddPressed: () => context.push('/calendar/add'),
              onSyncPressed: () => context.push('/calendar/sync'),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _UpcomingSummary(totalEvents: _totalUpcoming)),
                  SliverToBoxAdapter(child: _buildCalendar()),
                  SliverToBoxAdapter(child: _EventTypeFilter(
                    selectedType: _filterType,
                    onTypeSelected: (type) => setState(() => _filterType = type),
                  )),
                  SliverToBoxAdapter(child: _buildEventsHeader()),
                  _buildEventsList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/calendar/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
      ),
    );
  }

  Widget _buildCalendar() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: TableCalendar<CalendarEvent>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          markersMaxCount: 3,
          markerSize: 6,
          markerDecoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
          weekendTextStyle: TextStyle(color: theme.colorScheme.error),
          cellMargin: const EdgeInsets.all(4),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w600),
          weekendStyle: theme.textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.error,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          titleTextStyle: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: theme.textTheme.labelMedium!,
          leftChevronIcon: Icon(Icons.chevron_left, color: theme.colorScheme.onSurface),
          rightChevronIcon: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return null;
            return Positioned(
              bottom: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: events.take(3).map((event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: event.color,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) => setState(() => _calendarFormat = format),
        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
      ),
    );
  }

  Widget _buildEventsHeader() {
    final theme = Theme.of(context);
    final dateStr = _selectedDay != null
        ? _formatDate(_selectedDay!)
        : 'Today';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.event_note, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateStr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  '${_filteredEvents.length} event${_filteredEvents.length != 1 ? 's' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (_filteredEvents.isNotEmpty)
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.view_agenda_outlined, size: 18),
              label: const Text('View All'),
            ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    if (_filteredEvents.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _EventCard(event: _filteredEvents[index]),
          childCount: _filteredEvents.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_available, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text('No events', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'No events scheduled for this day',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.push('/calendar/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) return 'Today';
    if (selectedDate == tomorrow) return 'Tomorrow';

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onTodayPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onSyncPressed;

  const _CalendarHeader({
    required this.focusedDay,
    required this.onTodayPressed,
    required this.onAddPressed,
    required this.onSyncPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_month, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Calendar', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Manage your schedule', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(
            onPressed: onSyncPressed,
            icon: const Icon(Icons.sync),
            tooltip: 'Sync Calendars',
          ),
          IconButton(
            onPressed: onTodayPressed,
            icon: const Icon(Icons.today),
            tooltip: 'Today',
          ),
        ],
      ),
    );
  }
}

class _UpcomingSummary extends StatelessWidget {
  final int totalEvents;

  const _UpcomingSummary({required this.totalEvents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming Events', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$totalEvents', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('this week', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              _MiniStat(icon: Icons.gavel, count: 3, label: 'Court', color: Colors.red),
              const SizedBox(height: 8),
              _MiniStat(icon: Icons.timer, count: 2, label: 'Deadlines', color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const _MiniStat({required this.icon, required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text('$count $label', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _EventTypeFilter extends StatelessWidget {
  final EventType? selectedType;
  final ValueChanged<EventType?> onTypeSelected;

  const _EventTypeFilter({required this.selectedType, required this.onTypeSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final types = [
      (null, 'All', Icons.dashboard_outlined, theme.colorScheme.primary),
      (EventType.court, 'Court', Icons.gavel, Colors.red),
      (EventType.meeting, 'Meetings', Icons.people, Colors.blue),
      (EventType.deadline, 'Deadlines', Icons.timer, Colors.orange),
      (EventType.other, 'Other', Icons.event, Colors.purple),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: types.map((type) {
          final isSelected = selectedType == type.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(type.$3, size: 18, color: isSelected ? theme.colorScheme.onPrimaryContainer : type.$4),
              label: Text(type.$2),
              selected: isSelected,
              onSelected: (_) => onTypeSelected(type.$1),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CalendarEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time column
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: event.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(event.icon, color: event.color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.time,
                    style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        _EventTypeBadge(type: event.type),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (event.location.isNotEmpty || event.caseNumber != null) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          if (event.location.isNotEmpty)
                            _EventDetail(icon: Icons.location_on_outlined, text: event.location),
                          if (event.caseNumber != null)
                            _EventDetail(icon: Icons.folder_outlined, text: event.caseNumber!),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _EventAction(icon: Icons.edit_outlined, label: 'Edit'),
                        const SizedBox(width: 8),
                        _EventAction(icon: Icons.notifications_outlined, label: 'Remind'),
                        const Spacer(),
                        Icon(Icons.chevron_right, size: 20, color: theme.colorScheme.onSurfaceVariant),
                      ],
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

class _EventTypeBadge extends StatelessWidget {
  final EventType type;

  const _EventTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final info = _getInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: info.$2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        info.$1,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: info.$2),
      ),
    );
  }

  (String, Color) _getInfo() {
    switch (type) {
      case EventType.court:
        return ('Court', Colors.red);
      case EventType.meeting:
        return ('Meeting', Colors.blue);
      case EventType.deadline:
        return ('Deadline', Colors.orange);
      case EventType.other:
        return ('Event', Colors.purple);
    }
  }
}

class _EventDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EventAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EventAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

enum EventType { court, meeting, deadline, other }

class CalendarEvent {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final EventType type;
  final String location;
  final String? caseNumber;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.location,
    this.caseNumber,
  });

  IconData get icon {
    switch (type) {
      case EventType.court:
        return Icons.gavel;
      case EventType.meeting:
        return Icons.people;
      case EventType.deadline:
        return Icons.timer;
      case EventType.other:
        return Icons.event;
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
      case EventType.other:
        return Colors.purple;
    }
  }
}
