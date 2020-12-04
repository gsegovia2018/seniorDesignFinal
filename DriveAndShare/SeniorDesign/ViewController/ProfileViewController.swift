//
//  ProfileViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/27/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var uidLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    private var ref: CollectionReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "User Profile"
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleFetchUserButtonTapped(_ target: UIBarButtonItem) {
        //let db = Firestore.firestore()
        //guard let id = Auth.auth().currentUser?.uid else {return}
        ref = Firestore.firestore().collection("profile")
        
        ref.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching user: \(err)")
            } else {
                guard let snap = snapshot else { return }
                
                //let user = CurrentUser(uid: id, dictionary: snap)
                
                for document in snap.documents{
                    let data = document.data()
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
                    print(firstName, lastName, uid, gender)
                    //print (document.data())
                    
                }
            }
            
            
            
        }
    }
}
