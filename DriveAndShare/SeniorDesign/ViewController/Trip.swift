//
//  Trip.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/21/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import Foundation
struct Trip: Equatable {
    let uidDriver: String
    let fromWhere: String
    let toWhere: String
    let price: Int
    let driverName: String
    let day: String
    let time: String
    
    init(uidDriver: String, fromWhere: String, toWhere: String, price: Int, driverName: String, day: String, time: String){
        self.uidDriver = uidDriver
        self.fromWhere = fromWhere
        self.toWhere = toWhere
        self.price = price
        self.driverName = driverName
        self.day = day
        self.time = time
    }
}



