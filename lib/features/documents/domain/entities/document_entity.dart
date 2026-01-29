class DocumentEntity {
  final String id;
  final String name;
  final String? description;
  final DocumentType type;
  final DocumentCategory category;
  final String? caseId;
  final String? clientId;
  final int fileSize;
  final String fileExtension;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  const DocumentEntity({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.category,
    this.caseId,
    this.clientId,
    required this.fileSize,
    required this.fileExtension,
    required this.createdAt,
    this.modifiedAt,
  });
}

enum DocumentType {
  template,
  uploaded,
  generated,
}

enum DocumentCategory {
  contract,
  courtFiling,
  correspondence,
  agreement,
  affidavit,
  pleading,
  notice,
  will,
  deed,
  other,
}
