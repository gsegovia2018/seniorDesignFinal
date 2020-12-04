//
//  PostViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 11/24/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class PostViewController: UIViewController {
    
    
    
    @IBOutlet weak var fromWhereTextField: UITextField!
    @IBOutlet weak var toWhereTextField: UITextField!
    @IBOutlet weak var chooseDayTextField: UITextField!
    @IBOutlet weak var chooseTimeTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style elements
        Utilities.styleTextField(fromWhereTextField)
        Utilities.styleTextField(toWhereTextField)
        Utilities.styleTextField(chooseDayTextField)
        Utilities.styleTextField(chooseTimeTextField)
        Utilities.styleHollowButton(postButton)
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
            
            let db = Firestore.firestore()
            
            db.collection("trips").addDocument(data: ["fromWhere":fromWhere, "toWhere":toWhere, "day":chooseDay, "time": chooseTime]) { (err) in
                if err != nil{
                    
                    //show error
                    self.showError("Error saving data")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func validateFields() -> String? {
    
    //Check that all fields are filled in
        if fromWhereTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            toWhereTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            chooseDayTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            chooseTimeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }

}
