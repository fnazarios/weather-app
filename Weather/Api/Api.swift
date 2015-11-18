import Foundation
import RxMoya

enum Api {
    case Weather(String?)
}

extension Api : MoyaTarget {
    var baseURL: NSURL {
        return NSURL(string: "http://api.openweathermap.org/data/2.5")!
    }
    
    var path: String {
        switch self {
        case .Weather(_):
            return "/weather"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Weather(_):
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Weather(let city):
            if let city = city {
                return ["q": city, "appid": "2de143494c0b295cca9337e1e96b00e0"]
            }
            
            return ["q": "", "appid": "2de143494c0b295cca9337e1e96b00e0"]
        }
    }
    
    var sampleData: NSData {
        switch self {
        default:
            return NSData()
        }
    }
}