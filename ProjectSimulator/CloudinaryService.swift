import UIKit
import Cloudinary

final class CloudinaryService {

    static let shared = CloudinaryService()

    private let cloudinary: CLDCloudinary
    private let uploadPreset = "Nourish_Bahrain_unsigned"

    private init() {
        let config = CLDConfiguration(
            cloudName: "duqn0m9ed",
            secure: true
        )
        cloudinary = CLDCloudinary(configuration: config)
    }

    func uploadImage(
        _ image: UIImage,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: 0)))
            return
        }

        cloudinary.createUploader().upload(
            data: data,
            uploadPreset: uploadPreset,
            completionHandler: { result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = result?.secureUrl {
                        completion(.success(url))
                    } else {
                        completion(.failure(NSError(domain: "UploadError", code: 1)))
                    }
                }
            }
        )
    }
}
 
