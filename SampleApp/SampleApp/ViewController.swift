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
    
    var nearBee: NearBee!
    
    var viewBeacons:[NearBeeBeacon] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        UNUserNotificationCenter.current().delegate = self

        nearBee = NearBee.initNearBee()
        nearBee.delegate = self
        nearBee.enableBackgroundNotification(true)
        nearBee.startScanning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nearBee.delegate = self
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard viewBeacons.count > indexPath.row else {
            return
        }
        
        let beacon = viewBeacons[indexPath.row]
        
        guard let eddystoneURL = beacon.getBestAvailableAttachment()?.getURL() else {
            return
        }
        
        nearBee.displayContentOf(eddystoneURL)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewBeacons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhysicalWebTableViewCell.cellIdentifier, for: indexPath) as? PhysicalWebTableViewCell, viewBeacons.count > indexPath.row else {
            fatalError("Unexpected Index Path")
        }
        
        let beacon = viewBeacons[indexPath.row]
        
        // Configure Cell
        cell.configureCell(beacon: beacon)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GeoFenceViewController {
            destination.nearBee = nearBee
        }
    }
}

extension ViewController: NearBeeDelegate {
    func didFindBeacons(_ beacons: [NearBeeBeacon]) {
        let filteredBeacons = beacons.filter { !viewBeacons.contains($0) }
        viewBeacons.append(contentsOf: filteredBeacons)
        tableView.reloadData()
    }
    
    func didLoseBeacons(_ beacons: [NearBeeBeacon]) {
        let filteredBeacons = beacons.filter { !viewBeacons.contains($0) }
        viewBeacons.append(contentsOf: filteredBeacons)
        tableView.reloadData()
    }
    
    func didUpdateBeacons(_ beacons: [NearBeeBeacon]) {
        viewBeacons = viewBeacons.filter { !beacons.contains($0) }
        tableView.reloadData()
    }
    
    func didThrowError(_ error: Error) {
        viewBeacons = []
        tableView.reloadData()
    }
    
    func didUpdateState(_ state: NearBeeState) {
        
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let _ = nearBee.checkAndProcessNotification(response.notification)
        completionHandler()
    }
}
