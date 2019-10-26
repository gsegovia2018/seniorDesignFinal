//
//  LoginViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/21/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        //Hide error Label
        errorLabel.alpha = 0
        
        //Style elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
   
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //Validate Text Fields
        
        let error = validateFields()
        
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else{
        
            //Create cleaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil{
                    
                    //Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else{
                    
                    //Transition to Home
                    self.transitionToHome()
                }
            }
        }
    }
    
    //FUNCTIONS
    
    func validateFields() -> String? {
              
              //Check that all fields are filled in
              if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                  passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                  return "Please fill in all fields"
              }
              
              return nil
       }
       
       
       func transitionToHome(){
           
           let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
           
           view.window?.rootViewController = homeViewController
           view.window?.makeKeyAndVisible()
       }
       
       func showError(_ message:String) {
           errorLabel.text = message
           errorLabel.alpha = 1
       }
    
}
