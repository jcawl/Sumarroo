//
//  SecondMainViewController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/12/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit
import FirebaseAuth

class SecondMainViewController: UIViewController {

    

    @IBOutlet weak var logOutButton: ButtonWithImage!
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var textButton: UIButton!
    
    @IBOutlet weak var summaryButton: UIButton!
    
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var pdfButton: UIButton!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        menuButton.backgroundColor = .white
        menuButton.layer.cornerRadius = menuButton.frame.size.width/2
        //setupAnimation()
        
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationController(){
        let backImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.isNavigationBarHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    private func setupAnimation(){
//
//        //animation
//        bookAnimation.animation = Animation.named("4887-book")
//        bookAnimation.contentMode = .scaleAspectFit
//        bookAnimation.loopMode = .loop
//        bookAnimation.play()
//
//    }
    

    
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        
        UIButton.animate(withDuration: 0.5, delay: 0, options: [], animations:{
            if self.menuButton.transform == .identity{
                self.menuButton.transform = CGAffineTransform(rotationAngle: 180 * (.pi/180))
                self.menuButton.backgroundColor = .black
                
            }else{
                self.menuButton.transform = .identity
                self.menuButton.backgroundColor = .white
            }
            
        })
        if self.historyButton.transform == .identity{
            UIButton.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            
            self.historyButton.transform = CGAffineTransform(translationX: -25, y: 25).concatenating(CGAffineTransform(scaleX: 2, y: 2))

            self.pdfButton.transform = CGAffineTransform(translationX: 25, y: 25).concatenating(CGAffineTransform(scaleX: 2, y: 2))

            self.textButton.transform = CGAffineTransform(translationX: 25, y: -25).concatenating(CGAffineTransform(scaleX: 2, y: 2))

            self.summaryButton.transform = CGAffineTransform(translationX: -25, y: -25).concatenating(CGAffineTransform(scaleX: 2, y: 2))

            
        },completion: nil)}else {
            
            UIButton.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            
                self.historyButton.transform = .identity
                self.pdfButton.transform = .identity
                self.textButton.transform = .identity
                self.summaryButton.transform = .identity
            
            })}
        }
    
    
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
              self.performSegue(withIdentifier: "HomeToLogIn", sender: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    

}
