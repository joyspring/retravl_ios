import Photos
import FirebaseStorage
import FirebaseDatabase
import Log

class ReviewWriteManager {
    // MARK: - singletone instance
    static let shared = ReviewWriteManager()
    
    // MARK: - Error
    enum ReviewWriteError: Error {
        case DataNotFoundError
        case ConnectionFailError
    }
    
    // MARK: - const
    let CACHE_LIMIT = 100
    
    
    // MARK: var
    let log = Logger()
    var cachedImages = [String: UIImage]()
    var assets:[PHAsset]?
    var type:String?
    var reviewOnWriting: Review?
    var imageOnWriting: UIImage?
    var assetOnWriting: PHAsset?
    
    private init() {}
    
    func upload(uid:String, rid:String, imageId:String, asset:PHAsset?, cropedImage:UIImage?, complete: @escaping (FIRStorageUploadTask?, Error?) -> Void) {
        let ref = FIRStorage.storage().reference(forURL: "gs://project-7704022369003968342.appspot.com/images/\(uid)/\(rid)") //FIXME 하드코딩...
        if let asset = asset {
            PHImageManager.default().requestImageData(for: asset, options: nil) { (data, uti, orientation, info) in
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                metadata.customMetadata = ["uti": uti?.description ?? "", "orientation": "\(orientation.rawValue)", "info": info?.description ?? ""]
                
                var imgData:Data? = nil
                if let image = cropedImage {
                    imgData = UIImageJPEGRepresentation(image, 1.0)
                } else if let phData = data {
                    imgData = phData
                }
                if let d = imgData {
                    let uploadTask = ref.child(imageId).put(d, metadata: metadata)
                    complete(uploadTask, nil)
                } else {
                    complete(nil, ReviewWriteError.DataNotFoundError)
                }
            }
        } else {
            complete(nil, ReviewWriteError.DataNotFoundError)
        }
    }
    
    func delete(uid:String, rid:String, handler: @escaping (String) -> Void) {
        let ref = FIRDatabase.database().reference()
        ref.child("/reviews/\(rid)").removeValue { (err1, firRef1) in
            ref.child("/user-reviews/\(uid)/\(rid)").removeValue(completionBlock: { (err2, firRef2) in
                if let err1 = err1 {
                    handler(err1.localizedDescription)
                } else if let err2 = err2 {
                    handler(err2.localizedDescription)
                } else {
                    handler("success")
                }
            })
        }
    }
    
    // Download in memory with a maximum allowed size of 10MB (10 * 1024 * 1024 bytes)
    func reviewImage(review:Review, imageId:String, complete: @escaping (UIImage!) -> Void) {
        let imageKey = "\(review.uid)/\(review.id)/\(imageId)"
        let ref = FIRStorage.storage().reference(forURL: "gs://project-7704022369003968342.appspot.com/images/\(imageKey)")
        if self.cachedImages.keys.contains(imageKey) {
            complete(cachedImages[imageKey])
        } else {
            ref.data(withMaxSize: 10*1024*1024) { (data, err) in
                if (err != nil) {
                    self.log.error("Download Fail - \(review.id): \(imageId)")
                } else {
                    let img = UIImage(data: data!)
                    self.cachedImages[imageKey] = img
                    complete(img)
                }
            }
        }
    }
    
    func writeReview(review:Review, complete: @escaping (String, Error?) -> Void) {
        let ref = FIRDatabase.database().reference()
        let key = ref.child("reviews").childByAutoId().key
        review.id = key
        let reviewData = review.toDict()
        let childUpdates = ["/reviews/\(key)": reviewData,
                            "/user-reviews/\(review.uid)/\(key)/": reviewData]
        ref.updateChildValues(childUpdates) { childUpdates in
            complete(key, childUpdates.0)
        }
    }
    
    func loadRecentReviews(limit: Int, handler: @escaping ([Review]) -> Void){
        let ref = FIRDatabase.database().reference()
        let reviewsRef = ref.child("reviews")
        let reviews = reviewsRef.queryOrderedByKey()
        let items = reviews.queryLimited(toLast: UInt(limit))
        
        items.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let values = snapshot.value as! [String: [String: AnyObject]]
                let reviews = values.map { (k:String, v:[String: AnyObject]) in
                    return Review.fromDict(v: v)
                }
                handler(reviews)
            } else {
                handler([]) // 리뷰 없으면 빈걸 보내줘야 에러가 없다.
            }
        })
    }
}
