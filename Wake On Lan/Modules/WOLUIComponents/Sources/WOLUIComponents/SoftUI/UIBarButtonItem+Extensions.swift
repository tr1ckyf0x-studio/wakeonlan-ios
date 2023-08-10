import UIKit
extension UIBarButtonItem {
   public func updateSoftUIImageView(to newImage: UIImage?, tintColor: UIColor) {
        guard let customView = self.customView as? SoftUIView else {
            return
        }
        let imageView = UIImageView(image: newImage)
        imageView.tintColor = tintColor
        customView.configure(with: SoftUIViewModel(contentView: imageView))

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
    }
}
