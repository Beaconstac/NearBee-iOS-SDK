//
//  ViewController.swift
//  SampleApp
//
//  Created by Sachin Vas on 31/10/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import UIKit
import NearBee
import CoreData
import UserNotifications
import CoreLocation
import Imaginary

class ViewController: UITableViewController {
    
    var MY_TOKEN = "" // warning: Make sure to replace this
    var MY_ORGANIZATION = 0 // warning: Make sure to replace this
    var locationManager = CLLocationManager()
    var nearBeeInstance: NearBee?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        UNUserNotificationCenter.current().delegate = self

            NearBee.shared(MY_TOKEN, organization: MY_ORGANIZATION, completion: { nearBeeInstace, error in
                guard let nearBee = nearBeeInstace else {
                    fatalError("\(error!)")
                }
                do {
                    self.nearBeeInstance = nearBee
                    self.nearBeeInstance?.startScanning()
                    self.nearBeeInstance?.beaconFetchedResultsController.delegate = self
                    try self.nearBeeInstance?.beaconFetchedResultsController.performFetch()
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = UIView(frame: .zero)
                } catch {
                    fatalError("\(error)")
                }
            })
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Fetch Beacon
        let beacon = self.nearBeeInstance?.beaconFetchedResultsController.object(at: indexPath)
        
        guard let eddystoneURL = beacon?.physicalWebEddystoneURL else {
            return
        }
        
        try! NearBee.shared().displayContentOf(eddystoneUrl: eddystoneURL)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.nearBeeInstance?.beaconFetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.nearBeeInstance?.beaconFetchedResultsController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhysicalWebTableViewCell.cellIdentifier, for: indexPath) as? PhysicalWebTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Beacon
        guard let beacon = self.nearBeeInstance?.beaconFetchedResultsController.object(at: indexPath) else {
            return UITableViewCell()
        }
        
        // Configure Cell
        cell.configureCell(beacon: beacon)

        return cell
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
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
                self.tableView.reloadRows(at: [indexPath], with: .fade)
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
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let success = self.nearBeeInstance?.checkAndProcessNearbyNotification(response.notification), !success {
            // Its not nearbee notification, you can handle it...
        }
        completionHandler()
    }
}
