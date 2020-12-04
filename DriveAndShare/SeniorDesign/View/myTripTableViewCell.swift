//
//  myTripTableViewCell.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 11/30/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import UIKit
import Foundation

class myTripTableViewCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var fromWhereLabel: UILabel!
    @IBOutlet weak var toWhereLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(myTrip: myTrip){
        driverNameLabel.text = myTrip.driverName
        fromWhereLabel.text = myTrip.fromWhere
        toWhereLabel.text = myTrip.toWhere
        dayLabel.text = myTrip.day
        timeLabel.text = myTrip.time
        
    }

}
