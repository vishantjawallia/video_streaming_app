import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String name);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, User>> updateProfile(String name, String? profileImageUrl);
}
