# NearBee SDK for iOS

## Introduction

NearBee SDK is an easy way to enable proximity marketing through an Eddystone-compliant BLE network.

## Installation
##### Using Cocoapods (recommended):
Add the following to your Podfile in your project, we are supporting iOS 10.0+ make sure your pod has proper platform set.

```pod
platform :ios, '10.0'
target '<My-App-Target>''
  pod 'NearBee'
end
```

Run `pod install` in the project directory


#### Manually:

1. Download or clone this repo on your system.
2. Drag and drop the NearBee.framework file into your Xcode project. Make sure that "Copy Items to Destination's Group Folder" is checked.
3. Add the `NearBee.framework`m `EddystoneScanner.framework` and `Socket.IO-Client-Swift.framework` to the embedded binaries section of your destination app target.

4. In Build Phases under destination app target, add the following frameworks in Link Binary With Libraries section:
- CoreData.framework
- SystemConfiguration.framework
- CoreBluetooth.framework
- CoreLocation.framework
- EddystoneScanner.framework
- NearBee.framework
- Socket.IO-Client-Swift.framework

## Configure your project

1. In Info.plist, add a new fields, `NSLocationAlwaysUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`, `NSLocationWhenInUseUsageDescription`, `NSBluetoothPeripheralUsageDescription`, `NSBluetoothAlwaysUsageDescription` with relevant values that you want to show to the user. This is mandatory for iOS 10 and above.

2. Enable `Uses Bluetooth LE accessories` in the Background Modes under Capabilities section.

## Pre-requisite

__Location__

The app should take care of handling the permissions as required by your set up to receive notifications on entring the beacon region.

__Bluetooth__

The app should take care of enabling the bluetooth to range beacons.

__MY_DEVELOPER_TOKEN__

