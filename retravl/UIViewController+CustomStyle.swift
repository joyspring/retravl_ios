import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "") -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setupNavigationTitleBarStyle(_ title:String) -> Void {
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height))
        titleLabel.textColor = UIColor.rtrGreyishBrown
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        titleLabel.text = title
        navigationItem.titleView = titleLabel
    }
    
    func getImage(_ asset:PHAsset, handler: @escaping (UIImage?) -> Void) -> Void {
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: nil) { (image, info) in
            handler(image)
        }
    }
    func getAssetThumbnail(_ asset: PHAsset, width: CGFloat) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: width, height: width), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

}
