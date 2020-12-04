//
//  TripCell.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/21/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import Foundation
import UIKit


class TripCell: UITableViewCell{
    
    
    //Outlets
    
    @IBOutlet weak var driverPicture: UIImageView!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var fromWhereLabel: UILabel!
    @IBOutlet weak var toWhereLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(trip: Trip){
        driverNameLabel.text = trip.driverName
        fromWhereLabel.text = trip.fromWhere
        toWhereLabel.text = trip.toWhere
        priceLabel.text = String(trip.price)
        dayLabel.text = trip.day
        timeLabel.text = trip.time
    }
    
}
