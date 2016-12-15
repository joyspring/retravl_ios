import UIKit
import Eureka

class SettingsViewController: FormViewController {
    // MARK - Actions
    @IBAction func close(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitleBarStyle("설정") // UIViewController+CustomStyle
        setupForm()
    }
    
    // MARK - private
    private func setupForm() {
        form = Section("내 계정")
            <<< ButtonRow("프로필 편집") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "EditProfileSegue", onDismiss: nil)
            }
            <<< SwitchRow("modeSwitchTag"){
                $0.title = "비공개 전환"
            }
            +++ Section("설정")
            <<< ButtonRow("연결된 계정") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "AccountSegue", onDismiss: nil)
            }
            <<< PushRow<String>() {
                $0.title = "언어"
                $0.selectorTitle = "언어 선택"
                $0.options = ["한국어", "영어"]
                $0.value = "한국어"    // initially selected
            }
            <<< SwitchRow("푸쉬 알림") {
                $0.title =  $0.tag
            }
            <<< SwitchRow("무선데이터 사용") {
                $0.title = $0.tag
            }
            +++ Section("지원")
            <<< ButtonRow("프로그램 정보") {
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "ProgramInfoSegue", onDismiss: nil)
            }
            <<< ButtonRow("로그아웃"){
                $0.title = $0.tag
                $0.presentationMode = .segueName(segueName: "LogoutSegue", onDismiss: nil) // FIXME 그냥 로그아웃 되면 되는데 cell 모양을 맞추려고 해당 property 추가
                
                }.onCellSelection { cell, row in
                    AuthManager.shared.signOut()
        }
    }
    
    // TODO - 언어 설정
}
