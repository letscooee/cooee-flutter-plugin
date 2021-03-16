# CooeeSDK

## What is Cooee?

Lets Cooee powers hyper-personalized and real time engagements for mobile apps based on machine learning. The SaaS platform, hosted on cloud infrastructure processes millions of user transactions and data attributes to create unique and contextual user engagement triggers for end users with simple SDK integration that requires no coding at mobile app level.

## Features

Plug and Play - SDK is plug and play for mobile applications. That means it needs to be initialized with the Application Context and it will work automatically in the background.
Independent of Application - SDK is independent of the application. It will collect data points with zero interference from/to the applications. Although applications can send additional data points (if required) to the SDK using API’s.
Rendering engagement triggers - SDK will render the campaign trigger at real-time with the help of server http calls.
Average SDK size – 5-6 MB(including dependency SDK’s).

## Installation

### Step 1: Pods

To add the Cooee framwork to your project, edit your project's podfile :

```
use_frameworks!
target 'Your target name'
pod 'CooeeSDK'
```
You can check the latest version of the plugin from [Github](https://github.com/suriForIOS/Cooee).

### Step 2: Configure Credentials

Add following in your info.plist file inside  <dict>..</dict>:

```
<key>CooeeAppID</key>
<string>MY_COOEE_APP_ID </string>
<key>CooeeSecretKey</key>
<string>MY_COOEE_APP_SECRET</string>
```

Replace MY_COOEE_APP_ID & MY_COOEE_APP_SECRET with the app id & secret provided.

Also, to fetch user location, following needs to be added to info.plist:

```
<key>NSLocationWhenInUseUsageDescription</key>
<string>App uses location to search retailer location</string>
```

### Step 3:  Setup Cooee

To start using Cooee you need to setup Cooe in your appdelegate file inside didFinishLaunching methood with the firebase token. Use the following code to initialise

```
RegisterUser.shared.setup("<Firebase token>")
```


### Step 4: Track Custom Events

Once you integrate the SDK, Cooee will automatically start tracking events. You can view the collected events in System Default Events. Apart from these, you can track custom events as well.

```
let sdkInstance = RegisterUser.shared
var eventProperties = ["product id":"1234"]
eventProperties["product name"] = "Brush"
sdkInstance.sendEvent(withName: "Add To Cart", properties: eventProperties)
```

### Step 5: Track User Properties

As the user launches the app for the first time, Cooee will create a user profile for them. By default, we add multiple properties for a particular user which you can see in System Default User Properties. Along with these default properties, additional custom attributes properties can also be shared. We encourage mobile apps to share all properties for better machine learning modelling.


```
let sdkInstance = RegisterUser.shared

var userProperties = ["purchased_before":"yes"]
userProperties["product_viewed"] = "5"

var userData = ["name":"Jane Doe"]
userData["monile"] = "1234567890"

sdkInstance.updateProfile(withProperties: userProperties, andData: userData)
```
