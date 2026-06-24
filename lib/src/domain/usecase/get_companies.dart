import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/entities/company.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/job_repository.dart';
import 'package:dartz/dartz.dart';

class GetCompanies {
  final JobRepository _repository;

  GetCompanies(this._repository);

  Future<Either<Failure, List<Company>>> execute() async {
    return await _repository.getCompanies();
  }
}
