//
//  Login.swift
//  haerry
//
//  Created by Ferdinand Lösch on 03/12/2016.
//  Copyright © 2016 Ferdinand Lösch. All rights reserved.
//

import UIKit
import FirebaseAuth
class Login: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    private let SAGE = "ferdinand"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
ifLogIn(Segue: SAGE)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailText.text!, password: passwordText.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!);
                } else {
                    
              
                    
                    self.emailText.text = "";
                    self.passwordText.text = "";
                    
                    self.performSegue(withIdentifier: self.SAGE, sender: nil)
                }
                
            })
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }

        
    }
    
    
    func ifLogIn(Segue: String) {
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // Test the value of user.
            
            if user != nil {
                // On successful authentication, perform the segue.
                 self.performSegue(withIdentifier: Segue, sender: nil)
                print("all aty to llog in ")
            }
        }
        
        
    }


  
    @IBAction func signUp(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailText.text!, password: passwordText.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!);
                } else {

                    
                    self.emailText.text = "";
                    self.passwordText.text = "";
                    print("logIn")
                    self.performSegue(withIdentifier: self.SAGE, sender: nil)
                }
                
            });
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
        

    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

    
}
