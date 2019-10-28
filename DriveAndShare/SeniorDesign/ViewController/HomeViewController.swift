//
//  HomeViewController.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 10/21/19.
//  Copyright © 2019 Guillermo Segovia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()

        // Do any additional setup after loading the view.
        //assignBackground()
        
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
