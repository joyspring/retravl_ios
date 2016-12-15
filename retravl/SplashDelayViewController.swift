import UIKit
import FirebaseAuth

class SplashDelayViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.rtrGreyishBrown
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // after 1 second
            if !self.aleadySignIn() {
                if AuthManager.shared.credential == nil {
                    self.performSegue(withIdentifier: "segue-splash-complete", sender: self)
                } else {
                    AuthManager.shared.signUp { (user, error) in
                        self.performSegue(withIdentifier: "segue-aleady-signin", sender: self)
                    }
                }
            } else {
                self.performSegue(withIdentifier: "segue-aleady-signin", sender: self)
            }
        }
    }
    
    private func aleadySignIn() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }

}
