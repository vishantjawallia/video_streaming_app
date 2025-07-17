# Video Streaming App

A production-level Flutter streaming app built with Clean Architecture, BLoC pattern, and Test-Driven Development (TDD).

## Features

### 🎬 Core Features
- **Splash Screen** - App logo animation with smooth transitions
- **User Onboarding** - Multi-screen onboarding with PageView and smooth page indicator
- **Profile Management** - Email login, profile image upload, and local storage
- **Home Screen** - Video list with SliverAppBar, search, and category filtering
- **Video Details** - Comprehensive video information with Hero animations
- **Video Player** - Full-featured player with chewie + video_player
- **Responsive UI** - Adaptive theming and screen size optimization

### 🏗️ Architecture
- **Clean Architecture** - Separation of concerns with domain, data, and presentation layers
- **BLoC Pattern** - State management with flutter_bloc
- **Repository Pattern** - Data abstraction and dependency inversion
- **TDD Approach** - Unit tests for business logic and BLoC testing

### 🛠️ Technical Stack
- **Flutter** - Cross-platform UI framework
- **go_router** - Navigation and deep linking
- **flutter_screenutil** - Responsive UI scaling
- **adaptive_theme** - Dynamic theming support
- **chewie + video_player** - Video playback
- **shared_preferences** - Local data persistence
- **image_picker** - Profile image selection
- **cached_network_image** - Image caching
- **shimmer** - Loading placeholders
- **share_plus** - Social sharing

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configurations
│   ├── errors/            # Error handling and failure classes
│   ├── router/            # Navigation setup with go_router
│   └── utils/             # Shared utilities (Either, etc.)
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer (repositories, models)
│   │   ├── domain/        # Business logic (entities, use cases)
│   │   └── presentation/  # UI layer (screens, BLoCs)
│   ├── home/              # Home screen feature
│   ├── onboarding/        # Onboarding feature
│   ├── profile/           # Profile management feature
│   ├── splash/            # Splash screen feature
│   └── video_player/      # Video player feature
└── main.dart              # App entry point

test/
├── unit/                  # Unit tests
│   └── blocs/            # BLoC tests
├── integration/           # Integration tests
└── widget/               # Widget tests
```

## Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/video_streaming_app.git
   cd video_streaming_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/blocs/home_bloc_test.dart

# Run tests with coverage
flutter test --coverage
```

## Architecture Overview

### Clean Architecture Layers

1. **Domain Layer** (Business Logic)
   - Entities: Core business objects
   - Use Cases: Business rules and operations
   - Repository Interfaces: Data access contracts

2. **Data Layer** (Data Management)
   - Repository Implementations: Data access logic
   - Data Sources: API and local data sources
   - Models: Data transfer objects

3. **Presentation Layer** (UI)
   - BLoCs: State management
   - Screens: UI components
   - Widgets: Reusable UI elements

### BLoC Pattern Implementation

```dart
// Event
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoadVideos extends HomeEvent {
  const LoadVideos();
}

// State
abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeLoaded extends HomeState {
  final List<Video> videos;
  const HomeLoaded({required this.videos});
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetVideos getVideos;

  HomeBloc({required this.getVideos}) : super(HomeInitial()) {
    on<LoadVideos>(_onLoadVideos);
  }

  Future<void> _onLoadVideos(LoadVideos event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await getVideos(const GetVideosParams());
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (videos) => emit(HomeLoaded(videos: videos)),
    );
  }
}
```

### TDD Approach

The project follows Test-Driven Development principles:

1. **Write failing tests first**
2. **Implement minimal code to pass tests**
3. **Refactor while keeping tests green**

Example test structure:
```dart
blocTest<HomeBloc, HomeState>(
  'emits [HomeLoading, HomeLoaded] when LoadVideos is successful',
  build: () => homeBloc,
  act: (bloc) => bloc.add(const LoadVideos()),
  expect: () => [
    isA<HomeLoading>(),
    isA<HomeLoaded>(),
  ],
);
```

## Key Features Implementation

### 1. Splash Screen
- Animated logo with scale and fade effects
- Automatic navigation based on onboarding status
- Shared preferences integration

### 2. Onboarding
- PageView with smooth page indicator
- Multi-screen introduction flow
- Onboarding completion tracking

### 3. Home Screen
- SliverAppBar with gradient background
- Video list with shimmer loading
- Search functionality with SearchDelegate
- Category filtering with horizontal chips

### 4. Video Player
- Chewie integration for enhanced controls
- Fullscreen support
- Playback speed control
- Custom progress indicators

### 5. Profile Management
- Image picker integration
- Form validation
- Local data persistence
- Settings management

## Environment Configuration

Create a `.env` file in the root directory:

```env
API_BASE_URL=https://api.example.com
API_KEY=your_api_key_here
```

## Build and Deploy

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing Strategy

### Unit Tests
- BLoC state management testing
- Use case business logic testing
- Repository data access testing

### Widget Tests
- Screen component testing
- User interaction testing
- Navigation flow testing

### Integration Tests
- End-to-end user journey testing
- API integration testing
- Database operations testing

## Performance Considerations

- **Image Caching**: Using cached_network_image for efficient image loading
- **Lazy Loading**: ListView.builder for large video lists
- **Memory Management**: Proper disposal of controllers and streams
- **State Management**: Efficient BLoC state updates

## Security

- **Input Validation**: Form validation and sanitization
- **Secure Storage**: Shared preferences for sensitive data
- **API Security**: Proper error handling and authentication
- **Image Upload**: Secure file handling and validation

## Future Enhancements

- [ ] Push notifications
- [ ] Offline video caching
- [ ] Social features (comments, likes)
- [ ] Advanced search filters
- [ ] Video upload functionality
- [ ] Analytics integration
- [ ] A/B testing support
- [ ] Accessibility improvements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- BLoC library contributors
- Clean Architecture principles by Robert C. Martin
- Test-Driven Development methodology
