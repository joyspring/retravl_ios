extension Review {
    func toDict() -> [String: Any] {
        return [
            "id": self.id,
            "uid": self.uid,
            "profileImageId": self.profileImageId,
            "createdAt": self.createdAt,
            "updatedAt": self.updatedAt,
            "title": self.title ?? "",
            "rating": self.rating,
            "previewImageId": self.previewImageId,
            "price": self.price,
            "location": self.location,
            "tags": self.tags ?? [],
            "contents": self.contents,
            "likes": self.likes,
            "comments": self.comments,
            "shares": self.shares,
            "points": self.pointReviews as NSArray
        ]
    }
    
    static func fromDict(v:[String: Any]) -> Review {
        // FIXME type casting error 에 대한 대처가 필요
        let r = Review()
        r.id = v["id"] as! String
        r.uid = v["uid"] as! String
        r.profileImageId = v["profileImageId"] as! String
        r.createdAt = v["createdAt"] as? String ?? ""
        r.updatedAt = v["updatedAt"] as? String ?? ""
        r.title = v["title"] as? String
        r.rating = v["rating"] as? NSNumber ?? 0.0
        r.previewImageId = v["previewImageId"] as! String
        r.price = v["price"] as! NSNumber
        r.location = v["location"] as! String
        r.tags = [] // TODO
        r.contents = v["contents"] as! String
        r.likes = v["likes"] as! NSNumber
        r.comments = v["comments"] as! NSNumber
        r.shares = v["shares"] as! NSNumber
        return r
    }
}
