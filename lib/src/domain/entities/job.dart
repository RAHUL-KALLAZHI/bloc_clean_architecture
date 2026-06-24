class Job {
  final String id;
  final String companyId;
  final String title;
  final String description;
  final String email;
  final String jobUrl;
  final int lastUpdated;

  Job({
    required this.id,
    required this.companyId,
    required this.title,
    required this.description,
    required this.email,
    required this.jobUrl,
    required this.lastUpdated,
  });

  factory Job.fromJson(String id, Map<dynamic, dynamic> json) {
    return Job(
      id: id,
      companyId: (json['companyId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      jobUrl: (json['jobUrl'] as String?) ?? '',
      lastUpdated: (json['lastUpdated'] as num?)?.toInt() ?? 0,
    );
  }
}
