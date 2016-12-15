import UIKit
import FirebaseAuth
import FirebaseDatabase

class NickSetupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtNick:UITextField!
    @IBOutlet weak var lblNickMessage: UILabel!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var lblUserIdMessage: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Actions
    @IBAction func btnback(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    @IBAction func btnPushNext(_ sender: UIButton) {
        if self.validate(txtNick.text!) {
            self.checkExists(nickName: txtNick.text!, displayId: txtUserId.text!)
        } else {
            self.lblNickMessage.text = "특수문자를 제외한 2자 이상, 7자 이내 문자로 입력해주세요"
            self.lblNickMessage.textColor = UIColor.rtrSunYellow
        }
    }
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNotificationObserver()
    }
    
    // MARK: protocol - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: private
    private func setLayout() {
        // FIXME: txtfield 를 별로의 클래스로 분리해서 사용할 수 있도록..
        txtNick.layer.cornerRadius = 5
        txtNick.delegate = self
        lblNickMessage.text = "띄어쓰기 포함 최대 15자까지 가능해요!"
        lblNickMessage.textColor = UIColor.rtrWhite
        
        txtUserId.layer.cornerRadius = 5
        txtUserId.delegate = self
        lblUserIdMessage.text = "띄어쓰기, 특수문자 제외, 최대 15자까지 가능해요!"
        lblUserIdMessage.textColor = UIColor.rtrWhite
    }
    private func setNotificationObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(keyboardWillShow),
                       name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self,
                       selector: #selector(keyboardWillHide),
                       name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    private func checkExists(nickName: String, displayId: String) {
        let ref = FIRDatabase.database().reference(withPath: "/users")
        ref.queryEqual(toValue: nickName, childKey: "nickName").queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.lblNickMessage.text = "'이런, 이미 사용 중인 닉네임'이네요. 더 멋진 걸로 찾아볼까요?'"
                self.lblNickMessage.textColor = UIColor.rtrSunYellow
            } else {
                AuthManager.shared.nickName = nickName
                AuthManager.shared.displayId = displayId
                self.performSegue(withIdentifier: "segue-complete-nick", sender: self)
            }
        })
    }
    private func validate(_ txt:String) -> Bool {
        return !txt.isEmpty && txt.characters.count > 1 && txt.characters.count < 16
    }
    
    // MARK: keyboard layout adjust
    func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
}
