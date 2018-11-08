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

1. In Info.plist, add a new fields, `NSLocationAlwaysUsageDescription`, `NSLocationAlwaysAndWhenInUsageDescription`, `NSBluetoothPeripheralUsageDescription` with relevant values that you want to show to the user. This is mandatory for iOS 10 and above.

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

1. Import the framework header in your class

```swift
import NearBee
```

```objective-c
import <NearBee/NearBee.h>
```

2. Initialize `NearBee` using __one-line initialization__, the initialization starts scanning for beacons immediately.

```swift
NearBee.sharedInstance(MY_DEVELOPER_TOKEN, organization:MY_ORGANIZATION, completion: : { (nearBee, error) in
    if let nearBeeInstance = nearBee {
        // Successful...
    } else if let e = error {
        print(e)
    }
}))
```

```objective-c
[NearBee sharedInstance:MY_DEVELOPER_TOKEN organization:MY_ORGANIZATION completion:^(NearBee * _Nullable nearBeeInstance, NSError * _Nullable error){
    if (!error) {
        //Successfull
    } else {
        NSLog("%@", error);
    }
}];
```

3. If you wish to get the ___sharedInstance()___ of the NearBee SDK, after you initialize the NearBee SDK at any point in a single application life cycle

```swift
do {
    let nearBeeInstance = try NearBee.sharedInstance()
} catch let error {
    print(error)
}
```

```objective-c
NSError *error = nil;
NearBee *nearBeeInstace = [NearBee sharedInstanceAndReturnError:&error];
```

4. If you wish to control start and stop of scanning for beacons:

```swift
nearBeeInstance.startScanning() // Starts scanning for beacons...
nearBeeInstance.stopScanning() // Stops scanning for beacons...
```

```objective-c
[nearBeeInstance startScanning];
[nearBeeInstance stopScanning];
```

5. Implement `NSFetchedResultsControllerDelegate` protocol methods to show the beacons either in `UITableView` (recommended) or `UICollectionView`

```swift

// In the class where you want to listen to the beacon scanning events...
let nearBeeInstance = try! NearBee.sharedInstance()
nearBeeInstance.beaconFetchedResultsController.delegate = self

// Optional
func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
}

func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
}

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch (type) {
    case .insert:
        if let indexPath = newIndexPath {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
        break;
    case .delete:
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        break;
    case .update:
        if let indexPath = indexPath {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        break;
    case .move:
        if let indexPath = indexPath {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        if let newIndexPath = newIndexPath {
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
        break;
    }   
}
```

```objective-c

// In the class where you want to listen to the beacon scanning events...
NSError *error = nil;
NearBee *nearBeeInstance = [NearBee sharedInstanceAndReturnError:&error];
nearBeeInstance.beaconFetchedResultsController.delegate = self;

//Optional

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
}
```

6. Once user clicks on the notification, pass it to the NearBee SDK to display the notificaiton

```swift

// In the class where you want to listen to notification events...
let nearBeeInstance = try! NearBee.sharedInstance()
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    let isNearBeeNotification = nearBeeInstance.checkAndProcessNearbyNotification(response.notification)
    if (isNearBeeNotification) {
        completionHandler()
    } else {
        // Not a near bee notification, you need to handle
    }
}

```

```objective-c

// In the class where you want to listen to notification events...
NSError *error = nil;
NearBee *nearBeeInstance = [NearBee sharedInstanceAndReturnError:&error];

- (void)userNotificationCenter:(UNUserNotificationCenter *)center 
didReceiveNotificationResponse:(UNNotificationResponse *)response 
withCompletionHandler:(void (^)(void))completionHandler {
    
    BOOL isNearBeeNotification = [nearBeeInstance checkAndProcessNearbyNotification: response.notification];
    if (isNearBeeNotification) {
        completionHandler()
    } else {
        // Not a near bee notification, you need to handle
    }
}
```
