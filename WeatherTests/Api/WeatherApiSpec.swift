import Quick
import Nimble
import RxSwift
import Argo
@testable import Weather

class WeatherApiSpec: QuickSpec {
    lazy var disposeBag = DisposeBag()
    
    override func spec() {
        fdescribe("WeatherApi") {
            fcontext("get weather") {
                var weather: Weather?
                
                beforeEach {
                    WeatherApi.weather("London")
                        .subscribe({ (event) -> Void in
                            switch event {
                            case .Next(let response):
                                weather = response
                            case .Error(let err):
                                debugPrint(err)
                            default: break
                            }
                        })
                        .addDisposableTo(self.disposeBag)
                }
                
                fit("weather should not be nil") {
                    expect(weather).toEventuallyNot(beNil(), timeout: 10)
                }
                
                fit("weather name should be eq \"London\"") {
                    expect(weather?.name).toEventually(equal("London"), timeout: 10)
                }
            }
        }
    }
}
