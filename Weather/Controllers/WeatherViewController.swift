import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Binding the UI
        bindSourceToLabel(viewModel.cityName, label: cityNameLabel)
        bindSourceToLabel(viewModel.degrees, label: degreesLabel)
        
        nameTextField.rx_text
            .subscribeNext { text in
                self.viewModel.searchText.onNext(text)
            }
            .addDisposableTo(disposeBag)
    }
    
    func bindSourceToLabel(source: PublishSubject<String?>, label: UILabel) {
        source
            .subscribeNext { text in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    label.text = text
                })
            }
            .addDisposableTo(disposeBag)
    }

}
