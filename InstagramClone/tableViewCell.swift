//
//  tableViewCell.swift
//  InstagramClone
//
//  Created by Burak AKCAN on 18.06.2022.
//

import UIKit
import FirebaseFirestore

class tableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var labelLikeCount: UILabel!
    
    @IBOutlet weak var hiddenLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeClick(_ sender: UIButton) {
        print("tıklandı")
        print(hiddenLabel.text!)
        let fireStoreDB = Firestore.firestore()
        
        if let likeCount = Int(labelLikeCount.text!){
           
            let likeDictionary = ["likes":(likeCount + 1)] as [String:Any]
            //!!! Burada merge etmemiz lazım çünkü böyle bir veri var bunu birleştir demek
            fireStoreDB.collection("Post").document(hiddenLabel.text!).setData(likeDictionary, merge: true)
        }
        
    }
}
