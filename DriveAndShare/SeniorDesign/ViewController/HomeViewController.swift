//
//  HomeViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/21/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    
    //Variables
    private var myTripsCollectionRef: CollectionReference!
    private var myTrips = [myTrip]()

    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        


        // Do any additional setup after loading the view.
        //assignBackground()
        
    }
    
    
    //LOGOUT
    @IBAction func handleLogout(_ target: UIBarButtonItem) {
        try! Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "NavigationController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    //Assign Background
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
    
    

}
