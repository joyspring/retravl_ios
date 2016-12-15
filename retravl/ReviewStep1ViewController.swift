import UIKit
import Photos
import NVActivityIndicatorView
import Log

class ReviewStep1ViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, ReviewCalendarDelegate, SelectItemDelegate, SelectItemDataSource {
    
    // MARK: - variables
    let log = Logger()
    let formatter = DateFormatter()
    var asset: PHAsset? = nil
    var dates: [Date] = []
    
    // MARK: - outlets
    @IBOutlet weak var imageScrollView: ZoomCropToggleImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblMoneyType: UILabel!
    @IBOutlet weak var stkLocation: UIView!
    @IBOutlet weak var stkDate: UIView!
    @IBOutlet weak var stkPrice: UIView!
    
    // MARK: - actions
    @IBAction func backStep(_ id:AnyObject) {
        self.confirmCancel {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func confirmCancel(complete: @escaping () -> Void) {
        let alertController = UIAlertController(title: "작성한 리뷰를 삭제하시겠습니까?", message: "지금 돌아가면 리뷰 작성내용이 사라집니다.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { (action) in
            complete()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.log.info("Review - Type: \(ReviewWriteManager.shared.type)")

        self.txtPrice.delegate = self
        self.txtDate.delegate = self
        self.txtLocation.delegate = self
        self.applyTextFieldStyles()
        
        self.setTitle()
        self.addKeyboardObserver()
        self.loadData()
        self.formatter.dateFormat = "MMM dd,yyyy"
        
        // currency select
        self.lblMoneyType.isUserInteractionEnabled = true
        self.lblMoneyType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReviewStep1ViewController.selectCurrency)))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue-show-calendar" {
            if let vc = segue.destination as? ReviewCalendarViewController {
                vc.delegate = self
            }
        }
    }
    // MARK: - action
    func selectCurrency(_ id: AnyObject) {
        let vc = SelectItemViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.dataSource = self
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - SelectItemDelegate
    func completeSelect(item: SelectItemData?) {
        if let d = item {
            self.lblMoneyType.text = d.text
        }
    }
    // MARK: - SelectItemDataSource
    let currencyData = [
        SelectItemData(code: "AUD", text: "$"),
        SelectItemData(code: "DZD", text: "دج"),
        SelectItemData(code: "AWG", text: "ƒ")
    ]
    func selectItems() -> [SelectItemData] {
        return self.currencyData
    }
    
    
    // MARK: - ReviewCalendarDelegate
    func dates(controller: UIViewController, dates: [Any]) {
        if let ds = dates as? [Date] {
            self.dates = ds
            if let from = ds.first, let to = ds.last {
                self.txtDate.text = "\(self.formatter.string(from: from)) ~ \(self.formatter.string(from: to))"
            }
        }
    }
    
    // MARK: - Keyboard observer
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
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
    
    // MARK: - private
    private func applyTextFieldStyles() {
        self.stkLocation.addBorder(edges: .bottom, colour: UIColor.rtrBlack10, thickness: 1.0)
        self.stkDate.addBorder(edges: .bottom, colour: UIColor.rtrBlack10, thickness: 1.0)
        self.stkPrice.addBorder(edges: .bottom, colour: UIColor.rtrBlack10, thickness: 1.0)
    }
    private func setTitle() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "다음", style: .plain, target: self, action: #selector(nextStep))
        setupNavigationTitleBarStyle("총점 ★ 0  0개의 피드백")
    }
    private func loadData() {
        let assets = ReviewWriteManager.shared.assets
        if (assets?.count)! > 0 {
            self.asset = assets![0]
            self.getImage(self.asset!) { image in
                if let img = image {
                    self.imageScrollView.zoomImageView.setImage(img)
                }
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtDate {
            self.performSegue(withIdentifier: "segue-show-calendar", sender: self)
        }
    }
    
    func nextStep(_ id:AnyObject) {
        // create review
        let review = Review()
        review.id = "" // write 시점에 자동으로 셋팅
        review.uid = AuthManager.shared.uid()
        review.profileImageId = "" // FIXME
        review.previewImageId = "" // FIXME
        review.title = "" // FIXME
        review.contents = "" // FIXME
        review.createdAt = self.txtDate.text ?? ""
        review.location = self.txtLocation.text ?? ""
        review.price = NSNumber(value: Float(self.txtPrice.text ?? "0") ?? 0.0)
        
        
        review.tags = [] // FIXME
        review.rating = 2 // FIXME
        review.likes = 0
        review.comments = 0
        review.shares = 0
        ReviewWriteManager.shared.reviewOnWriting = review
        ReviewWriteManager.shared.imageOnWriting = self.imageScrollView.getCropedImage()
        ReviewWriteManager.shared.assetOnWriting = self.asset
        
        self.performSegue(withIdentifier: "segue-review-step2", sender: self)
        //upload(id) // FIXME - 나증에 할건데 일단 실험을 위해서 여기에 넣어둠
    }
    
    // TODO - 언어 설정
}
