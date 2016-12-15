import UIKit

class LogoutViewController: UIViewController {

    @IBAction func btnLogout(_ sender: AnyObject) {
        AuthManager.shared.signOut()
    }
    
}
