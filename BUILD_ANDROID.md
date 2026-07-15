# Android Build Instructions for FastPaced 1v1 FPS

## Prerequisites

Before building the APK, you need to install:

1. **Godot 4.2+**
   - Download from https://godotengine.org/download
   - Extract to a known location

2. **Android SDK** (API 33+)
   - Download Android Studio: https://developer.android.com/studio
   - Or download Android SDK command-line tools

3. **Android NDK** (r21e or later)
   - Required for Godot Android export
   - Install via Android Studio SDK Manager

4. **Java Development Kit (JDK)**
   - Install JDK 11+ from https://www.oracle.com/java/technologies/javase-downloads.html
   - Or use OpenJDK

## Quick Build Steps

### Step 1: Configure Godot for Android
1. Open the project in Godot 4.2
2. Go to **Project → Project Settings → Export**
3. Click **Add Preset** and select **Android**
4. Configure the following:
   - **SDK Path**: Point to your Android SDK folder
   - **NDK Path**: Point to your NDK folder
   - **Java SDK Path**: Point to your JDK folder
   - **Android API Level**: 33 or higher
   - **Target SDK**: 34 or higher
   - **Min SDK**: 21

### Step 2: Set App Permissions & Settings
1. In Export Preset → Android:
   - **App Name**: FastPaced 1v1 FPS
   - **Package**: com.wayneysphone.fastpaced1v1fps
   - **Version Code**: 1
   - **Version Name**: 0.1.0
   - **Permissions**: Enable INTERNET, WRITE_EXTERNAL_STORAGE
   - **Orientation**: Portrait or Landscape (based on preference)

### Step 3: Build APK
1. Click **Export Project**
2. Select **Android (APK)** from the list
3. Choose output location (e.g., Desktop)
4. Click **Export**
5. Wait 2-10 minutes for compilation

### Step 4: Install on Device
```bash
# Via ADB (Android Debug Bridge)
adb install fastpaced-1v1-fps.apk

# Or manually:
# Transfer APK to your Android device and tap to install
```

## Troubleshooting

### "SDK not found"
- Verify Android SDK path in Project Settings
- Ensure you installed via Android Studio SDK Manager

### "NDK not found"
- Download NDK from Android Studio: Tools → SDK Manager → SDK Tools → NDK (side by side)

### "Java not found"
- Check JAVA_HOME environment variable is set
- Run: `java -version` in terminal to verify

### Build Takes Too Long
- First build is slowest (5-10 min)
- Subsequent builds are faster (1-2 min)
- Close other apps to speed up compilation

## Output

Once complete, you'll have:
- `fastpaced-1v1-fps.apk` - Debug APK (for testing)
- `fastpaced-1v1-fps-release.apk` - Release APK (for distribution)

## Next Steps

1. Install APK on Android device
2. Test movement (WASD, Space, E)
3. Test weapon switching (1-9, mouse wheel)
4. Test firing (Left Mouse Button)
5. Report any issues!

---

For detailed Godot Android documentation, visit:
https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html