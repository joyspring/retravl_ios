import UIKit
import NVActivityIndicatorView

class ReviewStep2ViewController: UIViewController, NVActivityIndicatorViewable {
    
    // MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Subviews
    let contentView = UIView()
    let lblSummary = UILabel()
    let customInputView = ReviewContentInputView()
    let pointImageViewGroup = PointImageReviewView()
    
    @IBAction func goBack(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    @IBAction func goComplete(_ sender: UIButton) {
        self.upload(sender) {
            if let nav = self.navigationController {
                nav.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        AuthManager.shared.getMyProfile { (user) in
            let profileImageView = self.customInputView.profileView.profileImageView
            let nickNameLabelview = self.customInputView.profileView.nickNameLabelView
            profileImageView.setImageFromURl(stringImageUrl: user.photo)
            profileImageView.layer.masksToBounds = true
            profileImageView.layer.cornerRadius = profileImageView.bounds.size.height/2
            nickNameLabelview.text = user.nickName
        }
        */
        lblSummary.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        lblSummary.text = "hello"
        lblSummary.textAlignment = .center
        lblSummary.backgroundColor = UIColor.white
        scrollView.addSubview(lblSummary)
        
//        customInputView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(customInputView)
        
        pointImageViewGroup.frame = CGRect(x: 0, y: 120, width: self.view.frame.width, height: 300)
        scrollView.addSubview(pointImageViewGroup)
        
        
        
        //self.scrollView.addSubview(self.customInputView)
        //self.addPointImages()
        
        self.setupNavigationTitleBarStyle("리뷰 완료")
    }

    private func addPointImages() {
        pointImageViewGroup.pointImageView.image = ReviewWriteManager.shared.imageOnWriting
        self.scrollView.addSubview(self.pointImageViewGroup)
    }
    /*
    override func updateViewConstraints() {
        super.updateViewConstraints() // WARNING 이거 꼭 해야함...
        
     
        print("update ReviewStep2 constraints")
        let vs: [String: UIView] = [
            "summary": self.lblSummary,
            "input": self.customInputView,
            "point": self.pointImageViewGroup
        ]
        
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[summary(50)]-(20)-[input(150)]-(20)-[point(300)]-(10)-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[summary]|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[input]|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[point]|", options: [], metrics: nil, views: vs)
        NSLayoutConstraint.activate(constraints)
 
    }
 */
    
    func upload(_ sender: AnyObject, complete: @escaping () -> Void) {
        // 1. show indicator
        self.startAnimating(CGSize.init(width: 60, height: 60),
                            message: "Uploading...",
                            type: NVActivityIndicatorType.ballBeat,
                            color: UIColor.white,
                            padding: 0,
                            displayTimeThreshold: 0,
                            minimumDisplayTime: 0)
        // 2. ger Review
        let reviewOnWriting = ReviewWriteManager.shared.reviewOnWriting
        if let review = reviewOnWriting {
            // append data
            review.contents = self.customInputView.txtInput.text ?? ""
            
            // 3. write Review
            ReviewWriteManager.shared.writeReview(review: review) { (rid, error) in
                // 4. upload images
                let imageId = "1" // FIXME
                let imageOnWriting = ReviewWriteManager.shared.imageOnWriting
                let assetOnWriting = ReviewWriteManager.shared.assetOnWriting
                if let image = imageOnWriting, let asset = assetOnWriting {
                    ReviewWriteManager.shared.upload(uid: review.uid, rid: rid, imageId: imageId, asset: asset, cropedImage: image) { (uploadTask, error) in
                        if let task = uploadTask {
                            task.observe(.progress) { snapshot in
                                if let fraction = snapshot.progress?.fractionCompleted {
                                    print ("Upload Progress \(round(fraction*100))")
                                }
                            }
                            task.observe(.success) { snaphost in
                                self.stopAnimating()
                                let defaults = UserDefaults.standard
                                let doneFirstReview = defaults.bool(forKey: "DoneFirstReview")
                                let doneRate = defaults.bool(forKey: "DoneRate")
                                if !doneFirstReview && !doneRate {
                                    defaults.set(true, forKey: "DoneFirstReview")
                                }
                                complete()
                            }
                        } else if let error = error {
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

