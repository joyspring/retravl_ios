import UIKit
import Fabric
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        Fabric.with([Crashlytics.self])
        FIRApp.configure()

        // Facebook Sign-in
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Google Sign-in
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
        
        // Style Setting
        application.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor.rtrPumpkinOrange
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.rtrWhite], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.rtrPumpkinOrange], for:.selected)
       
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.rtrGreyishBrown
        navigationBarAppearace.barTintColor = UIColor.rtrWhite
        //navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: UIFont.init(name: "AppleSDGothicNeo-Light", size: 14)]

        
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme == "fb624962084346879" {
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

}

