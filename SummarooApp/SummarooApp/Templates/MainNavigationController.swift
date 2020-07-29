//
//  MainNavigationController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/12/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoggedin(){
            //assume user is logged in
            let secondMainViewController = SecondMainViewController()
            viewControllers = [secondMainViewController]
        }else{
            let mainViewController = MainViewController()
            viewControllers = [mainViewController]
        }
    }
    fileprivate func isLoggedin() -> Bool{
        return true}
}
