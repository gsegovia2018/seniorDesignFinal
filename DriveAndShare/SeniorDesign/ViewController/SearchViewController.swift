//
//  SearchViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 11/24/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var trips = [Trip]()
    private var tripsCollectionRef : CollectionReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(UITableViewCell, forCellReuseIdentifier: "TripCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 150//UITableView.automaticDimension
        //setUpElements()
        assignBackground()
        
        tripsCollectionRef = Firestore.firestore().collection("trips")
    }
    
    func assignBackground(){
        let background = UIImage(named: "homeBackground.jpg")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.right
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tripsCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint ("Error fetching trips: \(err)")
            }
            else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    
                    let data = document.data()
                    let driverName = data["driverName"] as? String ?? ""
                    let fromWhere = data["fromWhere"] as? String ?? ""
                    let toWhere = data["toWhere"] as? String ?? ""
                    let day = data["day"] as? String ?? ""
                    let price = data["price"] as? Int ?? 10
                    let time = data["time"] as? String ?? ""
                    let uidDriver = data["driverUid"] as? String ?? ""//document.documentID
                    
                    let newTrip = Trip(uidDriver: uidDriver, fromWhere: fromWhere, toWhere: toWhere, price: price, driverName: driverName, day: day, time: time)
                    if (!self.trips.contains(newTrip)){
                        self.trips.append(newTrip)
                    }
                    //NEED TO DO SOMETHING SO IT JUST HAS ONE PER UID DRIVER
                }
            }
            self.tableView.reloadData()
        
    }
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trips.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as? TripCell{
        cell.configureCell(trip: trips[indexPath.row])
        return cell
    } else {
        return UITableViewCell()
    }
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "JoinViewController") as? JoinViewController
        vc?.nameLabel = trips[indexPath.row].driverName
        vc?.uidDriver = trips[indexPath.row].uidDriver
        vc?.fromLabel = trips[indexPath.row].fromWhere
        vc?.toLabel = trips[indexPath.row].toWhere
        vc?.dayLabel = trips[indexPath.row].day
        vc?.timeLabel = trips[indexPath.row].time
        vc?.priceLabel = trips[indexPath.row].price
        self.navigationController?.pushViewController(vc!, animated: true)
    }


//        //IF YOU WANT TO ADD SWITCHES TO THE APP
//        let mySwitch = UISwitch()
//        mySwitch.addTarget(self, action: #selector(didChangeSwitch(_ :)), for: .valueChanged)
//        cell.accessoryView = mySwitch
//
//        return cell
//    }
//    @objc func didChangeSwitch(_ sender: UISwitch) {
//        if sender.isOn {
//            print("Is on")
//        }
//        else{
//            print("Is off")
//        }
//    }
}


