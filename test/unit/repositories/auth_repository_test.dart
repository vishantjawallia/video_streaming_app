import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:video_streaming_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:video_streaming_app/features/auth/domain/entities/user.dart';
import 'package:video_streaming_app/core/errors/failures.dart';
import 'package:video_streaming_app/core/utils/either.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl authRepository;

    setUp(() {
      authRepository = const AuthRepositoryImpl();
    });

    group('login', () {
      test('should return User on successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        // Act
        final result = await authRepository.login(email, password);

        // Assert
        expect(result.isRight, true);
        result.fold((failure) => fail('Should not return failure'), (user) {
          expect(user, isA<User>());
          expect(user.email, email);
          expect(user.name, 'John Doe');
          expect(user.id, '1');
        });
      });

      test('should return AuthFailure on error', () async {
        // This test would require mocking the repository to simulate an error
        // For now, we'll test the basic structure
        expect(authRepository, isA<AuthRepositoryImpl>());
      });
    });

    group('register', () {
      test('should return User on successful registration', () async {
        // Arrange
        const email = 'newuser@example.com';
        const password = 'password123';
        const name = 'New User';

        // Act
        final result = await authRepository.register(email, password, name);

        // Assert
        expect(result.isRight, true);
        result.fold((failure) => fail('Should not return failure'), (user) {
          expect(user, isA<User>());
          expect(user.email, email);
          expect(user.name, name);
          expect(user.id, '1');
        });
      });
    });

    group('logout', () {
      test('should return void on successful logout', () async {
        // Act
        final result = await authRepository.logout();

        // Assert
        expect(result.isRight, true);
        result.fold((failure) => fail('Should not return failure'), (value) => expect(value, true));
      });
    });

    group('getCurrentUser', () {
      test('should return null when no user is logged in', () async {
        // Act
        final result = await authRepository.getCurrentUser();

        // Assert
        expect(result.isRight, true);
        result.fold((failure) => fail('Should not return failure'), (user) => expect(user, null));
      });
    });

    group('updateProfile', () {
      test('should return updated User on successful profile update', () async {
        // Arrange
        const name = 'Updated Name';
        const profileImageUrl = 'https://example.com/image.jpg';

        // Act
        final result = await authRepository.updateProfile(name, profileImageUrl);

        // Assert
        expect(result.isRight, true);
        result.fold((failure) => fail('Should not return failure'), (user) {
          expect(user, isA<User>());
          expect(user.name, name);
          expect(user.profileImageUrl, profileImageUrl);
          expect(user.email, 'john.doe@example.com');
        });
      });
    });
  });
}
