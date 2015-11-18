import Quick
import Nimble
import RxSwift
import Argo
@testable import Weather

class WeatherSpec: QuickSpec {
    lazy var disposeBag = DisposeBag()
    
    override func spec() {
        fdescribe("Weather") {
            fcontext("parse weather") {
                var weather: Weather?
                let jsonText = "{\"coord\":{\"lon\":-0.13,\"lat\":51.51},\"weather\":[{\"id\":802,\"main\":\"Clouds\",\"description\":\"scattered clouds\",\"icon\":\"03d\"}],\"base\":\"cmc stations\",\"main\":{\"temp\":286.391,\"pressure\":1013.81,\"humidity\":80,\"temp_min\":286.391,\"temp_max\":286.391,\"sea_level\":1023.71,\"grnd_level\":1013.81},\"wind\":{\"speed\":9.42,\"deg\":227.501},\"clouds\":{\"all\":48},\"dt\":1447852426,\"sys\":{\"message\":0.0027,\"country\":\"GB\",\"sunrise\":1447831434,\"sunset\":1447862820},\"id\":2643743,\"name\":\"London\",\"cod\":200}"
                    .dataUsingEncoding(NSUTF8StringEncoding)!
                let json = try? NSJSONSerialization.JSONObjectWithData(jsonText, options: .AllowFragments)
                if let j = json {
                    weather = decode(j)
                }
                
                fit("weather should not be nil") {
                    expect(weather).toNot(beNil())
                }
                
                fit("weather name should be eq \"London\"") {
                    expect(weather?.name).to(equal("London"))
                }
                
                fit("temp should be eq 286.391") {
                    expect(weather?.degress).to(equal(286.391))
                }
            }
        }
    }
}
