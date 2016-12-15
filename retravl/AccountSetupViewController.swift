import UIKit
import Eureka

class AccountSetupViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form = Section("")
            <<< SwitchRow("페이스북") {
                $0.title = $0.tag
            }
            <<< SwitchRow("구글") {
                $0.title = $0.tag
            }
            +++ Section("")
            <<< ButtonRow("RETRAVL 탈퇴") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "TerminateSegue", onDismiss: nil)
            }
        setTitle()
    }
    
    // MARK: private
    private func setTitle() {
        navigationItem.title = "설정"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height))
        titleLabel.text = "설정"
        titleLabel.textColor = UIColor.rtrGreyishBrown
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        navigationItem.titleView = titleLabel
    }
    
    // TODO - 언어 설정
}
