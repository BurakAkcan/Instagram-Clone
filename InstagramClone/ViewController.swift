//
//  ViewController.swift
//  InstagramClone
//
//  Created by Burak AKCAN on 17.06.2022.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
//Aktif kullanıcı varsa(daha önceden giriş yaptıysa) bunun kontrolünü sceneDelegate içinde yapmalıyız ve direkt açılacak sayfanın stroyboard Idsini oluşturmamız gerekiyor
    override func viewDidLoad() {
        super.viewDidLoad()
       let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
       view.addGestureRecognizer(gestureRecog)
        
    }

    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailText.text,
              let password = passwordText.text else{
            customAlert(title: "Hata", message: "Lütfen alanları doldurunuz")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if error != nil {
                self.customAlert(title: "Hata", message: error!.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "toTabbar", sender: nil)
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailText.text,
              let password = passwordText.text else{
            customAlert(title: "Hata", message: "Lütfen alanları doldurunuz")
            return}
        Auth.auth().createUser(withEmail: email, password: password) { authData, error in
            if error != nil {
                self.customAlert(title: "Hata", message: error!.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "toTabbar", sender: nil)
            }
        }
    }
    
    func customAlert(title:String,message:String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)

    }
}







