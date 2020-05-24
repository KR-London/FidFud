//
//  signUpViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class signUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var supporterEmailAddress: UITextField!
    @IBAction func signUp(_ sender: UIButton){
        
        guard let userEmail = emailAddress.text, !userEmail.isEmpty else {
             self.showMessage(messageToDisplay: "I need your email address to find your account")
             return;
         }
         
         guard let userPassword = password.text, !userPassword.isEmpty else {
             self.showMessage(messageToDisplay: "I need your password to be sure that it's you")
             return;
         }
        
        if confirmPassword.text != userPassword {
            self.showMessage(messageToDisplay: "The password confirmation does not match...")
            return;
        }
               
        Auth.auth().createUser(withEmail: userEmail, password: userPassword){
            (user, error) in
            
            if let error = error{
                print(error.localizedDescription)
                self.showMessage(messageToDisplay: error.localizedDescription)
                return
            }
            
            if let user = user{
                print("Success")
                var databaseReference: DatabaseReference!
                databaseReference = Database.database().reference()
                
               // let userDetails: [String:String?] = ["userEmail": userEmail, "supporterEmail": self.supporterEmailAddress.text]
                
                let userSupporter: String? = self.supporterEmailAddress.text
                
                databaseReference.child("users").child(user.user.uid).setValue(["userEmail": userEmail])
                databaseReference.child("users").child(user.user.uid).setValue(["userSupporter": self.supporterEmailAddress.text ?? ""])
                
            }
            
        }
         
    }
    @IBAction func abandon(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "addContent") as! AddViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func showMessage(messageToDisplay : String){
        let alertController = UIAlertController(title: "Ooops!", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default){
            (action:UIAlertAction!) in
            print("OKButton Tapped")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