The app should provide the developer token while initializing the SDK. Get it from [Beaconstac Dashboard Account Page](https://dashboard.beaconstac.com/#/account).

__MY_ORGANIZATION__

The app should provide the organization while initializing the SDK. Get it from [Beaconstac Dashboard Account Page](https://dashboard.beaconstac.com/#/account).

__Monitoring Regions__

If you are using the region monitoring API's from advanced location manager, make sure it won't affect the NearBee SDK.

## Set Up

1. In the app's `Info.plist` add the below mentioned keys and the values

```xml
    <key>co.nearbee.api_key</key>
    <string>__MY_DEVELOPER_TOKEN__</string>

    <key>co.nearbee.organization_id</key>
    <string>__MY_ORGANIZATION__</string>
```

2. Import the framework header in your class

```swift
import NearBee
```

```objective-c
import <NearBee/NearBee.h>
```

3. Initialize `NearBee` using __one-line initialization__, the initialization starts scanning for beacons immediately.

```swift
var nearBee = NearBee.initNearBee()
```

```objective-c
NearBee *nearBee = [NearBee initNearBee];
```

4. If you wish to control start and stop of scanning for beacons:

```swift
nearBee.startScanning() // Starts scanning for beacons...
nearBee.stopScanning() // Stops scanning for beacons...
```

```objective-c
[nearBee startScanning];
[nearBee stopScanning];
```

5. Implement `NearBeeDelegate` protocol methods to show the beacons either in `UITableView` or `UICollectionView`

```swift
func didFindBeacons(_ beacons: [NearBeeBeacon]) {
    // Display Beacons
}
    
func didLoseBeacons(_ beacons: [NearBeeBeacon]) {
    // Display Beacons
}
    
func didUpdateBeacons(_ beacons: [NearBeeBeacon]) {
    // Display Beacons
}
    
func didThrowError(_ error: Error) {
    // Show Error
}

func didUpdateState(_ state: NearBeeState) {
    // Update UI based on state
}
```

```objective-c
- (void)didFindBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    // Display Beacons
}

- (void)didLoseBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    // Display Beacons
}

- (void)didUpdateBeacons:(NSArray<NearBeeBeacon *> * _Nonnull)beacons {
    // Display Beacons
}

- (void)didThrowError:(NSError * _Nonnull)error {
    // Error
}

- (void)didUpdateState(NearBeeState state) {
    // Update UI based on state
}
```

6. Enable Background Notification

```swift
nearbee.enableBackgroundNotification(true)
```

```objective-c
[nearbee enableBackgroundNotification: true];
```

7. Overriding notification sound name

Please enable the notification sound by setting UserDefaults.standard.setValue(true, forKey: "NearBeeToggleSound")


```swift
if let alertSound = YOUR_URL {
    let soundName = UNNotificationSoundName(rawValue: alertSound.lastPathComponent)
    nearbee.notificationSound = soundName
}
```

```objective-c
NSURL *alertSound = YOUR_URL
if (alertSound != nil) {
    UNNotificationSoundName *soundName = [UNNotificationSoundName soundNamed:alertSound.lastPathComponent];
    nearbee.notificationSound = soundName
}
```

**Note:** Audio files must already be on the user’s device before they can be played. If you use a predefined set of sounds for your notifications, include the audio files in your app’s bundle. For all other sounds, place a copy of the audio file in the Library/Sounds folder of your app’s container directory. The UNNotificationSound object looks only in those two locations.

8. Once user clicks on the notification, pass it to the NearBee SDK to display the notificaiton. The notification behaviour can be overridden here, by handling it in the app instead of passing it to the SDK.

```swift

// In the class where you want to listen to notification events...
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let nearBeeInstance = NearBee.initNearBee()
    let isNearBeeNotification = nearBee.checkAndProcessNotification(response.notification)
    if (isNearBeeNotification) {
        completionHandler()
    } else {
        // Not a near bee notification, you need to handle
    }
}
```

```objective-c

// In the class where you want to listen to notification events...
- (void)userNotificationCenter:(UNUserNotificationCenter *)center 
didReceiveNotificationResponse:(UNNotificationResponse *)response 
withCompletionHandler:(void (^)(void))completionHandler {
    NearBee *nearBeeInstance = [NearBee initNearBee];
    BOOL isNearBeeNotification = [nearBee checkAndProcessNotification:response.notification];
    if (isNearBeeNotification) {
        completionHandler()
    } else {
        // Not a near bee notification, you need to handle
    }
}
```

## Geofencing

### Start Monitoring

```swift
let nearbee = NearBee.initNearBee()

nearbee.delegate = self // If any error occurred in nearbee

nearbee.startMonitoringGeoFenceRegions { result in 
}
```

```objective-c
NearBee *nearbee = [NearBee initNearBee];

nearbee.delegate = self; // If any error occurred in nearbee

[nearbee startMonitoringGeoFenceRegions:^(BOOL result) {

}];
```
### Stop Monitoring

```swift
let nearbee = NearBee.initNearBee()

nearbee.delegate = self

nearbee.stopMonitoringGeoFenceRegions()
```

```objective-c
NearBee *nearbee = [NearBee initNearBee];

nearbee.delegate = self;

[nearbee stopMonitoringGeoFenceRegions];
```

### Geofence Notification threshold

```swift
let nearbee = NearBee.initNearBee()

nearbee.geoFenceNotificationThreshold = 3600.0 // default is 3600.0
```

```objective-c
NearBee *nearbee = [NearBee initNearBee];

nearbee.geoFenceNotificationThreshold = 3600.0 // default is 3600.0
```

### NearBeeDelegate protocol method for geofences

Implement the NearBeeDelegate protocol method to show the geofences either in UITableView or UICollectionView

```swift
func didEnterGeofence(_ geofence: NearBeeGeoFence, _ attachment: GeoFenceAttachment) {
    // Display data related to geofence
}
```

```objective-c
- (void)didEnterGeofence:(NearBeeGeofence * _Nonnull)geofence _ (GeoFenceAttachment * _Nonnull)attachment {
    // Display data releted to geofence
}
```


### Methods to get properties of Geofence attachment

```swift
// Notification title
attachment.getTitle()

// Notification body
attachment.getDescription()

// URL of icon set for the Geofence notification
attachment.getIconURL()

// Final URL to which a click on the notification should redirect
attachment.getURL()

// Returns true if the url is currently active
attachment.isActive()
```

```objective-c

// Notification title
[attachment getTitle];

// Notification body
[attachment getDescription];

// URL of icon set for the Geofence notification
[attachment getIconURL];

// Final URL to which a click on the notification should redirect
[attachment getURL];

// Returns true if the url is currently active
[attachment isActive];
```


## Convenience method to get the RSSI value of a beacon

The Received Signal Strength Indication value can be used to determine the distance from a beacon.
```swift

// Returns the value of RSSI for the beacon found
beacon.getRSSI()

```

```objective-c

// returns the value of RSSI for the beacon found
[beacon getRSSI];

```

## Getting attachment data from the Beacon object

There are two types of attachments -

#### PhysicalWeb
These are extracted from the physical web url of the beacon
```swift
beacon.attachment.physicalWeb
```
PhysicalWeb properties

```swift

// Title
physicalWeb.getTitle()

// Description
physicalWeb.getDescription()

// Url for the icon
physicalWeb.getIconURL()

// Physical web url
physicalWeb.getUrl()

// Returns true if the url is currently active
physicalWeb.isActive()
```

```objective-c

// Title
[physicalWeb getTitle];

// Description
[physicalWeb getDescription];

// Url for the icon
[physicalWeb getIconURL];

// Physical web url
[physicalWeb getUrl];

// Returns true if the url is currently active
[physicalWeb isActive];
```

#### ProximityAttachment

This comes from Google Nearby attachment for a specific beacon

```swift
// returns a Set of ProximityAttachment objects
beacon.attachment.proximityAttachment
```
`ProximityAttachment` properties

In addition to all the properties from physical web, `ProximityAttachment` has extra properties
```swift

// Url for banner image
proximityAttachment.bannerImageURL

// Banner type, portrait = 1 or landscape = 2
proximityAttachment.bannerType

// ISO code for the language
proximityAttachment.language
```

### Convenience methods for getting attachments

Get the `ProximityAttachment` for the current device locale language.

##### getAttachmentForCurrentLanguage()

Will return `null` if `ProximityAttachment` is not available for that language

```swift
beacon.getAttachmentForCurrentDeviceLanguage()
```

```objective-c
[beacon getAttachmentForCurrentDeviceLanguage];
```

##### getBestAvailableAttachment()

Returns a `BeaconAttachment` protocol confirmed object, which will be a `ProximityAttachment` if an attachment is found for the current language, or a `PhysicalWeb` otherwise

Will return `null` if no attachments are present for this beacon

```swift
beacon.getBestAvailableAttachment()
```

```objective-c
[beacon getBestAvailableAttachment];
```

### Getting business data from the Beacon object

Beacons may contain a Business object which is the `Place` associated with the beacon

```swift
let business = beacon.business
```

```objective-c
NearBeeBusiness *business = beacon.business
```

They have following properties

```swift
// Color code associated with the place (Hex code), convert this accordingly
business.colorCode

// Cover image url
business.coverURL

// Google place id
business.googlePlaceID

// Place name
business.name

// Icon image url
business.iconURL
```
