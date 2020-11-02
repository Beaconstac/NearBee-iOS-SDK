//
//  GeoFenceViewController.swift
//  SampleApp
//
//  Created by Sachin Vas on 18/06/19.
//  Copyright © 2019 Mobstac. All rights reserved.
//

import UIKit
import NearBee

class GeoFenceViewController: UIViewController {

    var nearBee: NearBee!
    
    var state: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "GEOFENCE_STATE")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "GEOFENCE_STATE")
            UserDefaults.standard.synchronize()
        }
    }
    @IBOutlet weak var stateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearBee.delegate = self
        updateState()
        
        nearBee.stopMonitoringGeoFenceRegions()
        nearBee.startMonitoringGeoFenceRegions()
    }
    
    func updateState() {
        let title = state ? "Stop" : "Start"
        stateButton.setTitle(title, for: .normal)
    }
    
    @IBAction func toggleState(_ sender: UIButton) {
        state = !state
        if state {
                nearBee.startMonitoringGeoFenceRegions()
        } else {
            nearBee.stopMonitoringGeoFenceRegions()
        }
        updateState()
    }
    
    func showAutoAlert(_ title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                alertController.dismiss(animated: true)
            })
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GeoFenceViewController: NearBeeDelegate {
    // Callback for geofence enter event
    func didEnterGeofence(_ geofence: NearBeeGeoFence, _ attachment: GeoFenceAttachment) {
        NSLog("Entered Geofence region")
    }
    
    func didFindBeacons(_ beacons: [NearBeeBeacon]) {
        
    }
    
    func didUpdateBeacons(_ beacons: [NearBeeBeacon]) {
        
    }
    
    func didLoseBeacons(_ beacons: [NearBeeBeacon]) {
        
    }
    
    func didUpdateState(_ state: NearBeeState) {
        
    }
    
    func didThrowError(_ error: Error) {
        showAutoAlert("Error", message: error.localizedDescription)
    }
}
