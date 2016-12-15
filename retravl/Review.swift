import UIKit

class Review {
    var id:String
    var uid:String
    var profileImageId: String
    var createdAt: String
    var updatedAt: String
    var title: String?
    
    var rating: NSNumber // 1 ~ 5
    var previewImageId: String
    
    var price: NSNumber
    
    var location: String
    var tags: [String]?
    var contents: String
    var likes: NSNumber
    var comments: NSNumber
    var shares: NSNumber
    
    var pointReviews: [PointReview] = []
    
    init() {
        self.id = "not yet"
        self.uid = "not yet"
        self.profileImageId = "not yet"
        self.createdAt = "\(Date().timeIntervalSince1970 * 1000)"
        self.updatedAt = "\(Date().timeIntervalSince1970 * 1000)"
        self.title = "not yet"
        
        self.rating = 0.0
        self.previewImageId = "not yet"
        
        self.price = 0
        self.location = "not yet"
        self.contents = "not yet"
        self.likes = 0
        self.comments = 0
        self.shares = 0
        self.pointReviews = []
    }
}

class PointReview {
    var rate:Float?
    var title:String?
    var comment:String?
    var position: CGPoint?
    
    init () {
        self.rate = 0.0
        self.title = ""
        self.comment = ""
        self.position = CGPoint(x: 0, y: 0)
    }
    
    init(rate: Float, title: String, comment: String, position: CGPoint) {
        self.rate = rate
        self.title = title
        self.comment = comment
        self.position = position
    }
}
