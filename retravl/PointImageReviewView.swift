import UIKit

class PointImageReviewView: UIView {

    let pointImageView = UIImageView()
    let reviewTextView = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.pointImageView.translatesAutoresizingMaskIntoConstraints = false
        self.reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.pointImageView)
        self.addSubview(self.reviewTextView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        let vs: [String: UIView] = [
            "img": self.pointImageView,
            "txt": self.reviewTextView
        ]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[img]|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[img]", options: [], metrics: nil, views: vs)
        constraints += [NSLayoutConstraint(item: self.pointImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.pointImageView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 1)]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[txt]-(5)-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[txt]-(10)-|", options: [], metrics: nil, views: vs)
        NSLayoutConstraint.activate(constraints)
    }
}
