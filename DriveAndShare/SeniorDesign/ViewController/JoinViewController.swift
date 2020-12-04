//
//  JoinViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 11/29/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class JoinViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    var uidDriver = ""
    var nameLabel = ""
    var fromLabel = ""
    var toLabel = ""
    var dayLabel = ""
    var timeLabel = ""
    var priceLabel = 0
    private var userName = ""
    
    override func viewDidLoad() {
        name.text = nameLabel
        from.text = fromLabel
        to.text = toLabel
        day.text = dayLabel
        time.text = timeLabel
        price.text = String("\(priceLabel)$")
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tappedJoinButton(_ sender: Any) {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {return }
        Firestore.firestore().collection("profile").document(uid).getDocument { (docSnapshot, error) in
            if let err = error {
                debugPrint("Error fetching user: \(err)")
                
            } else {
                if let doc = docSnapshot {
                    self.userName = (doc.get("firstName") as? String ?? "Anonymous")
                }
            }
        }
        
        db.collection("myTrips").document(uid).setData([
            "fromWhere": fromLabel,
            "toWhere": toLabel,
            "day": dayLabel,
            "time": timeLabel,
            "price": Int(priceLabel),
            "driverName": nameLabel
        ])
        
        sendVerificationMail()
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Thanks")
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
        }
    }
    
        
    }
    
    
    
    
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


