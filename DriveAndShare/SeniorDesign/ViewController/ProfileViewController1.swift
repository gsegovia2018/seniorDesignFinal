//
//  ProfileViewController1.swift
//  SeniorDesign
//
//  Created by Guillermo Segovia Marcos on 9/28/20.
//  Copyright © 2020 Guillermo Segovia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController1: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var firstNameLabel: UILabel!
    private var ref: CollectionReference!
    let uid = Auth.auth().currentUser!.uid
    let email = Auth.auth().currentUser!.email
    var firstName = ""
    var lastName = ""
    var gender = ""
    var yearBirth = ""
    var pictureUrl = "https://firebasestorage.googleapis.com/v0/b/driveandshare-c3892.appspot.com/o/Profile%2Ftcg4Uu6TzaP6TXn4Yp1F8mbKqrf1?alt=media&token=92fdfbc6-0b39-48be-a684-c4b64c5ce023"
    
    var image: UIImage? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "User Profile"
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        imageView.addGestureRecognizer(gesture)
        getData()
        setUpImage()
        assignBackground()
        // Do any additional setup after loading the view.
    }
    
    func setUpImage() {
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        
        
        
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
    
    func getData() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Firestore.firestore().collection("profile").document(uid).getDocument { (docSnapshot, error) in
            if let doc = docSnapshot {
                self.firstNameLabel.text = doc.get("firstName") as? String
                self.emailLabel.text = self.email
                self.firstName = doc.get("firstName") as? String ?? ""
                self.lastName = doc.get("lastName") as? String ?? ""
                self.gender = doc.get("gender") as? String ?? ""
                self.yearBirth = doc.get("yearBirth") as? String ?? ""
                self.pictureUrl = doc.get("pictureUrl") as? String ?? ""
                self.fetchImage()
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    private func fetchImage() {
        if pictureUrl != "" {
            let imageURL = URL(string: pictureUrl)
            var image: UIImage?
            if let url = imageURL {
                //All network operations has to run on different thread(not on main thread).
                DispatchQueue.global(qos: .userInitiated).async {
                    let imageData = NSData(contentsOf: url)
                    //All UI operations has to run on main thread.
                    DispatchQueue.main.async {
                        if imageData != nil {
                            image = UIImage(data: imageData as! Data)
                            self.imageView.image = image
                            
                        } else {
                            image = nil
                        }
                    }
                }
            }
        }
    }
    
    
    
    //I NEED TO UPDATE THE UID FOR THE PROFILE SO I CAN GET EACH USER DATA
    @IBAction func FetchButtonTapped(_ sender: Any) {
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        guard let imageSelected = self.image else { return }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        let storageRef = Storage.storage().reference(forURL: "gs://driveandshare-c3892.appspot.com")
        let storageProfileRef = storageRef.child("Profile").child(uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion:  { (storageMetadata, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            
            storageProfileRef.downloadURL(completion: { (url, error ) in
                
                if let metaImageUrl = url?.absoluteString {
                    let db = Firestore.firestore()
                    //SET DATA FOR USER
                    
                    db.collection("profile").document(uid).setData([
                        "firstName": self.firstName,
                        "lastName": self.lastName,
                        "yearBirth": self.yearBirth,
                        "gender": self.gender,
                        "uid":uid,
                        "pictureUrl": metaImageUrl
                    ]) { err in
                        if err != nil {
                            print(error?.localizedDescription as Any)
                        }
                    }
                }
                
            })
            
        })
    }
    
    
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
}


extension ProfileViewController1: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {[weak self] _ in self?.presentCamera()}))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in self?.presentPhotoPicker()}))
        
        present(actionSheet, animated: true)
        
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        self.image = selectedImage
        self.imageView.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}





