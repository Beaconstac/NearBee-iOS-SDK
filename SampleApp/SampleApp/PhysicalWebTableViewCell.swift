//
//  PhysicalWebTableViewCell.swift
//  PhyWebiOS
//
//  Created by Amit Prabhu on 12/01/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import UIKit
import NearBee
import Imaginary

class PhysicalWebTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "PhysicalWebTableViewCellIdentifier"

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var eddystoneURL: UILabel!
    
    func configureCell(beacon: NearBeeBeacon) {
        self.title.text = beacon.physicalWebTitle
        self.descriptionLabel.text = beacon.physicalWebDescription
        self.eddystoneURL.text = beacon.physicalWebEddystoneURL
        
        guard let physicalWebIcon = beacon.physicalWebIcon,
            let iconURL = URL(string: physicalWebIcon) else {
                self.iconImage.image = UIImage(named: "link")
                return
        }
        self.iconImage.setImage(url: iconURL, placeholder: UIImage(named: "link"))
    }
}
