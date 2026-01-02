import UIKit

extension UIImageView {

    func applyProfileStyle(
        cornerRadius: CGFloat = 7,
        showsPlaceholder: Bool = true
    ) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        backgroundColor = UIColor.systemGray6

        contentMode = .scaleAspectFill

        if showsPlaceholder && image == nil {
            setPlaceholderIcon()
        }
    }

    func setPlaceholderIcon() {
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        let image = UIImage(
            systemName: "photo",
            withConfiguration: config
        )

        self.image = image
        self.tintColor = .systemGray3
        self.contentMode = .center
    }

    func setRealImage(_ image: UIImage) {
        self.image = image
        self.contentMode = .scaleAspectFill
        self.tintColor = nil
    }

    func loadProfileImage(from urlString: String) {
        guard !urlString.isEmpty else {
            setPlaceholderIcon()
            return
        }

        setPlaceholderIcon()

        FetchImage.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                if let image = image {
                    self?.setRealImage(image)
                }
            }
        }
    }
}
