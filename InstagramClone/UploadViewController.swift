//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Burak AKCAN on 18.06.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var customsaveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customsaveButton.tintColor = UIColor.white
        customsaveButton.backgroundColor = UIColor.systemBlue
        customsaveButton.layer.cornerRadius = 20
        customsaveButton.setTitle("Upload", for: UIControl.State.normal)
        imageView.isUserInteractionEnabled = true
        let gestureRecognier = UITapGestureRecognizer(target: self, action: #selector(picker))
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        imageView.addGestureRecognizer(gestureRecognier)
        view.addGestureRecognizer(viewGesture)

    }
    
    @objc func picker(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true,completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
       
    }
    
    @IBAction func clickSaveButton(_ sender: UIButton) {
        let storage = Storage.storage()
        let ref = storage.reference()
        //Storage da oluşturduğum Media klasörünü alalım
        let media = ref.child("Media")
        //Resim, video şeklindeki verileri data ya çevirmemiz lazım yoksa kaydedemeyiz
        if let data = imageView.image?.jpegData(compressionQuality: 0.4){
            let uuid = UUID().uuidString // UUID().uuid yalnızca uuid verir sonuna string yazarsam bunu stringe çevirir
            //Görselin referansı
            let imageRef = media.child("\(uuid).jpg")
            //uploadData (neyi Yükleyeceğim), metaData:nil,
            imageRef.putData(data, metadata: nil) { metaData, error in
                if error != nil{
                    let ac = UIAlertController(title: "Hata", message: error!.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    ac.addAction(action)
                    self.present(ac, animated: true)
                }else{
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                                
                            //Database
                            
                            let db = Firestore.firestore()
                            let dbRef : DocumentReference?
                            guard let title = self.titleText.text,
                                  let comment = self.commentText.text else{return}
                            //bu dictionry yapısını var yap
                            //Tarih yazmak için fieldValue kullanabiliriz
                            //FieldValue.serverTimeStamp() bize anlık zamanı veriri
                            var fireStoreDictionary = ["imageUrl":imageUrl!,"postedBy":Auth.auth().currentUser!.email!,"postTitle":title,"postComment":comment,"date":FieldValue.serverTimestamp(),"likes":0] as [String : Any]
                            
                            dbRef = db.collection("Post").addDocument(data: fireStoreDictionary, completion: { error in
                                if error != nil {
                                    let ac = UIAlertController(title: "Hata", message: error?.localizedDescription ?? "Error", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                    ac.addAction(action)
                                    self.present(ac, animated: true)
                                }else {
                                //Hata yoksa feed sayfasına götürmem lazım kullanıcıyı
                                   
                                    self.imageView.image = UIImage(named: "placeholder")
                                    self.titleText.text = ""
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
            
        }
    }
    
    @objc func hideKeyBoard(){
        view.endEditing(true)
    }
    
    
   
}
