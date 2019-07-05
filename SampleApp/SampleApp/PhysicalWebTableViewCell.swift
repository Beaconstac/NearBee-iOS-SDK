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
        guard let attachment = beacon.getBestAvailableAttachment() else {
            return
        }
        self.title.text = attachment.getTitle()
        self.descriptionLabel.text = attachment.getDescription()
        self.eddystoneURL.text = attachment.getURL()
        guard let icon = attachment.getIconURL(),
            let iconUrl = URL(string: icon) else {
            self.iconImage.image = UIImage(named: "link")
            return
        }
        self.iconImage.setImage(url: iconUrl, placeholder: UIImage(named: "link"))
    }
}
