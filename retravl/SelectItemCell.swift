import UIKit

class SelectItemCell: UITableViewCell {

    var lblCode = UILabel()
    var lblText = UILabel()
    var imgSelected = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.lblCode.frame = CGRect(x:35, y:10, width: 50, height:40)
        self.lblCode.textAlignment = .left
        self.lblCode.font = UIFont(name: "AppleSDGothicNeo", size: 17)
        self.lblCode.textColor = UIColor.white
        self.addSubview(lblCode)
        self.lblText.frame = CGRect(x:85, y:10, width: 100, height:40)
        self.lblText.textAlignment = .left
        self.lblText.font = UIFont(name: "AppleSDGothicNeo", size: 17)
        self.lblText.textColor = UIColor.white
        self.addSubview(lblText)
        self.imgSelected.frame = CGRect(x:self.frame.width - 40, y:20, width:20, height:20)
        self.imgSelected.image = #imageLiteral(resourceName: "btnReviewCheckOn")
        self.imgSelected.isHidden = true
        self.addSubview(imgSelected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init!")
    }
    
    func setup(code:String, text:String, isSelected:Bool) {
        self.lblCode.text = code
        self.lblText.text = text
        self.imgSelected.isHidden = !isSelected
    }
    
    func setMark(mark:Bool) {
        self.imgSelected.isHidden = !mark
    }
    
}
