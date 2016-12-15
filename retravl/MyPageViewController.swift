import UIKit
import FirebaseAuth
import FirebaseDatabase
import NVActivityIndicatorView

class MyPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblCntCountry: UILabel!
    @IBOutlet weak var lblCntFollowing: UILabel!
    @IBOutlet weak var lblCntFollower: UILabel!
    @IBOutlet weak var lblCntReview: UILabel!

    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblProfileDesc: UILabel!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var cvReviews: UICollectionView!
    @IBOutlet weak var cvReviewsHeight: NSLayoutConstraint!
    
    var reviews:[Review] = []
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthManager.shared.getUserInfo(uid: AuthManager.shared.uid()) { (user) in
            self.imgProfile.setImageFromURl(stringImageUrl: user.photo)
            // style : image
            self.imgProfile.layer.masksToBounds = true
            self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.height / 2
            
            self.lblProfileName.text = user.nickName
            self.lblProfileDesc.text = "소개글을 입력하세요." // TODO
            
            self.lblCntReview.text = "0" // TODO
            self.lblCntFollower.text = "0" // TODO
            self.lblCntFollowing.text = "0" // TODO
            self.lblCntCountry.text = "0" // TODO
            
            // style : button
            self.btnEditProfile.backgroundColor = UIColor.clear
            self.btnEditProfile.layer.cornerRadius = self.btnEditProfile.bounds.size.height / 2
            self.btnEditProfile.layer.borderWidth = 1
            self.btnEditProfile.layer.borderColor = UIColor.rtrPumpkinOrangeTwo.cgColor
            
            // collectionView
            self.cvReviews.delegate = self
            self.cvReviews.dataSource = self
            
            self.cvReviews.register(MyGridCell.self, forCellWithReuseIdentifier: "MyGridCell")
            
        }
        
        loadData()
    }

    // MARK: - UICollectionViewController
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyGridCell", for: indexPath as IndexPath)
        
        let review = reviews[indexPath.row]
        let myCell = cell as! MyGridCell
        myCell.setup(review)
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = (availableWidth-(itemsPerRow-1)) / itemsPerRow
        print("\(widthPerItem) ~ \(collectionView.frame.width)")
        return CGSize(width: widthPerItem-4, height: widthPerItem-4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    private func loadData() {
        self.startAnimating()
        ReviewWriteManager.shared.loadRecentReviews(limit: 5) { reviews in
            self.lblCntReview.text = "\(reviews.count)"
            self.reviews = reviews
            self.cvReviewsHeight.constant = ceil(self.cvReviews.frame.width / 3.0) * CGFloat(Double(self.reviews.count) / 3.0 + 1)
            self.cvReviews.reloadData()
            self.stopAnimating()
        }
    }

    
    

}
