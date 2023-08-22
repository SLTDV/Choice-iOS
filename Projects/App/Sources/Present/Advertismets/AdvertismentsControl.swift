import Foundation
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class AdvertismentsControl {
    private var interstitial: GADInterstitialAd? = nil
    private var vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
        loadRewardedAd()
    }
    
    func loadRewardedAd() {
        let request = GADRequest()
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
            nil
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-5088279003431597/9843461422",
                               request: request) { ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.show()
            print("Rewarded ad loaded.")
        }
    }
    
    func show() {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: vc)
        }
    }
}
