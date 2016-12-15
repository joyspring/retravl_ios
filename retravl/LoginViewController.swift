import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet private weak var btnGoogle: UIButton!
    @IBOutlet private weak var btnFacebook: UIButton!
    @IBOutlet private weak var imgBackground: UIImageView!
    @IBOutlet private weak var imgBackgroundOld: UIImageView!
    
    private let images: [UIImage?] = [
        UIImage(named: "bgSplashBed"),
        UIImage(named: "bgSplashEat"),
        UIImage(named: "bgSplashTravel")
    ]
    private var isOld = false
    private var onDisplay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        self.btnGoogle.backgroundColor = UIColor.rtrWhite80
        self.btnGoogle.addTarget(self, action: #selector(doGoogleSignIn), for: .touchUpInside)
        
        self.btnFacebook.backgroundColor = UIColor.rtrDenimBlue70
        self.btnFacebook.addTarget(self, action: #selector(doFacebookSignIn), for: .touchUpInside)
        
        self.onDisplay = true
        self.animateImage(no: 1)
    }
    
    // MARK: GIDSignInUIDelegate - Google Login
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)        
    }
    
    // MARK: GIDSignInDelegate
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        self.FIRSignIn(credential: credential)
    }
    
    // Google SignIn
    func doGoogleSignIn(sender:UIButton!) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    // Facebook SignIn
    func doFacebookSignIn(sender:UIButton!) {
        let loginManager:FBSDKLoginManager = FBSDKLoginManager()
        let permissions = ["public_profile", "email", "user_friends"]
        
        loginManager.logIn(withReadPermissions: permissions, from: self, handler: { (result, error) -> Void in
            if let err = error {
                print("Error \(err)")
            } else if let res = result {
                if res.isCancelled {
                    print("facebook login cancelled \(res)")
                } else {
                    print("login process")
                    print(FBSDKAccessToken.current())
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    self.FIRSignIn(credential: credential)
                }
            } else {
                print("????")
            }
        })
    }
    
    // Firebase - FIRSignIn
    func FIRSignIn(credential: FIRAuthCredential) {
        AuthManager.shared.credential = credential
        self.onDisplay = false //stop animating
        self.performSegue(withIdentifier: "segue-login-complete", sender: self)
    }

    // Background View Animation
    func animateImage(no:Int) {
        if !self.onDisplay {
            return
        }
        var imgNumber:Int = no
        if (imgNumber < 1) {
            imgNumber = 1
        }
        
        let frontView:UIImageView! = (self.isOld ? self.imgBackgroundOld : self.imgBackground)
        let backView:UIImageView! = (self.isOld ? self.imgBackground : self.imgBackgroundOld)
        
        backView!.alpha = 0.4
        backView!.image = images[imgNumber-1];

        UIView.animate(withDuration: 3.0, delay: 0, options:.curveEaseOut,
            animations: { () in
                backView!.alpha = 1.0;
                frontView!.alpha = 0.0;
            },
            completion: { (Bool) in
                imgNumber+=1;
                if imgNumber > 3 {
                    imgNumber = 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // after 3 seconds
                    self.isOld = !self.isOld
                    self.animateImage(no: imgNumber);
                }
        })
    }    
    
}
