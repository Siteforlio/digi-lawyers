class JobEntity {
  final String id;
  final String title;
  final String description;
  final String firmName;
  final String? firmLogo;
  final String location;
  final JobType type;
  final ExperienceLevel experienceLevel;
  final String? salaryRange;
  final List<String> requirements;
  final List<String> practiceAreas;
  final DateTime postedAt;
  final DateTime? deadline;
  final bool isRemote;
  final int applicantsCount;

  const JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.firmName,
    this.firmLogo,
    required this.location,
    required this.type,
    required this.experienceLevel,
    this.salaryRange,
    required this.requirements,
    required this.practiceAreas,
    required this.postedAt,
    this.deadline,
    this.isRemote = false,
    this.applicantsCount = 0,
  });
}

enum JobType {
  fullTime,
  partTime,
  contract,
  pupillage,
  internship,
}

enum ExperienceLevel {
  entry,
  midLevel,
  senior,
  partner,
}
