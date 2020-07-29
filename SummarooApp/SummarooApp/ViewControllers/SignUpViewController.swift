//
//  SignUpViewController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/12/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailSignUpTextField: UITextField!
    
    @IBOutlet weak var passwordSignUpTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorTextField: UITextField!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.self.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false

        // Do any additional setup after loading the view.
        emailSignUpTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.6667, green: 0.6667, blue: 0.6667, alpha: 1)])
        passwordSignUpTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.6667, green: 0.6667, blue: 0.6667, alpha: 1)])
        errorTextField.alpha = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String?{
           if  emailSignUpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
               passwordSignUpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" { return "Please fill in all fields"}
           return nil
       }
    
    func showError(_ message:String){
           errorTextField.text = message
           errorTextField.alpha = 1
       }
    func transitionToHome(){
        

        
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // validate fields
        let error = validateFields()
               
        if error != nil{
                showError(error!)
            }
        else{
                   
            //Create cleaned versions of data
            let emailSignUP = emailSignUpTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordSignUp = passwordSignUpTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                   
                   
            //create user
            Auth.auth().createUser(withEmail: emailSignUP, password: passwordSignUp) { (result, err) in
            //check for errors
            if err != nil {
                //there was an error creating the user
                self.errorTextField.text = err!.localizedDescription
                self.errorTextField.alpha = 1
            }else{
                //user was created succesfully
                print("worked")
                self.performSegue(withIdentifier: "SignUpToHome", sender: nil)
                           
            }
        }
                   
    }
        
}
    
    
    
}
