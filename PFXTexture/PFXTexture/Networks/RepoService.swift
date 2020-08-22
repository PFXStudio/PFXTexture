import Foundation
import RxSwift
import RxCocoa

enum GithubParam {
    case since(Int?)
    
    var key: String {
        switch self {
        case .since: return "since"
        }
    }
    
    var value: Any? {
        switch self {
        case .since(let value): return value
        }
    }
}

protocol GithubProtocol {
    func loadRepository(params: [GithubParam]?) -> Single<[RepositoryModel]>
}

class GithubService: GithubProtocol {
    func loadRepository(params: [GithubParam]?) -> Single<[RepositoryModel]> {
        return Network.shared.get(url: Route.basePath.path,
                                  params: Route.parameters(params)).generateArrayModel()
    }
    
    enum Route {
        case basePath
        
        var path: String {
            let base = "https://api.github.com/repositories"
            
            switch self {
            case .basePath: return base
            }
        }
        static func parameters(_ params: [GithubParam]?) -> [String: Any]? {
            guard let `params` = params else { return nil }
            var result: [String: Any] = [:]
            
            for param in params {
                result[param.key] = param.value
            }
            
            return result.isEmpty ? nil: result
        }
    }
}
