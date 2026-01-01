import UIKit

extension UIImageView {

    func applyProfileStyle(cornerRadius: CGFloat = 7) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor

        if image == nil {
            applyPlaceholderStyle()
        } else {
            contentMode = .scaleAspectFill
        }
    }

    func loadProfileImage(from urlString: String) {
        guard !urlString.isEmpty else {
            applyPlaceholderStyle()
            return
        }

        applyPlaceholderStyle()

        FetchImage.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self, let image = image else { return }
                self.image = image
                self.contentMode = .scaleAspectFill
            }
        }
    }

    private func applyPlaceholderStyle() {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        image = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        tintColor = .systemGray3
        contentMode = .center
        backgroundColor = .clear
    }
}
