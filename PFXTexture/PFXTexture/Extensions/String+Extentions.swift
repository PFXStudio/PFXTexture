import Foundation

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

    static func random(alphabet: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%^&*()!_-", length: Int = 20) -> String {
        let base = alphabet
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    func validString(filter: String = "[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ ]") -> Bool {
        if self.count == 0 { return false }
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
        return list.count == self.count
    }
    
    func validPhoneString(filter: String = "[0-9]") -> Bool {
        if self.count != 11 { return false }
        let regex = try! NSRegularExpression(pattern: filter, options: [])
        let list = regex.matches(in: self, options: [], range: NSRange.init(location: 0, length: self.count))
        return list.count == self.count
    }
    
    func localized(_ comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
