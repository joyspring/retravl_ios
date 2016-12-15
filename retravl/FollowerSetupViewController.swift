import UIKit

class FollowerSetupViewController: UIViewController {
    
    // MARK - Actions
    @IBAction func btnNo(_ sender: AnyObject) {
        self.defaultFollow(false)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnYes(_ sender: AnyObject) {
        self.defaultFollow(true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnBack(_ sender: AnyObject) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    // MARK - override
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO Load.. following candidates
    }
    
    // MARK - private
    private func defaultFollow(_ agree: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(agree, forKey: "AgreeDefaultFollowing")
    }
    
}
