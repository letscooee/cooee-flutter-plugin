## 0.1.0

1. Using Android SDK v0.3.0.
2. Add support to Android 11
3. Add ActivityLifecycle to observe In-App Trigger
4. Remove unwanted methods and files.
5. Fix Glassmorphism issue.

## 0.0.23

1. Using Android SDK v0.2.11.
2. All methods can now accept `Map<String, dynamic>`

## 0.0.22

1. Using Android SDK v0.2.10.

## 0.0.21

1. Added Glassmorphism effect.
2. Using Android SDK v0.2.9.

### Required Changes

Because of a limitation in how Flutter for Android handles Activity, we could not achieve Glassmorphism effect in Flutter applications
 without some extra code. For this to work, you have to add an extra line in each of your route widget.

Add `setContext()` method to each of your route widget. Check [Example](https://pub.dev/packages/cooee_plugin/example) for reference.
   
```diff
+   CooeePlugin().setContext(context);
```

## 0.0.16 - 0.0.20

1. Upgrading iOS native SDK to 1.2.4

## 0.0.9 - 0.0.15

1. Support of iOS.

## 0.0.8

1. Using v0.2.5 of the Android SDK

## 0.0.7

1. Using v0.2.4 of the Android SDK

## 0.0.6

1. Using v0.2.3 of the Android SDK
2. In-App trigger action button handling added.

## 0.0.5

1. Using v0.2.1 of the Android SDK.

## 0.0.4

1. Using v0.2.0 of the Android SDK.

## 0.0.3

1. Fix installing the plugin on the app.

## 0.0.2

1. Rename `CooeePluginFlutter` to `CooeePlugin`.
2. Use the latest version of Android SDK.

## 0.0.1

1. First release.
