import UIKit
import FirebaseDatabase
import NVActivityIndicatorView

enum EmptyResultError {
    case reviews
}

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable, ReviewButtonViewDelegate  {
    
    let FETCH_SIZE:UInt = 5
    let DEFAULT_ROWSIZE = 1
    let reviewUpdateNotificationName = NSNotification.Name(rawValue: "ReviewTimelineUpdateNotification")
    var selectedReviewId = 0
    var reviews:[Review] = []
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        addSearchButton()
        addUpdateObserver()
        setNeedUpdateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        suggestRateApp() // 앱 리뷰를 할건지 물어보는 alert 를 띄우기 (글이 처음 1개 등록한 시점을 Default 를 통해서 확인
    }
    
    // MARK: - Observer
    func addUpdateObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: reviewUpdateNotificationName, object: nil)
    }
    func setNeedUpdateData() {
        NotificationCenter.default.post(name: reviewUpdateNotificationName, object: nil)
    }
    
    // MARK: - ReviewButtonViewDelegate
    func completeReview() {
        print("completeReview!")
        self.setNeedUpdateData()
    }
    
    // MARK: - UICollectionViewController
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    // MARK: - Prepare for Segue
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue-show-review") {
            let vc = segue.destination
            if vc is ReviewDetailViewController {
                let rv = vc as ReviewDetailViewController
                rv.setReviewId(self.selectedReviewId)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCell", for: indexPath)
        
        let review = reviews[indexPath.row]
        let timelineCell = cell as! TimelineCell
        timelineCell.setup(review: review)
        
        if review.uid == AuthManager.shared.uid() {
            timelineCell.btnMore.tag = indexPath.row
            timelineCell.btnMore.addTarget(self, action: #selector(moreOptions), for: .touchUpInside)
        } else {
            timelineCell.btnMore.isHidden = true
            // TODO: 다른사람의 글일때 처리
        }
        
        return timelineCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width, height:265 + view.frame.width) // FIXME add comment view height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedReviewId = reviews[indexPath.row].id
        self.performSegue(withIdentifier: "segue-show-review", sender: self)
    }
    
    // MARK: - Action
    func moreOptions(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction(title: "수정", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Edited")
        })
        let shareAction = UIAlertAction(title: "페이스북 공유하기", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Shared")
        })
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.confirmDelete {
                let uid = AuthManager.shared.uid()
                let rid = self.reviews[sender.tag].id
                ReviewWriteManager.shared.delete(uid: uid, rid: rid) { (result) in
                    let alrt = UIAlertController(title: "삭제 완료 - \(result)", message: "", preferredStyle: .alert)
                    alrt.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alrt, animated:true) {
                        self.setNeedUpdateData()
                    }
                }
            }
            
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        optionMenu.addAction(modifyAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: - alert
    private func confirmDelete(complete: @escaping () -> Void) {
        let alertController = UIAlertController(title: "리뷰 삭제", message: "이 게시물을 리트래블 에서 영구적으로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { (action) in
            complete()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - private
    private func suggestRateApp() {
        let defaults = UserDefaults.standard
        let doneFirstReview = defaults.bool(forKey: "DoneFirstReview")
        let doneRate = defaults.bool(forKey: "DoneRate")
        if doneFirstReview && !doneRate {
            defaults.set(true, forKey: "DoneRate")
            let alertController = UIAlertController(title: "평가를 남겨주세요!", message: "RETRAVL 앱의 평가를 남겨주세요", preferredStyle: .alert)
            let ReviewAction = UIAlertAction(title: "평가하러가기", style: .default, handler: nil)
            let OKAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
            alertController.addAction(ReviewAction)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    private func setTitle() {
        let imageView = UIImageView.init(image: UIImage(named: "retravlLogoBig"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 12)
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
    }
    private func addSearchButton() {
        let searchBtn = UIButton(type:.custom)
        searchBtn.setImage(UIImage(named: "naviMenuSearch"), for: .normal)
        searchBtn.frame = CGRect(x:0,y:0,width:25,height:25)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
        searchBtn.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        let dummyView = UIView()
        dummyView.frame = CGRect(x:0,y:0,width:25,height:25)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dummyView)
    }
    
    func loadData() {
        self.startAnimating()
        ReviewWriteManager.shared.loadRecentReviews(limit: 5) { reviews in
            self.reviews = reviews
            self.collectionView?.reloadData()
            self.stopAnimating()
        }
    }
    
    func search(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "segue-show-searchbar", sender: self)
    }
    
}
