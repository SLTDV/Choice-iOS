import UIKit

public extension UIViewController {
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func removeUserDidTakeScreenshotNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    func addUserDidTakeScreenshotNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDetchScreenshot),
            name: UIApplication.userDidTakeScreenshotNotification, object: nil
        )
    }
    
    @objc func didDetchScreenshot() {
        let alert = UIAlertController(title: "경고", message: "게시물에 사진을 온/오프라인에 부적절한 용도로 유포할 경우 법적 제재를 받을 수 있습니다.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
}
