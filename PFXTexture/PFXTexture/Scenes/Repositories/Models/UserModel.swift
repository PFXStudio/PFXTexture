import Foundation

class UserModel: Decodable {
    var username: String = ""
    var profileURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case profileURL = "avatar_url"
    }
    
    func merge(_ user: UserModel?) {
        guard let user = user else { return }
        self.username = user.username
        self.profileURL = user.profileURL
    }
}
