import UIKit

class ReviewContentInputView:UIView {
    
    let profileView = ProfileView()
    let txtInput = UITextField()
    let btnFbShare = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.addSubview(self.profileView)
        self.addSubview(self.txtInput)
        self.btnFbShare.setImage(#imageLiteral(resourceName: "btnShareFbOff"), for: .normal)
        self.addSubview(self.btnFbShare)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        print("update ReviewContentInput constraints")
        let vs: [String: UIView] = [
            "profile": self.profileView,
            "txt": self.txtInput,
            "fb": self.btnFbShare
        ]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[profile(50)]-(20)-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[profile(50)]", options: [], metrics: nil, views: vs)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[txt]-(20)-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[profile]-(20)-[txt(100)]", options: [], metrics: nil, views: vs)
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[fb(30)]", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[txt]-(20)-[fb(30)]-(20)-|", options: [], metrics: nil, views: vs)
        NSLayoutConstraint.activate(constraints)
    }
}
