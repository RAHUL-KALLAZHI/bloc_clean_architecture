import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:dartz/dartz.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Company>>> getCompanies();
  Future<Either<Failure, List<Job>>> getJobs();
}
