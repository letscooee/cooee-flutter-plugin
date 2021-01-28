# Cooee plugin for Flutter App

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

To add the Cooee Flutter plugin to your project, edit your project's `pubspec.yaml` file:

```yaml
dependencies:
cooee_plugin: 0.0.2
```

You can check the latest version of the plugin from https://pub.dev/packages/cooee_plugin/admin.

### Step 2: Configure Credentials

Add following in AndroidManifest.xml within the `<application>` tag:

```xml
<meta-data android:name="COOEE_APP_ID" android:value="MY_COOEE_APP_ID"/>
<meta-data android:name="COOEE_APP_SECRET" android:value="MY_COOEE_APP_SECRET"/>
```

Replace `MY_COOEE_APP_ID` & `MY_COOEE_APP_SECRET` with the app id & secret given to you separately.

### Step 3: Import it

Now in your Dart code, you can use:

```dart
import 'package:cooee_plugin/cooee_plugin.dart';
```

### Step 4: Track custom Events

Once you integrate the SDK, Cooee will automatically start tracking events. You can view the collected events in System Default Events. Apart from these, you can track custom events as well.

```dart
var eventProperties = {'product id': '1234', 'product name': 'Wooden Table'};
CooeePlugin.sendEvent("Add to cart", eventProperties);
```
