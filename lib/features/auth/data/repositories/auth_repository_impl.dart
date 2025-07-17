import '../../../../core/errors/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl();

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful login
      return Either.right(User(id: '1', email: email, name: 'John Doe', createdAt: DateTime.now()));
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful registration
      return Either.right(User(id: '1', email: email, name: name, createdAt: DateTime.now()));
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // Simulate logout process
      await Future.delayed(const Duration(milliseconds: 500));
      return Either.right(true);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // Mock implementation - return null for now
      return Either.right(null);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(String name, String? profileImageUrl) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful profile update
      return Either.right(User(id: '1', email: 'john.doe@example.com', name: name, profileImageUrl: profileImageUrl, createdAt: DateTime.now()));
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }
}
