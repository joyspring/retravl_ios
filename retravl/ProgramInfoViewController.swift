import UIKit
import Eureka

class ProgramInfoViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form = Section("")
            <<< TextRow(){ row in
                row.title = "현재 버전"
                row.placeholder = "1.0.0"
            }
            <<< TextRow(){ row in
                row.title = "최신 버전"
                row.placeholder = "1.0.0"
            }
            +++ Section("")
            <<< ButtonRow("이용약관") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "TermSegue", onDismiss: nil)
            }
            <<< ButtonRow("개인정보취급방침") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "PrivacySegue", onDismiss: nil)
            }
        
        setTitle()
    }
    
    // MARK: private
    private func setTitle() {
        navigationItem.title = "프로그램 정보"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x:0, y:0, width:view.frame.width, height:view.frame.height))
        titleLabel.text = "프로그램 정보"
        titleLabel.textColor = UIColor.rtrGreyishBrownTwo
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        navigationItem.titleView = titleLabel
    }

    // TODO - 언어 설정
}
