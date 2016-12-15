import UIKit

class RetravlUser {
    var uid:String!
    var name:String!
    var photo:String!
    var email:String!
    var nickName:String!
    var displayId:String!
    var type:String!
    
    func toDict() -> [String:String] {
        return [
            "uid": self.uid,
            "name": self.name,
            "photo": self.photo,
            "email": self.email,
            "nickName": self.nickName,
            "displayId": self.displayId,
            "type": self.type,
        ]

    }
}
