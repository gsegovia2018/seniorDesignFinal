//
//  ViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/21/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit
import Firebase
//import AVKit

class ViewController: UIViewController {


    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        assignBackground()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if let user = Auth.auth().currentUser{
//            self.transitionToHome()
//        }
//    }
    
    
    func transitionToHome(){
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func assignBackground(){
        let background = UIImage(named: "drive&ShareBack.png")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.redraw
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

    
    
    
    func setUpElements(){
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
   
}

