//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Burak AKCAN on 18.06.2022.
//
//Resim göstermek için SdWebImage kütüphanesini kullanacağız
import UIKit
import FirebaseFirestore
import SDWebImage
import FirebaseAuth

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userEmailList = [String]()
    
    var commentsList = [String]()
    var likeList = [Int]()
    var userImageList = [String]()
    //like butonu için docId lere ihtiyacım var
    var docIdList:[String] = []
    var selectItem = ""
    
    @IBOutlet weak var tableViews: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViews.delegate = self
        tableViews.dataSource = self
        

        getDataFromFireStore()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        cell.emailLabel.text = userEmailList[indexPath.row]
        cell.commentLabel.text = commentsList[indexPath.row]
        cell.pictureImage.image = UIImage(named: "placeholder")
        cell.labelLikeCount.text = String(likeList[indexPath.row])
        //userImageListteki string türünden olan urlleri kullanarak resimleri göstereceğiz
        cell.pictureImage.sd_setImage(with: URL(string: userImageList[indexPath.row]))
        cell.hiddenLabel.text = docIdList[indexPath.row]
        return cell
    }
    
    func getDataFromFireStore(){
        let fireStore = Firestore.firestore()
       // fireStore.collection("Post").document("myPath").collection("myCollectionPath") gibi  verilerimi alabilirim
        //fireStore.collection("Post").order(by:"date",descending:true) dersem tarihe göre sıralayacaktır
        fireStore.collection("Post").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "hata")
            }else{
                //snapshot boş değilse işlmelerimizi gerçekleştireceğiz
                if snapshot?.isEmpty == false {
                    //tableView sayfamda öncekilerin üzerine tekrar veri gelsin istemeyiz
                    self.userImageList.removeAll(keepingCapacity: false)
                    self.commentsList.removeAll(keepingCapacity: false)
                    self.likeList.removeAll(keepingCapacity: false)
                    self.userEmailList.removeAll(keepingCapacity: false)
                    self.docIdList.removeAll(keepingCapacity: false)
                    for doc in snapshot!.documents{
                        let docId = doc.documentID
                        self.docIdList.append(docId)
                        if let postedBy = doc.get("postedBy") as? String {
                            self.userEmailList.append(postedBy)
                        }
                        if let comment = doc.get("postComment") as? String {
                            self.commentsList.append(comment)
                        }
                        if let like = doc.get("likes") as? Int {
                            self.likeList.append(like)
                        }
                        if let image = doc.get("imageUrl") as? String {
                            self.userImageList.append(image)
                        }
                        
                    }
                    self.tableViews.reloadData()
                }
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem = userEmailList[indexPath.row]
        if self.selectItem == Auth.auth().currentUser!.email {
        let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete ?", preferredStyle: UIAlertController.Style.alert)
        let acAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { _ in
            
                let fireStore = Firestore.firestore()
                let doc = self.docIdList[indexPath.row]
                fireStore.collection("Post").document(doc).delete()
            
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        ac.addAction(acAction)
        present(ac, animated: true)
        tableView.reloadData()
        
        }else{
            let ac = UIAlertController(title: "You don't delete ", message: "You are not the one who posted this ", preferredStyle: UIAlertController.Style.alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
        }
    }
   

 
}
