import UIKit

class ZoomCropToggleImageView: UIView {
    let zoomImageView = ZoomableImageView()
    private let gridImageView = UIImageView(image: #imageLiteral(resourceName: "grid"))
    private let cropButton = UIButton(type: .custom)
    private let cropModeOnImage:UIImage = #imageLiteral(resourceName: "btnImgCropOn")
    private let cropModeOffImage:UIImage = #imageLiteral(resourceName: "btnImgCropOff")
    private var isEditMode = false
    
    // MARK: - initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.zoomImageView.frame = CGRect(x:0, y:0, width:self.frame.width, height:self.frame.height)
        self.gridImageView.frame = CGRect(x:0, y:0, width:self.frame.width, height:self.frame.height)
        self.cropButton.frame = CGRect(x: self.frame.size.width + 10.0, y: self.frame.size.height - 10 - 30.0, width: 30, height:30)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false // 와 이거 안해준다고 아예 뷰가 안나오네... 이거 꼭해야함...
        self.zoomImageView.translatesAutoresizingMaskIntoConstraints = false
        self.gridImageView.translatesAutoresizingMaskIntoConstraints = false
        self.cropButton.translatesAutoresizingMaskIntoConstraints = false
        self.setup()
        self.setNeedsUpdateConstraints()
    }
    override func updateConstraints() {
        super.updateConstraints()
        let vs: [String: UIView] = [
            "zoomImageView": self.zoomImageView,
            "gridImageView": self.gridImageView,
            "cropButton": self.cropButton
        ]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[cropButton(30)]-10-|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cropButton(30)]", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[gridImageView]|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[gridImageView]|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[zoomImageView]|", options: [], metrics: nil, views: vs)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[zoomImageView]|", options: [], metrics: nil, views: vs)
        NSLayoutConstraint.activate(constraints)
    }
    private func setup() {
        // zoomImageView
        self.zoomImageView.isUserInteractionEnabled = false // default false
        self.addSubview(self.zoomImageView)
        // gridImageView
        self.gridImageView.alpha = 0.2
        self.gridImageView.isHidden = true // default hidden
        self.addSubview(self.gridImageView)
        // cropButton
        self.cropButton.setImage(self.cropModeOffImage, for: .normal)
        self.cropButton.addTarget(self, action: #selector(toggleCropMode), for: .touchUpInside)
        self.addSubview(self.cropButton)
    }
    
    // MARK: - action handler
    func toggleCropMode(sender:UIButton) {
        self.isEditMode = !self.isEditMode
        
        self.zoomImageView.isUserInteractionEnabled = self.isEditMode
        self.gridImageView.isHidden = !self.isEditMode
        if self.isEditMode {
            self.cropButton.setImage(cropModeOnImage, for: .normal)
        } else {
            self.cropButton.setImage(cropModeOffImage, for: .normal)
        }
    }
    
    // MARK: - open
    open func getCropedImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.zoomImageView.bounds.size, true, UIScreen.main.scale)
        let offset = zoomImageView.contentOffset
        var image:UIImage? = nil
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.translateBy(x: -offset.x, y: -offset.y)
            zoomImageView.layer.render(in: ctx)
            
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }

}
