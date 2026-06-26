class Company {
  final String id;
  final String name;
  final String email;
  final int jobCount;
  final Map<String, bool> jobIds;
  final int lastUpdated;
  final String? logoUrl;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.jobCount,
    required this.jobIds,
    required this.lastUpdated,
    this.logoUrl,
  });

  factory Company.fromJson(String id, Map<dynamic, dynamic> json) {
    final rawJobIds = json['jobIds'];
    final jobIdsMap = <String, bool>{};
    if (rawJobIds is Map) {
      rawJobIds.forEach((key, value) {
        jobIdsMap[key.toString()] = value == true;
      });
    }
    return Company(
      id: id,
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      jobCount: (json['jobCount'] as num?)?.toInt() ?? 0,
      jobIds: jobIdsMap,
      lastUpdated: (json['lastUpdated'] as num?)?.toInt() ?? 0,
      logoUrl: json['logoUrl'] as String?,
    );
  }
}
