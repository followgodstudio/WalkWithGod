# walk_with_god

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Prerequisite & install (MacOS)

MacOS Prerequisite: homebrew
Recommend install VS Code Studio, Android Studio and XCode

### Install Dart SDK

Here is an example to install Dart SDK version 2.13 for MacOS.
See https://dart.dev/get-dart for details.

```
brew tap dart-lang/dart
brew install dart@2.13
echo 'export PATH="$PATH:/opt/homebrew/home/dart@2.13/bin"' >> ~/.zshrc
```

### Install Flutter SDK

Here is an example to install Flutter SDK version 2.5.0 for MacOS. (Change haley to your username)
See https://flutter.dev/docs/get-started/install/macos for details.

```
curl https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.5.0-stable.zip --output ./flutter_windows_2.5.0-stable.zip
sudo unzip ./flutter_windows_2.5.0-stable.zip -d /Users/haley/Programs
echo 'export PATH="$PATH:/Users/haley/Programs/flutter/bin"' >> ~/.zshrc
sudo chown -R haley flutter
rm ./flutter_windows_2.5.0-stable.zip
```

### Tell if the environment is ready
```
flutter doctor -v
```

### Install Android SDK Command-line Tools in Android Studio
Preferences > Appearance & Behavior > System Settings > Android SDK > SDK Tools > Android SDK Command-line Tools (latest)

### Accept Android license
```
flutter doctor --android-licenses
```

### Create a Android Emulator in Android Studio
Tools > AVD Manager
for example, I am using Pixel 4 & API Level 31

### Install packages
```
flutter pub get
```

## For app release
generate aab
```
flutter build appbundle --flavor prod -t lib/main_prod.dart --build-number 10
```
generate apk
```
flutter build apk --debug --flavor prod -t lib/main_prod.dart
```

## For Firebase Cloud Function
```
firebase emulators:start
firebase deploy --only functions:user_notifications-pushMessage
```

## Switch Firebase environment
```
firebase use walkwithgod-dev
firebase use  walkwithgod-73ee8
```

## Generate SHA Key
Add the generated SHA Key to firebase
```
cd android
./gradlew signingReport
```

generate a SHA key if not available
```
keytool -genkey -v -keystore /Users/haley/.android/debug.keystore -alias AndroidDebugKey
```

list SHA key
```
keytool -list -v -keystore /Users/haley/.android/debug.keystore -alias AndroidDebugKey -storepass android -keypass android 
```

## Generate JKS key (For app release)
Sharing the same key for google play store deploy
Add file: android/key.properties

storePassword=$our_key_not_commited_in_github$
keyPassword=$our_key_not_commited_in_github$
keyAlias=suixing
storeFile=/Users/haley/key.jks

## Google Play Store
Add the generated SHA Key to firebase
```
cd android
./gradlew signingReport
```

You might need to [install JAVA JDK](https://www.oracle.com/java/technologies/downloads/#jdk17-mac) if not available. 
[Download dmg](https://download.oracle.com/java/17/latest/jdk-17_macos-aarch64_bin.dmg) and click to install it.