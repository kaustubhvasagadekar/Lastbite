# Last Bite

A Flutter application for managing food orders with Firebase integration.

## Firebase Setup Instructions

To complete the Firebase setup for this project, follow these steps:

1. Create a Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)

2. Register your Android app with Firebase:
   - Package name: `com.example.last_bite`
   - App nickname: `Last Bite`

3. Download the `google-services.json` file and place it in the `android/app` directory

4. For iOS setup (if needed):
   - Register your iOS app with Firebase
   - Download the `GoogleService-Info.plist` file and place it in the `ios/Runner` directory
   - Update your Podfile with Firebase dependencies

5. Enable Firestore Database in the Firebase console:
   - Go to Firestore Database in the Firebase console
   - Click "Create database"
   - Start in production mode or test mode based on your needs
   - Choose a location closest to your users

6. Set up Firestore security rules as needed for your application

## Features
- Real-time order management with Firestore
- Create and track food orders
- View order history
- Bottom navigation for easy access to different screens