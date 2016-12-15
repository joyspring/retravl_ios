import UIKit

class ZoomableImageView: UIScrollView, UIScrollViewDelegate {
    
    let imageView = UIImageView()
    
    // MARK: - initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { // scale 할 view 를 지정
        return imageView
    }
    
    // MARK: - private
    private func setup() {
        self.delegate = self //UIScrollViewDelegate
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
    }
    
    // MARK: -
    open func setImage(_ image: UIImage) {
        let img = image
        self.imageView.contentMode = UIViewContentMode.center
        self.imageView.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        self.imageView.image = img
        self.contentSize = img.size
        
        let frameSize = self.frame.size
        let contentSize = self.contentSize
        let scaleWidth = frameSize.width / contentSize.width
        let scaleHeight = frameSize.height / contentSize.height
        let minScale = max(scaleHeight, scaleWidth)
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = 1
        self.zoomScale = minScale
        
        self.centerScrollViewContents()
    }
    
    // 이미지 zoom 이후 정중앙에 위치하도록
    open func centerScrollViewContents() {
        let boundSize = self.bounds.size
        var contentsFrame = self.imageView.frame
        var offset = CGPoint(x: 0.0, y: 0.0)
        if contentsFrame.size.width < boundSize.width {
            contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
            offset.x = (contentsFrame.size.width - boundSize.width) / 2
        }
        if contentsFrame.size.height < boundSize.height {
            contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
            offset.y = (contentsFrame.size.height - boundSize.height) / 2
        }
        self.setContentOffset(offset, animated: true)
    }
    
}
