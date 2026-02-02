enum NotificationType {
  caseUpdate,
  newLead,
  payment,
  courtDate,
  message,
  connection,
  jobApplication,
  systemAlert,
}

class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? actionRoute;
  final String? actionId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionRoute,
    this.actionId,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionRoute,
    String? actionId,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      actionId: actionId ?? this.actionId,
    );
  }
}
