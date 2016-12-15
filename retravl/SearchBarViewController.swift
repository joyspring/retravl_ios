import UIKit

class SearchBarViewController: UIViewController {

    @IBAction func touchClose(_ sender: AnyObject) {
        if let nav = self.navigationController {
            nav.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // FIXME - rollback
}
