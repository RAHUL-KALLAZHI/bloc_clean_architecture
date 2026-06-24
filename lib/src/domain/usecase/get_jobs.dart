import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/entities/job.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/job_repository.dart';
import 'package:dartz/dartz.dart';

class GetJobs {
  final JobRepository _repository;

  GetJobs(this._repository);

  Future<Either<Failure, List<Job>>> execute() async {
    return await _repository.getJobs();
  }
}
