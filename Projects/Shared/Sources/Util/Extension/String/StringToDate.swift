import Foundation

public extension String {
    func getStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'T' HH:mm:ss"
        formatter.locale = .current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter.date(from: self)!
    }
}
