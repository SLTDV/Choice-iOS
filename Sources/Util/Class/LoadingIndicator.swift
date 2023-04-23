import UIKit

final class LoadingIndicator {
    private init() {}
    static func showLoading(text: String) {
        DispatchQueue.main.async {
            guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last else { return }
            let loadingIndicatorView: UIActivityIndicatorView
            let loadingLabel = UILabel()
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.color = .black
                loadingIndicatorView.frame = window.frame
                loadingLabel.frame = window.frame.offsetBy(dx: window.center.x - 23, dy: 40)
                loadingLabel.text = text
                window.addSubviews(loadingIndicatorView, loadingLabel)
            }
            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
            window.subviews.filter({ $0 is UILabel }).forEach { $0.removeFromSuperview() }
        }
    }
}
