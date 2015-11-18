import Foundation
import RxSwift

class WeatherViewModel {
    lazy var disposeBag = DisposeBag()
    
    lazy var searchText = PublishSubject<String?>()
    lazy var cityName = PublishSubject<String?>()
    lazy var degrees = PublishSubject<String?>()
    
    var weather: Weather? {
        didSet {
            if let name = weather?.name {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.cityName.onNext(name)
                })
            }
            
            if let degress = weather?.degress {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.degrees.onNext("\(degress) Fº")
                })
            }
        }
    }
    
    init() {
        let search = searchText
            .map { text in
                WeatherApi.weather(text)
            }
            .switchLatest()
        
        search
            .subscribeNext({ (weather) -> Void in
                self.weather = weather
            })
            .addDisposableTo(self.disposeBag)
    }
}