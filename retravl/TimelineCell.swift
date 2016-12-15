import UIKit
import HCSStarRatingView

// using Home.storyboard
class TimelineCell: UICollectionViewCell {
    // MARK: - hidden: id
    private var rid:String?
    
    // header
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCreateAt: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    // preview
    @IBOutlet weak var vStarRating: HCSStarRatingView!
    @IBOutlet weak var vProgress: UIView!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    
    // meta
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    
    // contents
    @IBOutlet weak var lblContents: UILabel!
    
    // social
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblShares: UILabel!
    
    // MARK: - setup data
    func setup(review: Review) {
        self.rid = review.id
        
        AuthManager.shared.getUserInfo(uid: review.uid) { user in
            self.imgProfile.setImageFromURl(stringImageUrl: user.photo)
            self.imgProfile.layer.masksToBounds = true
            self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.size.height/2
            
            self.lblTitle.text = user.nickName
        }
        self.lblCreateAt.text = review.createdAt
        
        self.vStarRating.value = CGFloat.init(review.rating)
        // TODO vProgress
        let imageId = "1" // FIXME
        ReviewWriteManager.shared.reviewImage(review:review, imageId:imageId) { image in
            self.imgPreview.image = image
        }
        self.lblRating.text = "\(review.rating)"
        self.lblPrice.text = "\(review.price)"
        self.lblLocation.text = review.location
        self.lblTag.text = review.tags?.joined(separator: ",") ?? ""
        self.lblContents.text = review.contents
        self.lblLikes.text = "\(review.likes)"
        self.lblComments.text = "\(review.comments)"
        self.lblShares.text = "\(review.shares)"
    }
    
    
}
