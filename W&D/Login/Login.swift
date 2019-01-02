import UIKit

class Login: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        DispatchQueue.global(qos: .userInteractive).async {
            GetWeather.shared.getWeather(forCity: "Kiev")
            GetWeather.shared.getWeather(forCity: "Lviv")
        }
    }
}

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
