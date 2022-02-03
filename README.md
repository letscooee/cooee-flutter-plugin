# Cooee plugin for Flutter App

[![pub package](https://img.shields.io/pub/v/cooee_plugin.svg)](https://pub.dartlang.org/packages/cooee_plugin)

## What is Cooee?

Lets Cooee powers hyper-personalized and real time engagements for mobile apps based on machine learning. The SaaS platform, hosted on
cloud infrastructure processes millions of user transactions and data attributes to create unique and contextual user engagement
triggers for end users with simple SDK integration that requires no coding at mobile app level.

## Features

1. Plug and Play - SDK is plug and play for mobile applications. That means it needs to be initialized with the Application Context and it
   will work automatically in the background.
2. Independent of Application - SDK is independent of the application. It will collect data points with zero interference from/to the
   applications. Although applications can send additional data points (if required) to the SDK using API’s.
3. Rendering engagement triggers - SDK will render the campaign trigger at real-time with the help of server http calls.
4. Average SDK size – 5-6 MB(including dependency SDK’s).

## Installation

### Step 1: Dependencies

To add the Cooee Flutter plugin to your project, You can use `flutter pub add` or edit your project's `pubspec.yaml` file:

#### Add via terminal

```shell
flutter pub add cooee_plugin
```

#### Or Update your `pubspec.yaml`

```yaml
dependencies:
  cooee_plugin: x.x.x
```

You can check the latest version of the plugin from https://pub.dev/packages/cooee_plugin/admin.

### Step 2: Configure Credentials

#### Android

Add following in `AndroidManifest.xml` present at `android/app/src/main` within the `<application>` tag:

```xml
<meta-data android:name="COOEE_APP_ID" android:value="MY_COOEE_APP_ID"/>
<meta-data android:name="COOEE_APP_SECRET" android:value="MY_COOEE_APP_SECRET"/>
```

#### iOS

Add following in `Info.plist` present at `ios/Runner` path

```xml
<key>NSBluetoothPeripheralUsageDescription</key>
<string>App uses Bluetooth to find out nearby devices</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>App uses location to search retailer location</string>

<key>COOEE_APP_ID</key>
<string>MY_COOEE_APP_ID</string>
<key>COOEE_APP_SECRET</key>
<string>MY_COOEE_APP_SECRET</string>
```

**Note:** Replace `MY_COOEE_APP_ID` & `MY_COOEE_APP_SECRET` with the app id & secret
given to you separately in both **Android** & **iOS**.

### Step 3: Import it

Now in your Dart code, you can use:

```dart
import 'package:cooee_plugin/cooee_plugin.dart';
```

### Step 4: Track custom Events

Once you integrate the SDK, Cooee will automatically start tracking events. You can view the collected events in System Default Events. Apart from these, you can track custom events as well.

```dart
var eventProperties = {'product id': 1234, 'product name': 'Wooden Table'};
CooeePlugin.sendEvent("Add to cart", eventProperties);
```

### Step 5: Track user action on In-App Trigger

Cooee also allows you to update user profile and properties

#### Update user profile

```dart
var userProfile = {
   'name': 'John Smith', 
   'mobile': 9876543210, 
   'email': 'johnsmit@gmail.com'
};

CooeePlugin.updateUserData('Add to cart', userProfile);
```

#### Update user properties

```dart
var userProproperties = {'foo': 'bar'};
CooeePlugin.updateUserData('Add to cart', userProproperties);
```

### Step 6: Track user action on In-App Trigger

Create an object of CooeePlugin and initialize event tracker

```dart
var cooeePlugin = new CooeePlugin();
cooeePlugin.setCooeeInAppNotificationAction(inAppTriggered);
```

Don't forget to initialize `inAppTriggered`

```dart
void inAppTriggered(Map<String, dynamic> map) {
    if (map["actionType"] == "VIEW_ITEM") {
        // Use map["item"]
    } else if (map["actionType"] == "GO_TO_SCREEN") {
        // Use map["screenName"]
    }
}
```

### Step 7: Show debug information (Optional)

To see CooeeSDK debug information for you can add `SHAKE_TO_DEBUG_COUNT` in `AndroidManifest.xml`

```xml
<!-- Change value to 0 if you don't want to open debug information when device shake-->
<meta-data
    android:name="SHAKE_TO_DEBUG_COUNT"
    android:value="ANY_NUMBER" />
```

Or you can also see information by calling `showDebugInfo()` method

```dart
CooeePlugin.showDebugInfo();
```

**Note:**
Debug Information holds confidential data and is password protected. While accessing this information Cooee representative is required.

### Step 7: Show User ID (Optional)

To see User ID assigned to user by Cooee you can call `getUserID`

```dart
CooeePlugin.getUserID();
```