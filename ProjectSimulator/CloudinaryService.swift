//import UIKit
//import Cloudinary
//
//final class CloudinaryService {
//
//    static let shared = CloudinaryService()
//
//    private let cloudinary: CLDCloudinary
//    private let uploadPreset = "Nourish_Bahrain_unsigned"
//
//    private init() {
//        let config = CLDConfiguration(
//            cloudName: "duqn0m9ed",
//            secure: true
//        )
//        cloudinary = CLDCloudinary(configuration: config)
//    }
//
//    func uploadImage(
//        _ image: UIImage,
//        completion: @escaping (Result<String, Error>) -> Void
//    ) {
//        guard let data = image.jpegData(compressionQuality: 0.8) else {
//            completion(.failure(NSError(domain: "ImageError", code: 0)))
//            return
//        }
//
//        cloudinary.createUploader().upload(
//            data: data,
//            uploadPreset: uploadPreset,
//            completionHandler: { result, error in
//                DispatchQueue.main.async {
//                    if let error = error {
//                        completion(.failure(error))
//                    } else if let url = result?.secureUrl {
//                        completion(.success(url))
//                    } else {
//                        completion(.failure(NSError(domain: "UploadError", code: 1)))
//                    }
//                }
//            }
//        )
//    }
//}
 



import UIKit
import Cloudinary

class CloudinaryService {

    let cloudName: String = "duqn0m9ed"
    var uploadPreset: String = "Nourish_Bahrain_unsigned"
    var publicId: String = "<your_public_id>" //NEW - The public ID of the image to transform

    var cloudinary: CLDCloudinary!
    var url: String! //NEW - URL variable

    // NEW: init so Cloudinary is ready without viewDidLoad
    init() {
        initCloudinary()
    }

    private func initCloudinary() {
        let config = CLDConfiguration(cloudName: cloudName, secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }

    // NEW - Generate URL function
    func generateUrl() {
        url = cloudinary.createUrl()
            .setTransformation(CLDTransformation().setEffect("sepia"))
            .generate(publicId)
    }

    // NEW: Set image view function (now takes the imageView as parameter)
    func setImageView(_ imageView: CLDUIImageView) {
        imageView.cldSetImage(url, cloudinary: cloudinary)
    }

    // NEW: Upload function (now takes UIImage instead of fixed Assets image)
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let data = image.pngData() else {
            completion(nil)
            return
        }

        cloudinary.createUploader().upload(
            data: data,
            uploadPreset: uploadPreset,
            completionHandler: { response, error in
                DispatchQueue.main.async {
                    guard let url = response?.secureUrl else {
                        completion(nil)
                        return
                    }
                    completion(url)
                }
            }
        )
    }
}
