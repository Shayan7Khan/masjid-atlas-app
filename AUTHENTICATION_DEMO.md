# Flutter Authentication Demo

This is a comprehensive authentication demo app built with Flutter that demonstrates user registration, login, session management, and logout functionality.

## 🚀 Features

- **User Registration**: Create new accounts with email, password, and name
- **User Login**: Secure login with email and password validation
- **Session Management**: Automatic login persistence across app restarts
- **Logout**: Secure logout with session cleanup
- **Beautiful UI**: Modern, responsive design with smooth animations
- **Mock Backend**: Complete demo with mock database service

## 📱 Demo Credentials

For testing purposes, you can use these pre-created accounts:

```
Email: demo@example.com
Password: password123

Email: admin@example.com
Password: admin123
```

Or create a new account using the signup form.

## 🏗️ Architecture Overview

### Project Structure

```
lib/
├── core/
│   ├── models/           # Data models (User, LoginBody, etc.)
│   ├── services/         # Business logic services
│   │   ├── auth_service.dart          # Authentication logic
│   │   ├── local_storage_service.dart # Local data persistence
│   │   ├── mock_database_service.dart # Mock backend for demo
│   │   └── ...
│   └── enums/            # App-wide enums
├── ui/
│   └── screens/          # UI screens
│       ├── simple_splash_screen.dart  # App initialization
│       ├── simple_login_screen.dart   # Login form
│       ├── simple_signup_screen.dart  # Registration form
│       └── simple_home_screen.dart    # Main app screen
├── locator.dart          # Dependency injection setup
├── simple_main.dart      # App entry point
└── simple_app.dart       # App configuration
```

## 🔄 Data Flow Explanation

### 1. App Startup Flow

```
simple_main.dart
    ↓
setupLocator() - Initialize dependency injection
    ↓
SimpleApp
    ↓
SimpleSplashScreen
    ↓
AuthService.doSetup() - Check login status
    ↓
Navigate to LoginScreen OR HomeScreen
```

### 2. Authentication Flow

#### Login Process:

```
LoginScreen
    ↓
User enters credentials
    ↓
LoginViewModel.requestLogin()
    ↓
AuthService.loginWithEmailAndPassword()
    ↓
MockDatabaseService.loginWithEmailAndPassword()
    ↓
Validate credentials
    ↓
Save user data to LocalStorageService
    ↓
Navigate to HomeScreen
```

#### Registration Process:

```
SignUpScreen
    ↓
User fills registration form
    ↓
AuthService.signupWithEmailAndPassword()
    ↓
MockDatabaseService.createAccount()
    ↓
Create new user account
    ↓
Save user data to LocalStorageService
    ↓
Navigate to HomeScreen
```

#### Logout Process:

```
HomeScreen
    ↓
User clicks logout
    ↓
AuthService.logout()
    ↓
Clear FCM token from server
    ↓
Clear all data from LocalStorageService
    ↓
Navigate to LoginScreen
```

### 3. Session Management

The app uses `LocalStorageService` (built on SharedPreferences) to persist:

- User authentication token
- User profile data
- Login status
- Onboarding state

When the app starts:

1. `SplashScreen` initializes `LocalStorageService`
2. `AuthService.doSetup()` checks if user is logged in
3. If logged in, loads user data from storage
4. If not logged in, shows login screen

## 🛠️ Key Components

### AuthService

The central service managing all authentication operations:

- `doSetup()`: Initialize app and check login status
- `loginWithEmailAndPassword()`: Handle user login
- `signupWithEmailAndPassword()`: Handle user registration
- `logout()`: Handle user logout and cleanup
- `_loadUserFromStorage()`: Load persisted user data
- `_updateFcmToken()`: Update Firebase Cloud Messaging token

### LocalStorageService

Handles local data persistence:

- `accessToken`: Store authentication token
- `userData`: Store user profile information
- `isLoggedIn`: Track login status
- `clearUserData()`: Clean up all user data on logout

### MockDatabaseService

Simulates backend API calls:

- `loginWithEmailAndPassword()`: Mock login validation
- `createAccount()`: Mock user registration
- `getUserProfile()`: Mock user profile retrieval
- `updateFcmToken()`: Mock FCM token update
- `clearFcmToken()`: Mock FCM token cleanup

## 🎨 UI Components

### SimpleSplashScreen

- Animated splash screen with logo
- Initializes app services
- Checks authentication status
- Navigates to appropriate screen

### SimpleLoginScreen

- Email and password input fields
- Form validation
- Login button with loading state
- Link to registration screen
- Demo credentials display

### SimpleSignUpScreen

- Registration form with validation
- Name, email, password, and confirm password fields
- Sign up button with loading state
- Link back to login screen

### SimpleHomeScreen

- Welcome message with user info
- User profile display
- Quick action cards
- Logout button with confirmation dialog

## 🚀 How to Run

### Option 1: Run the Authentication Demo

```bash
# Run the simple authentication demo
flutter run lib/simple_main.dart
```

### Option 2: Run the Original App

```bash
# Run the original boilerplate app
flutter run lib/main.dart
```

## 🔧 Configuration

### Environment Setup

The app uses environment-based configuration:

- `Env.development`: For development with mock services
- `Env.production`: For production with real backend

### Dependency Injection

Uses `get_it` package for dependency injection:

- Services are registered in `locator.dart`
- Services are injected where needed using `locator<ServiceType>()`

## 📝 Why This Architecture?

### 1. Separation of Concerns

- **Models**: Pure data structures
- **Services**: Business logic
- **Screens**: UI presentation
- **ViewModels**: UI state management

### 2. Dependency Injection

- Makes testing easier
- Promotes loose coupling
- Allows for easy service swapping (mock vs real)

### 3. Service Layer Pattern

- Centralized business logic
- Reusable across different UI components
- Easy to maintain and extend

### 4. Local Storage Abstraction

- Encapsulates SharedPreferences complexity
- Provides type-safe data access
- Easy to swap storage implementations

### 5. Mock Services

- Allows development without backend
- Demonstrates real-world patterns
- Easy to replace with actual API calls

## 🔄 Converting to Real Backend

To use with a real backend:

1. **Replace MockDatabaseService**: Create a real `DatabaseService` that makes HTTP calls
2. **Update API endpoints**: Point to your actual backend URLs
3. **Add error handling**: Handle network errors, timeouts, etc.
4. **Add token refresh**: Implement JWT token refresh logic
5. **Add offline support**: Cache data for offline usage

Example real service structure:

```dart
class DatabaseService {
  final Dio _dio = Dio();

  Future<AuthResponse> loginWithEmailAndPassword(LoginBody body) async {
    try {
      final response = await _dio.post('/auth/login', data: body.toJson());
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      return AuthResponse(false, error: e.toString());
    }
  }
}
```

## 🎯 Key Learning Points

1. **State Management**: Using Provider pattern with ChangeNotifier
2. **Navigation**: Using GetX for navigation and state management
3. **Form Validation**: Comprehensive form validation with user feedback
4. **Loading States**: Proper loading indicators during async operations
5. **Error Handling**: User-friendly error messages and snackbars
6. **Session Persistence**: Automatic login across app restarts
7. **Clean Architecture**: Separation of concerns and dependency injection
8. **Mock Services**: Development without backend dependencies

This demo provides a solid foundation for building production-ready Flutter apps with authentication!
