import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let homeNavigationController = self.viewControllers?.filter({ (vc) -> Bool in
            return vc.isKind(of: HomeNavigationController.self)
        }).first as? HomeNavigationController
        
        let btnViewController = self.viewControllers?.filter({ (vc) -> Bool in
            return vc.isKind(of: ReviewButtonsViewController.self)
        }).first as? ReviewButtonsViewController
        
        btnViewController?.delegate = homeNavigationController?.topViewController as? HomeViewController
    }
    
    // MARK: - UITabBarConrollerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is DummyReviewViewController {
            self.performSegue(withIdentifier: "segue-show-buttons", sender: self)
            return false
        }
        return true
    }
    
}
