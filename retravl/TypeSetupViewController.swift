//
//  TypeSetupViewController.swift
//  retravl
//
//  Created by kakao on 2016. 7. 30..
//  Copyright © 2016년 retravl. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TypeSetupViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMessage:UILabel!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnPrivate: UIButton!
    
    private var focusButtonTag = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblDescription.text = ""
        self.lblMessage.text = ""
        self.setStyle()
        self.setPublic(self) //기본으로 공개 설정
    }
    
    @IBAction func setPublic(_ sender: AnyObject) {
        self.lblDescription.text = "나의 프로필과 활동 여부를\n기존 친구들에게 공개합니다."
        self.setFocus(self.btnPublic.tag)
    }
    
    @IBAction func setPrivate(_ sender: AnyObject) {
        self.lblDescription.text = "나의 프로필과 활동 여부를 익명으로 하며\n기존 친구들에게 비공개합니다."
        self.setFocus(self.btnPrivate.tag)
    }
    
    @IBAction func completeSignup(_ sender: AnyObject) {
        var type = ""
        switch (focusButtonTag) {
        case 3:
            type = "private"
            break
        case _:
            type = "public"
            break
        }
        AuthManager.shared.userType = type
        
        // TODO 이미 익명 사용 중이며 아래 메시지 표시할 수 있도록 추가
        // let currentType = userRef.valueForKey("type")?.string
        // self.lblMessage.text = "현재 익명 계정을 사용중이며,\n공개 계정을 추가할 수 있습니다."
        
        self.performSegue(withIdentifier: "segue-complete-type", sender: self)
    }
    
    private func setStyle() {
        addRoundStyle(self.btnPublic)
        addRoundStyle(self.btnPrivate)
    }
    
    private func addRoundStyle(_ btn: UIButton) {
        btn.layer.cornerRadius = 35
        btn.layer.backgroundColor = UIColor.rtrBlack20.cgColor
    }
    
    private func setFocus(_ btnTag: Int) {
        focusButtonTag = btnTag
        [self.btnPublic, self.btnPrivate].forEach { (b) in
            if (b?.tag != btnTag) {
                b?.setTitleColor(UIColor.lightGray, for: .normal)
                b?.layer.backgroundColor = UIColor.rtrBlack20.cgColor
            } else {
                b?.setTitleColor(UIColor.rtrPumpkinOrange, for: .normal)
                b?.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }

}
