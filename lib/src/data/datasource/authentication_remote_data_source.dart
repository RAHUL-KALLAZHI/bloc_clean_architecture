import 'package:bloc_clean_architecture/src/comman/api.dart';
import 'package:bloc_clean_architecture/src/comman/constant.dart';
import 'package:bloc_clean_architecture/src/comman/exception.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> login(String email, String password);
  Future<void> signInWithGoogle();
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<void> login(String email, String password) async {
    try {
    final prefs = await SharedPreferences.getInstance();
     final response = await dio.post<Map<String, dynamic>>(API.LOGIN, data: {
        'email': email,
        'password': password,
      });
      final token = response.data?['token']?.toString() ?? '';
      await prefs.setString(ACCESS_TOKEN, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: '281322148820-qd9ol105shh111k0labd6a1c5plo6kpr.apps.googleusercontent.com',
      );
      final googleUser = await googleSignIn.authenticate();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(ACCESS_TOKEN, idToken);
      } else {
        throw ServerException('Failed to get user ID token');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
