//
//  MainViewController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/12/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
  
    @IBOutlet weak var emailLogInTextField: UITextField!
    
    
    @IBOutlet weak var passwordLogInTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var errorSignInTextField: UITextField!
    
    //label animation
    @IBOutlet weak var summarooLabel: UILabel!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summarooLabel.alpha = 0
        self.summarooLabel.adjustsFontSizeToFitWidth = true
         animateText()

        self.navigationController?.self.isNavigationBarHidden = true
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //move view up or down when keyboard is shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        emailLogInTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.6667, green: 0.6667, blue: 0.6667, alpha: 1)])
        passwordLogInTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.6667, green: 0.6667, blue: 0.6667, alpha: 1)])
        errorSignInTextField.alpha = 0
        
       
        
    }
    
  func animateText(){

    UILabel.animate(withDuration: 10, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseIn, animations:{
            self.summarooLabel.alpha = 1
        },completion: nil)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false;
    }
  @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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
    func validateFields() -> String?{
           if emailLogInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordLogInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
              return "Please fill in all fields"
           }
           return nil
       }
    func showError(_ message:String){
           errorSignInTextField.text = message
           errorSignInTextField.alpha = 1
       }
    func transitionToHome(){

        
    }

    @IBAction func logInButtonTapped(_ sender: Any) {
        // validate fields
        let error = validateFields()
                      
        if error != nil{
            showError(error!)
        }else{
            //create cleaned versions of text field
            let emailLogin = emailLogInTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordLogin = passwordLogInTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

               
            //Sing in
            Auth.auth().signIn(withEmail: emailLogin, password: passwordLogin) { (result, error) in
            if error != nil{
                //couldnt sign in
                self.showError(error!.localizedDescription)
            }else{
                //sign in worked
                print("worked")
                self.performSegue(withIdentifier: "SignInToHome", sender: nil)
                    
                   }
               }
           }
    }
}

