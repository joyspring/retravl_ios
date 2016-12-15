import FirebaseAuth
import FirebaseDatabase

class AuthManager {
    static let shared = AuthManager()
    internal var credential:FIRAuthCredential?
    internal var nickName:String?
    internal var userType:String?
    internal var displayId:String?
    private var cachedProfile:RetravlUser?
    private init() {}
    
    func signUp(_ complete: @escaping (FIRUser?, Error?) -> Void) {
        if let cr = self.credential {
            FIRAuth.auth()?.signIn(with: cr) { (user, error) in
                let retravlUser = RetravlUser()
                retravlUser.uid = user!.uid
                retravlUser.name = user!.displayName!
                retravlUser.photo = user!.photoURL!.absoluteString
                retravlUser.email = user!.email!
                retravlUser.nickName = self.nickName!
                retravlUser.displayId = self.displayId!
                retravlUser.type = self.userType!
                
                let ref = FIRDatabase.database().reference()
                ref.child("users").child(retravlUser.uid).setValue(retravlUser.toDict())
                self.cachedProfile = retravlUser
                complete(user, error)
            }
        }
    }
    
    func signOut() {
        try! FIRAuth.auth()?.signOut()
    }
    
    func uid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func getMyProfile(handler: @escaping (RetravlUser) -> Void) {
        if let user = self.cachedProfile {
            handler(user)
        } else {
            self.getUserInfo(uid: self.uid()) { (user) in
                self.cachedProfile = user
                handler(user)
            }
        }
    }
    
    func getUserInfo(uid:String, block: @escaping (RetravlUser) -> Void) {
        let ref = FIRDatabase.database().reference()
        let userRef = ref.child("users")
        userRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! [String: String]
            let retravlUser = RetravlUser()
            retravlUser.uid = userDict["uid"]
            retravlUser.name = userDict["name"]
            retravlUser.photo = userDict["photo"]
            retravlUser.email = userDict["email"]
            retravlUser.nickName = userDict["nickName"]
            retravlUser.displayId = userDict["displayId"]
            retravlUser.type = userDict["type"]
            block(retravlUser)
        })
    }
}

