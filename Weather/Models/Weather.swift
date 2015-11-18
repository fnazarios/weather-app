import Foundation
import Argo
import Curry

struct Weather {
    let name: String?
    let degress: Double?
}

extension Weather: Decodable {
    static func decode(j: JSON) -> Decoded<Weather> {
        return curry(Weather.init)
            <^> j <|? "name"
            <*> j <|? ["main", "temp"]
    }
}