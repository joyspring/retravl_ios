import UIKit

class SelectItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let btnCancel = UIButton(type: .custom)
    var btnComplete = UIButton(type: .custom)
    var tableView = UITableView()
    var lblTitle = UILabel()
    var identifier = "SelectItemViewCell"
    var delegate:SelectItemDelegate?
    var dataSource:SelectItemDataSource?
    var items: [SelectItemData]?
    var selectedIndex = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.rtrBlack50
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        self.lblTitle.text = "통화단위"
        self.lblTitle.textColor = UIColor.rtrPumpkinOrangeTwo
        self.lblTitle.font = UIFont(name: "AppleSDGothicNeo-Light", size: 17.0)
        self.lblTitle.textAlignment = .center
        self.lblTitle.frame = CGRect(x:(self.view.frame.width - 65)/2,y:30,width:65,height:20)
        self.view.addSubview(self.lblTitle)
        
        self.btnCancel.setImage(#imageLiteral(resourceName: "btnNaviBack"), for: .normal)
        self.btnCancel.frame = CGRect(x:13, y:30, width:12, height:30)
        self.btnCancel.addTarget(self, action: #selector(cancelSelect), for: .touchUpInside)
        self.view.addSubview(self.btnCancel)
        
        self.btnComplete.setTitle("완료", for: .normal)
        self.btnComplete.backgroundColor = UIColor.rtrPumpkinOrangeTwo
        self.btnComplete.frame = CGRect(x:20, y:self.view.frame.height - 70, width: self.view.frame.width - 40, height: 50)
        self.btnComplete.layer.cornerRadius = 3
        self.btnComplete.addTarget(self, action: #selector(complete), for: .touchUpInside)
        self.view.addSubview(self.btnComplete)
        
        self.tableView = UITableView()
        self.tableView.frame = CGRect(x: 0, y: 70, width: self.view.frame.width, height: self.view.frame.height - 140)
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(SelectItemCell.self, forCellReuseIdentifier: "SelectItemViewCell")
        self.updateData()
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if let data = self.items {
            let d = data[indexPath.row]
            if let c = cell as? SelectItemCell {
                c.setup(code: d.code ?? "", text: d.text ?? "", isSelected:self.selectedIndex == indexPath.row)
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        
    }
    
    func cancelSelect(_ id:AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func complete(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.completeSelect(item: self.items?[self.selectedIndex])
        }
    }
    
    private func updateData() {
        self.items = dataSource?.selectItems()
        self.tableView.reloadData() // reload!
    }
}

protocol SelectItemDelegate {
    func completeSelect(item:SelectItemData?)
}

protocol SelectItemDataSource {
    func selectItems() -> [SelectItemData]
}

class SelectItemData {
    var code: String?
    var text: String?
    init(code:String, text:String) {
        self.code = code
        self.text = text
    }
}
