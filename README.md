# Centurion WorkerHub

A comprehensive workforce management system built with Flutter for mobile frontend and Spring Boot for backend services. The system provides role-based access for workers, managers, and public users with features like GPS-based attendance tracking, real-time chat, and complaint management.

## 🚀 Features

### 👷 Worker Features
- **GPS-Based Attendance**: Check-in/check-out with location verification within 50m radius of Centurion University Vizianagram
- **Selfie Verification**: Front camera capture for attendance authentication
- **Real-time Dashboard**: View work assignments, attendance history, and performance metrics
- **Task Management**: Receive and update task assignments
- **Chat System**: Real-time communication with managers and team members

### 👨‍💼 Manager Features
- **Team Overview**: Monitor worker attendance and performance
- **Task Assignment**: Create and assign tasks to workers
- **Complaint Management**: Review and assign complaints to appropriate workers
- **Analytics Dashboard**: View attendance statistics and work progress
- **Real-time Monitoring**: Live updates on worker activities

### 👥 Public User Features
- **Complaint Submission**: Submit complaints with text and image attachments
- **Status Tracking**: Track complaint resolution progress
- **Feedback System**: Provide feedback on completed work
- **User Registration**: Self-registration for public users

## 🏗️ Architecture

### Frontend (Flutter)
- **State Management**: BLoC pattern with flutter_bloc
- **Navigation**: go_router for type-safe routing
- **UI Framework**: Material Design 3 with custom theming
- **Animations**: flutter_animate for smooth transitions
- **Local Storage**: shared_preferences for user preferences
- **Real-time**: WebSocket integration with web_socket_channel

### Backend (Planned)
- **Framework**: Spring Boot with Kotlin
- **Database**: MySQL with JPA/Hibernate
- **Authentication**: Google OAuth 2.0 API
- **Cloud Platform**: Google Cloud Platform
- **Real-time**: WebSocket support for chat and notifications

### Key Dependencies
```yaml
dependencies:
  flutter_bloc: ^8.1.4          # State management
  go_router: ^13.0.0            # Navigation
  flutter_animate: ^4.2.0       # Animations
  geolocator: ^10.1.0           # GPS location services
  camera: ^0.10.5+9             # Camera functionality
  image_picker: ^1.0.7          # Image selection
  web_socket_channel: ^2.4.5    # Real-time communication
  shared_preferences: ^2.2.2    # Local storage
  intl: ^0.18.1                 # Internationalization
  dartz: ^0.10.1                # Functional programming
```

## 📱 Project Structure

```
lib/
├── app/
│   ├── routes/                 # App routing configuration
│   └── theme/                  # App theming and styles
├── core/
│   ├── error/                  # Error handling
│   ├── strings/                # String constants
│   └── utils/                  # Utility functions
└── features/
    ├── attendance/             # Attendance tracking module
    ├── auth/                   # Authentication module
    ├── chat/                   # Real-time chat system
    ├── dashboard/              # Role-based dashboards
    ├── notifications/          # Push notifications
    ├── settings/               # User settings and profile
    └── tasks/                  # Task management
```

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher
- Android Studio or VS Code
- Android device/emulator (Android 7.0+) or iOS device/simulator (iOS 12.0+)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd project_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure permissions**
   
   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.INTERNET" />
   ```

   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access for attendance selfie verification</string>
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs location access for attendance verification</string>
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🎯 Key Features Implementation

### GPS-Based Attendance
- **Location**: Centurion University Vizianagram (18.1124°N, 83.4316°E)
- **Radius**: 50-meter verification radius
- **Technology**: geolocator package for precise location tracking
- **Verification**: Real-time distance calculation and validation

### Selfie Verification
- **Camera**: Front-facing camera integration
- **Storage**: Image capture and secure storage
- **Validation**: Attendance linked with selfie timestamp

### Role-Based Access
- **Worker Dashboard**: Attendance, tasks, chat
- **Manager Dashboard**: Team oversight, analytics, complaint management
- **Public Interface**: Complaint submission and tracking

### Real-time Features
- **WebSocket Chat**: Instant messaging between users
- **Live Updates**: Real-time dashboard updates
- **Push Notifications**: Important alerts and reminders

## 🔧 Configuration

### Environment Setup
Create environment-specific configuration files for different deployment stages:

- `lib/core/config/dev_config.dart` - Development configuration
- `lib/core/config/prod_config.dart` - Production configuration

### Google OAuth Setup (Planned)
1. Create Google Cloud Project
2. Enable Google+ API
3. Configure OAuth consent screen
4. Add client IDs for Android/iOS
5. Update configuration files

## 📊 Database Schema (Planned)

### Core Tables
- **users**: User profiles with Google OAuth integration
- **attendance_records**: GPS and selfie-verified attendance
- **tasks**: Work assignments and tracking
- **complaints**: Public complaint management
- **chat_messages**: Real-time messaging system
- **notifications**: Push notification management

## 🚀 Deployment

### Mobile App Deployment
- **Android**: Google Play Store
- **iOS**: Apple App Store

### Backend Deployment (Planned)
- **Platform**: Google Cloud Platform
- **Services**: Cloud Run, Cloud SQL, Cloud Storage
- **CI/CD**: GitHub Actions integration

## 🧪 Testing

Run tests using:
```bash
flutter test
```

### Test Coverage
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Version History

- **v1.0.0** - Initial release with core attendance and dashboard features
- **v1.1.0** - Added real-time chat system
- **v1.2.0** - Enhanced UI/UX with Material Design 3

---

**Centurion WorkerHub** - Streamlining workforce management with modern technology.
