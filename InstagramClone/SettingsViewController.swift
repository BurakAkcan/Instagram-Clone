//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by Burak AKCAN on 18.06.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogin", sender: nil)
        }catch{
            print(error.localizedDescription)
        }
    }
    
   

}
