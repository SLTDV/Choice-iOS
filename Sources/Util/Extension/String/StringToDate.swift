import Foundation

extension String {
    func getStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        formatter.locale = Locale(identifier: "kr")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter.date(from: self)!
    }
}
