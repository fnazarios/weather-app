import Foundation
import RxSwift
import Argo
import RxMoya

func url(route: MoyaTarget) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

func endpointsClosure() -> (Api) -> Endpoint<Api> {
    return { (target: Api) -> Endpoint<Api> in
        let parameterEncoding: Moya.ParameterEncoding = (target.method == .POST) ? .JSON : .URL
        return Endpoint<Api>(URL: url(target), sampleResponseClosure: { () -> EndpointSampleResponse in
            return EndpointSampleResponse.NetworkResponse(200, target.sampleData)
            }, method: target.method, parameters: target.parameters, parameterEncoding: parameterEncoding)
    }
}

enum ApiError: ErrorType {
    case FailureRequest(Int)
    case FailureMapToDomain(ErrorType)
    case FailureMapToJson()
}

extension ObservableType where E: MoyaResponse {

    func successfulStatusCodes() -> Observable<E> {
        return statusCodes(200...299)
    }
    
    func statusCodes(range: ClosedInterval<Int>) -> Observable<E> {
        return flatMap { response -> Observable<E> in
            guard range.contains(response.statusCode) else {
                throw ApiError.FailureRequest(response.statusCode)
            }
            
            return just(response)
        }
    }
    
    func mapToDomain<T: Decodable where T == T.DecodedType>() -> Observable<T> {
        return map { response -> T in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                let decoded: Decoded<T> = decode(json)
                return try self.assertDecoded(decoded, json: json)
            } catch {
                throw error
            }
        }
    }

    func assertDecoded<T>(decoded: Decoded<T>, json: AnyObject) throws -> T {
        switch decoded {
        case .Success(let value):
            return value
        case .Failure(let err):
            throw ApiError.FailureMapToDomain(err)
        }
    }
    
}