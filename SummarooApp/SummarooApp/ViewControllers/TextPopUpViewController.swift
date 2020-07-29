//
//  TextPopUpViewController.swift
//  SummarooApp
//
//  Created by Bernadine Cawley on 5/22/20.
//  Copyright © 2020 Jake Cawley. All rights reserved.
//

import UIKit

class TextPopUpViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    public var string: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.flashScrollIndicators()
        textView.textColor = .black
        textView.text = string

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

}
