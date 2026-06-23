import 'package:bloc_clean_architecture/src/comman/failure.dart';
import 'package:bloc_clean_architecture/src/domain/repositories/autentication_repository.dart';
import 'package:dartz/dartz.dart';

class SignInWithGoogle {
  SignInWithGoogle(this._repository);
  final AuthenticationRepository _repository;

  Future<Either<Failure, void>> execute() async {
    return await _repository.signInWithGoogle();
  }
}
