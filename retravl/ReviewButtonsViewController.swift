import UIKit
import Photos
import QBImagePickerController

protocol ReviewButtonViewDelegate {
    func completeReview() -> Void
}

class ReviewButtonsViewController: UIViewController, QBImagePickerControllerDelegate {

    let tagMap = [
        31: "Sleep",
        32: "Eat",
        33: "Shop",
        34: "Do",
        35: "Transport"
    ]
    
    var delegate:ReviewButtonViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tap)
    }
    
    func closeView() {
        self.dismiss(animated: true) {
            self.delegate?.completeReview()
        }
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        imagePickerController.dismiss(animated: true) {
            ReviewWriteManager.shared.assets = assets as? [PHAsset]
            self.performSegue(withIdentifier: "segue-complete-select-photos", sender: self)
        }
    }
    
    
    // MARK: Actions
    @IBAction func startNewReview(_ sender:UIButton) {
        ReviewWriteManager.shared.type = tagMap[sender.tag]
        
        let picker = QBImagePickerController()
        picker.delegate = self
        picker.allowsMultipleSelection = true
        picker.maximumNumberOfSelection = 5
        picker.showsNumberOfSelectedAssets = true
        
        present(picker, animated: true, completion: nil)
    }
    
}
