# Lastbite - Food Ordering App

A Flutter-based mobile application, backed by a Node.js backend, designed to streamline food ordering and delivery.

## Key Features & Benefits

*   **Intuitive User Interface:** A user-friendly Flutter interface for seamless navigation and order placement.
*   **Node.js Backend:** A robust Node.js backend to handle order management, user authentication, and data persistence.
*   **Firebase Integration (Partial):** Initial setup for Firebase, allowing for functionalities like user authentication and real-time database interactions (requires further configuration).
*   **Cross-Platform Compatibility:** Built with Flutter, the app can be deployed on both Android and iOS platforms.
*   **Scalable Architecture:** Designed with scalability in mind, accommodating future features and increasing user base.

## Prerequisites & Dependencies

Before you begin, ensure you have the following installed:

*   **Flutter SDK:** Version 3.0 or higher ([https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install))
*   **Node.js:** Version 16.0 or higher ([https://nodejs.org/en/download/](https://nodejs.org/en/download/))
*   **npm (Node Package Manager):** Usually comes with Node.js installation.
*   **Android Studio/Xcode:** For building and running the Flutter app on respective platforms.
*   **Firebase Account:** Required for setting up Firebase integration ([https://console.firebase.google.com/](https://console.firebase.google.com/)).  (Note: Backend Firebase functions are not included in this repository but could be added later).

**Languages & Technologies Used:**

*   **Client (Flutter):**
    *   Dart
    *   C++ (Flutter Engine)
    *   Kotlin (Android Native)
    *   Swift (iOS Native)
*   **Server (Node.js - Not included in this Repo):**
    *   JavaScript

## Installation & Setup Instructions

**1. Clone the Repository:**

```bash
git clone https://github.com/kaustubhvasagadekar/Lastbite.git
cd Lastbite
```

**2. Set up the Flutter App:**

```bash
cd flutter/last_bite
flutter pub get
```

**3. Firebase Setup (Important!):**

   a.  Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)
   b.  Register your Android app with Firebase:
        *   Package name: `com.example.last_bite`
        *   App nickname: `Last Bite`
   c.  Download the `google-services.json` file and place it in the `flutter/last_bite/android/app/` directory.
   d.  For iOS: download `GoogleService-Info.plist` and add it to your Xcode project.
   e. Follow any additional Firebase setup steps for your specific needs (authentication, database, etc.).

**4. Run the Flutter App:**

```bash
flutter run
```

Choose the target device (Android emulator, iOS simulator, or connected device).

**5. Node.js Backend (Separate Setup - not included in this repo):**

   a. You'll need to set up a separate Node.js backend project (not included in this repository) for complete functionality.
   b. The Flutter app will need to connect to this backend for data retrieval and order processing.  Ensure the API endpoints in your flutter app are correctly pointed at your backend.

## Usage Examples & API Documentation

Since the backend is not included, specific API documentation isn't available in this repository.  However, typical usage scenarios might include:

*   **Fetching Menu Items:**  The Flutter app would send a `GET` request to a Node.js endpoint like `/api/menu` to retrieve the list of available food items.
*   **Placing an Order:**  A `POST` request to `/api/orders` with order details in JSON format.
*   **User Authentication:** Endpoints like `/api/register` and `/api/login` (if user accounts are implemented in the backend).

## Configuration Options

*   **Firebase Configuration:** Adjust Firebase settings directly within the Firebase console.  The downloaded `google-services.json` and `GoogleService-Info.plist` files contain platform specific configuration.
*   **API Endpoint URLs:** Modify the API endpoint URLs in the Flutter app to match your Node.js backend's configuration. This will typically be in a `config.dart` or similar file.
*   **Launch Screen Assets:** Customize the launch screen assets by replacing the image files in the `flutter/last_bite/ios/Runner/Assets.xcassets/LaunchImage.imageset/` directory. Open the Xcode project with `open ios/Runner.xcworkspace`, selecting `Runner/Assets.xcassets` and dropping in your images.

## Contributing Guidelines

We welcome contributions to Lastbite! To contribute:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes and commit them with clear, descriptive messages.
4.  Submit a pull request.

Please follow our coding style guidelines and ensure your code is well-documented.

## License Information

This project does not currently specify a license. All rights are reserved by the owner.

## Acknowledgments

*   Flutter team for the excellent cross-platform framework.
*   Node.js community for the versatile server-side environment.
*   Firebase team for providing essential mobile app development tools.
