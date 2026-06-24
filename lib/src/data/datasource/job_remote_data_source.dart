import 'package:bloc_clean_architecture/src/comman/exception.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class JobRemoteDataSource {
  Future<List<Company>> fetchCompanies();
  Future<List<Job>> fetchJobs();
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final FirebaseDatabase _database;

  JobRemoteDataSourceImpl({FirebaseDatabase? database})
      : _database = database ?? FirebaseDatabase.instance;

  @override
  Future<List<Company>> fetchCompanies() async {
    try {
      final snapshot = await _database.ref('companies').get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }
      
      final data = snapshot.value;
      if (data is Map) {
        final companies = <Company>[];
        data.forEach((key, value) {
          if (value is Map) {
            companies.add(Company.fromJson(key.toString(), value));
          }
        });
        return companies;
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Job>> fetchJobs() async {
    try {
      final snapshot = await _database.ref('jobs').get();
      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }
      
      final data = snapshot.value;
      if (data is Map) {
        final jobs = <Job>[];
        data.forEach((key, value) {
          if (value is Map) {
            jobs.add(Job.fromJson(key.toString(), value));
          }
        });
        return jobs;
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
