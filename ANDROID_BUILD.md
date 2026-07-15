# FastPaced 1v1 FPS - Android APK Build Guide

## 🎮 What You Have

A fully-featured fast-paced 1v1 FPS with:
- ✅ 14 unique weapons with distinct mechanics
- ✅ Advanced movement (slide, dash, jump)
- ✅ 1v1 match manager with scoring
- ✅ Full HUD system (health, ammo, timer)
- ✅ Damage calculation system
- ✅ Projectile physics engine

## 📱 Building for Android (APK)

### Quick Start (5 Minutes)

1. **Download & Install**:
   - Godot 4.2: https://godotengine.org
   - Android Studio: https://developer.android.com/studio
   - JDK 11+: https://www.oracle.com/java/technologies/javase-downloads.html

2. **Open the Project**:
   ```bash
   # Clone the repo
   git clone https://github.com/wayneysphone-droid/fastpaced-1v1-fps.git
   cd fastpaced-1v1-fps
   
   # Open in Godot
   # File → Open Project → Select this folder
   ```

3. **Configure Android Export**:
   - Go to **Project → Project Settings → Export**
   - Add Preset → Select **Android**
   - Configure paths (see `BUILD_ANDROID.md` for detailed steps)

4. **Build APK**:
   - Click **Export Project**
   - Select **Android (APK)**
   - Choose save location
   - Click **Export** and wait

5. **Install on Device**:
   ```bash
   adb install fastpaced-1v1-fps.apk
   ```

**That's it! You're done.** 🎉

### Detailed Setup

See **BUILD_ANDROID.md** for step-by-step troubleshooting and detailed configuration.

## 🎮 Controls (Mobile Touch)

Once installed, you can:
- **Move**: WASD (or touch D-pad)
- **Jump**: Space (or swipe up)
- **Slide**: Shift (or swipe left)
- **Dash**: E (or double-tap)
- **Fire**: Mouse Button 1 (or tap screen)
- **Reload**: R (or dedicated button)
- **Weapon Switch**: 1-9 or Mouse Wheel (or inventory UI)

## 🔧 Customization Before Build

Edit `project.godot` to change:
- **App Name**: config/name
- **Version**: config/version
- **Icon**: application/config/icon
- **Screen Orientation**: rendering/viewport

Edit `data/weapon_balance.json` to adjust:
- Weapon damage
- Fire rates
- Magazine sizes
- Movement penalties

## 📦 Output Files

After build, you'll get:
- `fastpaced-1v1-fps.apk` - For testing on your device
- `fastpaced-1v1-fps-release.apk` - For publishing to Play Store

## 📊 Project Size

- Source Code: ~150KB
- Assets (to be added): ~varies
- Final APK: ~20-50MB (depending on assets)

## 🚀 Next Steps After Build

1. Test on Android device
2. Adjust touch controls for mobile
3. Add mobile-optimized UI
4. Test performance on target devices
5. Publish to Google Play Store

## ❓ Need Help?

- **Godot Docs**: https://docs.godotengine.org
- **Android Export**: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- **GitHub Issues**: Create an issue in the repo

---

**Happy building! 🚀**