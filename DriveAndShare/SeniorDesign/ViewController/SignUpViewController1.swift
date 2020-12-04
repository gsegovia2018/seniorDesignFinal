//
//  SignUpViewController1.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 9/16/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController1: UIViewController {
    
    //Get all the elements
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var yearBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style Elements
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(repeatPasswordTextField)
        Utilities.styleTextField(yearBirthTextField)
        Utilities.styleTextField(genderTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            yearBirthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //Password isnt secure enough
            return "Please make sure your pasword is at least 8 characters, contains a special character and a number."
        }
        //Check if the passwords are the same
        if passwordTextField.text != repeatPasswordTextField.text {
            //Passwords are not the same
            return "Make sure your passwords are the same"
        }
        //Check if the gender is correct
        let genderOption: [String] = ["Man", "Woman"]
        let genderText = genderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if !genderOption.contains(genderText)  {
            return "Make sure you type 'Man or Woman'"
        }
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showError(error!)
        }
        else{
            
            //Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let yearBirth = yearBirthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = genderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Check for errors
                if err != nil {
                    
                    //There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    //Send an email confirmation
                    self.sendVerificationMail()
                    
                    //User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    //SET DATA FOR USER
                    
                    db.collection("profile").document(result!.user.uid).setData([
                        "firstName":firstName,
                        "lastName":lastName,
                        "yearBirth":yearBirth,
                        "gender":gender,
                        "pictureUrl": "",
                        "uid":result!.user.uid
                    ]) { err in
                        if err != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    
                    //Transition to the home screen
                    //self.transitionToHome()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
        }
    }
    //------------------FUNCTIONS------------------------------------------------
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    //Send verification email
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
