//
//  PostViewController1.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 9/16/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


class PostViewController1: UIViewController {
    
    
    
    @IBOutlet weak var fromWhereTextField: UITextField!
    @IBOutlet weak var toWhereTextField: UITextField!
    @IBOutlet weak var chooseDayTextField: UITextField!
    @IBOutlet weak var chooseTimeTextField: UITextField!
    @IBOutlet weak var setPriceTextField: UITextField!
    @IBOutlet weak var setCapacityTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var driverName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        //assignBackground()
        guard let uid = Auth.auth().currentUser?.uid else {return }
        Firestore.firestore().collection("profile").document(uid).getDocument { (docSnapshot, error) in
            if let err = error {
                debugPrint("Error fetching user: \(err)")
                
            } else {
                if let doc = docSnapshot {
                    self.driverName = (doc.get("firstName") as? String ?? "Anonymous")
                }
            }
        }
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
    
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        //Validate fields
        let error = validateFields()
        
        if error != nil {
            
            //there's something wrong
            showError(error!)
        }
            
        else{
            //Create cleaned versions of the data
            let fromWhere = fromWhereTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let toWhere = toWhereTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let chooseDay = chooseDayTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let chooseTime = chooseTimeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let setPrice = setPriceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let setCapacity = setCapacityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let uid = Auth.auth().currentUser?.uid else {return }
            
            
            let db = Firestore.firestore()
            
            db.collection("trips").document().setData([
                "fromWhere": fromWhere,
                "toWhere": toWhere,
                "day": chooseDay,
                "time": chooseTime,
                "price": Int(setPrice) ?? 15,
                "capacity": Int(setCapacity) ?? 3,
                "driverName": driverName,
                "driverUid": uid
            ])
            { err in
                if err != nil {
                    self.showError("Error saving trip data")
                }
                
            }
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Posted")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    //Functions
    
    func setUpElements(){
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style elements
        Utilities.styleTextField(fromWhereTextField)
        Utilities.styleTextField(toWhereTextField)
        Utilities.styleTextField(chooseDayTextField)
        Utilities.styleTextField(chooseTimeTextField)
        Utilities.styleTextField(setPriceTextField)
        Utilities.styleTextField(setCapacityTextField)
        Utilities.styleHollowButton(postButton)
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if fromWhereTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            toWhereTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            chooseDayTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            chooseTimeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            setPriceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            setCapacityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
}
