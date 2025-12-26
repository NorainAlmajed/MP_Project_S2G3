import UIKit

class NGOCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ngoImageView: UIImageView!
    @IBOutlet weak var ngoNameLabel: UILabel!
    @IBOutlet weak var ngoTypeLabel: UILabel!

    private var imageTask: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = UIColor(named: "BeigeCol")
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        // 🔹 Prevent zoomed images
        ngoImageView.contentMode = .scaleAspectFit
        ngoImageView.backgroundColor = .white
        ngoImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        ngoImageView.image = UIImage(systemName: "building.2")
    }

    func configure(with ngo: NGO) {
        ngoNameLabel.text = ngo.organizationName
        ngoTypeLabel.text = ngo.cause

        guard !ngo.profileImageURL.isEmpty,
              let url = URL(string: ngo.profileImageURL) else {
            return
        }

        loadImage(from: url)
    }

    private func loadImage(from url: URL) {
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self.ngoImageView.image = image
            }
        }
        imageTask?.resume()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false
    }
}
