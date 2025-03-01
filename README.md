# Lume 

Lume is a Flutter-based online dating application. The app is built with Supabase for the backend and GetX for state management, providing a seamless user experience.

<div style="display:flex;justify-content:center;flex-direction: row;flex-wrap: nowrap;">
  <img src="https://dl.dashnyam.com/lume_ss/1.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/2.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/3.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/4.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/5.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/6.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/7.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/8.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/9.webp" width="150" />
  <img src="https://dl.dashnyam.com/lume_ss/10.webp" width="150" />
</div>

## Features

### Core Features
- **User Authentication**: Sign up, log in, and manage accounts with Supabase authentication.
- **Profile Management**: Create, edit, and update your profile, including profile pictures, bio, and preferences.
- **Swipe & Match**: Swipe left or right on profiles to like or pass, and match with users who swipe right on you.
- **Chat**: Once matched, chat with other users in real-time.
- **Discover Page**: View profiles based on your preferences and geographical location.
- **Profile Discovery**: Explore other users' public profiles with their details and photos.
- **Account Management**: Update email, password, and notification preferences.

### Upcoming Features
- Fetch feed users based on max distance and age range
- Discover page where users can find partners with mutual interests
- Ability to delete profile info at any time
- Add more profile info customization (E.g. interests, education, workplace, family plans, drinking habit, and more)
- Ability to add more than 2 profile images, up to 9
- Dark theme

### Added Features
- Network detection for offline app handling (3.1.2025)


## Project Setup

### Prerequisites
- Flutter installed on your system.
- Supabase account and project for backend services.
- Supabase URL and Anon Key.
- API keys for APK signing (optional for development).

### Setup Instructions
1. Clone the repository.
2. Set up Supabase authentication info:
   - Create a file `/lib/auth/auth_key.dart`.
   - Refer to the example provided in `/lib/auth/auth_key_example.dart`.
3. (Optional) Set up APK signing keys for release builds:
   - Create the file `/android/key.properties` using `/android/key_example.properties` as a template.
   - Put your `.jks` or `.keystore` file in `/android/app/`.
4. Run the app:
   ```bash
   flutter pub get
   flutter run
   ```

## Folder Structure
The project is organized as follows:

```
lib/
|-- auth/                 # Authentication logic and examples
|-- constants/            # App-wide constants and configuration
|-- controllers/          # GetX controllers
|-- screens/              # UI screens
|-- theme/                # Styling and themes
|-- widgets/              # Reusable widgets
```

## Release Builds
You can download the latest release APK for Taskify from the [GitHub Releases](https://github.com/xicko/lume/releases).

## Contributing
Contributions are welcome! Please create an issue or submit a pull request for any bug fixes or new features.

## License
This project is open-source and available under the MIT License.
