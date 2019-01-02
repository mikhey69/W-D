import UIKit
import GoogleMobileAds

class Dresser: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AAA")
        //load Ad
        bannerView.adUnitID = "ca-app-pub-6849226060302158/9737223213"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}
