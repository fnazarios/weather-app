import Foundation
import RxMoya
import RxSwift
import Argo

class WeatherApi {
    
    static var provider = RxMoyaProvider<Api>(endpointClosure: endpointsClosure())
    
    class func weather(city: String?) -> Observable<Weather> {
        return provider.request(.Weather(city))
            .successfulStatusCodes()
            .mapToDomain()
    }
}
