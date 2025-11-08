# Vehicle Parts App

A Flutter mobile application for managing and purchasing vehicle parts.

## Project Structure

This project follows a **Feature-First Architecture** with Clean Architecture principles. Each feature is self-contained with its own data, domain, and presentation layers:

```
lib/
├── app/                      # App-level configuration
│   └── app.dart             # Main app widget
│
├── core/                     # Core functionality (shared across features)
│   ├── constants/           # App constants
│   ├── theme/               # Theme configuration
│   ├── utils/               # Utility functions
│   ├── network/             # Network layer
│   ├── error/               # Error handling
│   └── routes/              # Navigation/routing
│
├── features/                 # Feature modules (Feature-First Architecture)
│   ├── auth/                # Authentication feature
│   │   ├── data/            # Data layer
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── datasources/
│   │   ├── domain/          # Domain layer
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/    # Presentation layer
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── providers/
│   ├── home/                # Home feature
│   ├── parts/               # Parts catalog feature
│   ├── cart/                # Shopping cart feature
│   ├── orders/              # Orders feature
│   ├── payment/             # Payment feature
│   └── profile/             # Profile feature
│
├── shared/                   # Shared UI components
│   ├── widgets/             # Reusable widgets
│   └── components/          # Shared components
│
└── config/                   # Configuration files
    └── env.dart             # Environment variables
```

## Features

- **Authentication**: User login and registration
- **Parts Catalog**: Browse and search vehicle parts
- **Shopping Cart**: Add and manage items in cart
- **Payment**: Multiple payment methods (Card, PayPal, Cash on Delivery)
- **Orders**: View and track orders
- **Profile**: User profile management

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the root directory:
   ```
   ENVIRONMENT=development
   API_BASE_URL=https://api.example.com
   API_KEY=your_api_key_here
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

### Main Dependencies
- **provider**: State management
- **go_router**: Navigation and routing
- **dio**: HTTP client for API calls
- **get_it**: Dependency injection
- **shared_preferences**: Local storage
- **json_annotation**: JSON serialization

### Dev Dependencies
- **flutter_test**: Testing framework
- **build_runner**: Code generation
- **json_serializable**: JSON serialization code generation

## Architecture

This project follows **Feature-First Architecture** with **Clean Architecture** principles:

### Feature-First Structure
Each feature is self-contained and independent:
- **Data Layer**: Models, repositories, and data sources specific to the feature
- **Domain Layer**: Business logic, entities, and use cases for the feature
- **Presentation Layer**: UI components, pages, widgets, and state management

### Benefits
- **Modularity**: Features can be developed and tested independently
- **Scalability**: Easy to add new features without affecting existing ones
- **Maintainability**: Clear separation of concerns within each feature
- **Team Collaboration**: Different teams can work on different features simultaneously

### Core & Shared
- **Core**: Shared utilities, network, theme, and routing used across all features
- **Shared**: Reusable UI components that can be used by multiple features

## Testing

Run tests with:
```bash
flutter test
```

## Building

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Write tests
4. Submit a pull request

## License

This project is private and proprietary.
