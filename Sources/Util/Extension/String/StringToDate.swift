import Foundation

extension String {
    func getStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.locale = Locale(identifier: "Ko_kr")
        
        return dateFormatter.date(from: self)!
    }
}
