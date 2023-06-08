import UIKit

final class AddContentsViewModel: BaseViewModel {
    func pushAddImageVC(title: String, content: String) {
        self.coordinator.navigate(to: .addImageIsRequired(title: title, content: content))
    }
}
