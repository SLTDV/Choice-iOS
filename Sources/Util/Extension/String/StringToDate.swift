import Foundation

extension String {
    func getStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "Ko_Kr")
        
        print(self)
        print(formatter.date(from: self))
        return formatter.date(from: self)!
    }
}
