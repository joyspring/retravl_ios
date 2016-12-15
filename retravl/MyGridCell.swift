import UIKit
import HCSStarRatingView

class MyGridCell: UICollectionViewCell {

    var imgReview: UIImageView?
    var rateView: HCSStarRatingView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imgReview = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height))
        self.imgReview?.contentMode = .scaleAspectFill
        self.imgReview?.clipsToBounds = true
        self.addSubview(self.imgReview!)
        
        self.rateView = HCSStarRatingView()
        self.rateView?.frame = CGRect(x: 10, y: 10, width: self.frame.width/3, height: 20)
        self.rateView?.backgroundColor = UIColor.clear
        self.rateView?.tintColor = UIColor.rtrPumpkinOrangeTwo
        self.addSubview(self.rateView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
    }
    
    func setup(_ review:Review) {
        let imageId = "1" // FIXME - 다수의 이미지를 업로드할때 imageId 를 적절하게 설정
        ReviewWriteManager.shared.reviewImage(review:review, imageId:imageId) { image in
            self.imgReview?.image = image
            self.rateView?.value = CGFloat(review.rating)
        }
    }

}
