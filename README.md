# 📿 Divine Mala — Premium Naam Jap Counter

A luxury spiritual Flutter app for Android (and iOS) with gold/saffron premium UI, 108-bead digital mala, mantra tracking, statistics, achievements, and cloud backup.

---

## 🗂 Project Structure

```
divine_mala/
├── lib/
│   ├── main.dart                          # Entry point
│   ├── firebase_options.dart              # Firebase config (replace with yours)
│   ├── theme/
│   │   └── app_theme.dart                 # Gold/saffron Material 3 theme
│   ├── models/
│   │   └── models.dart                    # Mantra, Session, Stats, Achievement
│   ├── providers/
│   │   └── app_providers.dart             # Riverpod state management
│   ├── services/
│   │   ├── audio_service.dart             # Temple bell / Om sounds
│   │   ├── haptic_service.dart            # Vibration feedback
│   │   ├── firestore_service.dart         # Cloud backup
│   │   └── notification_service.dart      # Daily reminders
│   ├── screens/
│   │   ├── main_shell.dart                # Splash + bottom nav shell
│   │   ├── counter_screen.dart            # Main 108-bead mala counter
│   │   ├── stats_screen.dart              # Statistics dashboard + charts
│   │   ├── mantra_selector_screen.dart    # Mantra picker + custom mantra
│   │   ├── goal_achievement_screens.dart  # Goal setter + achievements
│   │   └── settings_screen.dart          # Full settings
│   └── widgets/
│       └── home_widget.dart               # Android home screen widget
├── assets/
│   ├── sounds/
│   │   ├── temple_bell.mp3                # Add your audio files here
│   │   ├── om_short.mp3
│   │   ├── bead_click.mp3
│   │   ├── mala_complete.mp3
│   │   ├── goal_complete.mp3
│   │   └── meditation_bg.mp3
│   ├── images/                            # App images / icons
│   └── fonts/                             # Cinzel, PlayfairDisplay fonts
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   ├── proguard-rules.pro
│   │   └── src/main/AndroidManifest.xml
│   └── build.gradle
├── firestore.rules                        # Firestore security rules
├── PRIVACY_POLICY.md
└── pubspec.yaml
```

---

## ⚡ Quick Setup (Step by Step)

### Step 1 — Prerequisites
```bash
flutter --version   # Need Flutter 3.16+
java --version      # Need Java 17
```

### Step 2 — Clone & Install
```bash
cd divine_mala
flutter pub get
```

### Step 3 — Add Audio Assets
Download free spiritual sounds and place in `assets/sounds/`:
- **temple_bell.mp3** — https://freesound.org (search "temple bell")
- **om_short.mp3** — https://freesound.org (search "om chant")
- **bead_click.mp3** — https://freesound.org (search "bead click")
- **mala_complete.mp3** — Bell sequence sound
- **goal_complete.mp3** — Celebration sound
- **meditation_bg.mp3** — Soft background music

### Step 4 — Add Fonts
Download from Google Fonts and place in `assets/fonts/`:
```
https://fonts.google.com/specimen/Cinzel
https://fonts.google.com/specimen/Playfair+Display
```

### Step 5 — Firebase Setup (Optional but recommended)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```
This auto-generates `lib/firebase_options.dart`. Replace the placeholder file.

Also update `main.dart`:
```dart
import 'firebase_options.dart';
// In main():
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### Step 6 — AdMob Setup
1. Create app in AdMob console: https://admob.google.com
2. Replace in `AndroidManifest.xml`:
   ```xml
   android:value="ca-app-pub-YOUR_APP_ID"
   ```
3. Create ad units and add IDs to your ad service implementation.

### Step 7 — Google Sign-In Setup
1. In Firebase Console → Authentication → Sign-in method → Enable Google
2. Download `google-services.json` → place in `android/app/`
3. Add your SHA-1 fingerprint in Firebase project settings:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

### Step 8 — Run
```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# Release AAB (for Play Store)
flutter build appbundle --release
```

---

## 🎨 Features Implemented

| Feature | Status |
|---|---|
| 108-bead digital mala with animation | ✅ |
| Gold/saffron premium theme (dark + light) | ✅ |
| 7 preloaded mantras (Krishna, Shiva, Gayatri...) | ✅ |
| Custom mantra creation | ✅ |
| Tap-to-count with haptic + sound feedback | ✅ |
| Session timer | ✅ |
| Goal system (108, 1008, custom) | ✅ |
| Progress ring | ✅ |
| Daily / weekly / monthly stats | ✅ |
| Bar chart (7-day) | ✅ |
| Streak tracking + calendar heatmap | ✅ |
| Mantra breakdown pie | ✅ |
| 9 achievements / badges | ✅ |
| Completion confetti animation | ✅ |
| Daily reminder notifications | ✅ |
| Dark mode / Light mode toggle | ✅ |
| Bead style selector (Rudraksha, Crystal, Lotus, Gold) | ✅ |
| Background theme selector (Premium) | ✅ |
| Background music toggle (Premium) | ✅ |
| Cloud backup via Firestore (Premium) | ✅ |
| Google Sign-In | ✅ |
| Home screen widget (Android) | ✅ |
| Screen wake lock during Jap | ✅ |
| Freemium model + Premium banner | ✅ |
| Privacy Policy | ✅ |
| ProGuard rules for release | ✅ |
| Firestore security rules | ✅ |

---

## 🏪 Play Store Checklist

- [ ] Generate signed keystore: `keytool -genkey -v -keystore divine_mala.keystore`
- [ ] Configure signing in `android/app/build.gradle`
- [ ] Build AAB: `flutter build appbundle --release`
- [ ] Create app icons (use `flutter_launcher_icons` package)
- [ ] Create splash screen (use `flutter_native_splash` package)
- [ ] Upload screenshots (min 2 per form factor)
- [ ] Write store listing copy
- [ ] Set content rating (Everyone)
- [ ] Add privacy policy URL
- [ ] Set up in-app products in Play Console (premium subscription)
- [ ] Add AdMob app to Play Console

---

## 🔐 Signing Release Build

```bash
# 1. Generate keystore (do once, keep it safe!)
keytool -genkey -v \
  -keystore ~/divine_mala_release.keystore \
  -alias divine_mala \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# 2. Add to android/key.properties (DON'T commit this file!)
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=divine_mala
storeFile=/Users/you/divine_mala_release.keystore

# 3. Build signed AAB
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 💰 Monetization Configuration

### AdMob Banner (Free tier)
```dart
// In your screen widgets, add:
BannerAd(
  adUnitId: 'ca-app-pub-XXXX/XXXX',  // Replace
  size: AdSize.banner,
  request: const AdRequest(),
  listener: BannerAdListener(...),
)..load();
```

### In-App Purchase (Premium)
Product IDs to create in Play Console:
- `divine_mala_premium_yearly` — ₹299/year
- `divine_mala_premium_monthly` — ₹49/month
- `divine_mala_premium_lifetime` — ₹799 one-time

---

## 📞 Support

For integration help, raise an issue or contact the developer.

---

*🕉️ May your chanting bring peace, devotion, and liberation. Jai Shri Krishna! 🙏*
