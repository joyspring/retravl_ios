import UIKit

class ProfileView: UIView {

    let profileImageView = UIImageView()
    let nickNameLabelView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.addSubview(self.profileImageView)
        self.addSubview(self.nickNameLabelView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        print("update PointImageReview constraints")
        
        let vs: [String: UIView] = [
            "img": self.profileImageView,
            "txt": self.nickNameLabelView
        ]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[img(30)]-(10)-[txt]-(10)-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[img(30)]-(10)-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[txt(30)]-(10)-|", options: [], metrics: nil, views: vs)
        NSLayoutConstraint.activate(constraints)
    }
}
