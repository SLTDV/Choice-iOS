import Foundation

extension Encodable {
  func toDictionary() -> [String: Any] {
    do {
      let encodedData = try JSONEncoder().encode(self)
        
      let dictionaryData = try JSONSerialization.jsonObject(
        with: encodedData,
        options: .allowFragments
      ) as? [String: Any]
      return dictionaryData ?? [:]
    } catch {
      return [:]
    }
  }
}
