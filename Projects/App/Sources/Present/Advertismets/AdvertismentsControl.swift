import Foundation
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class AdvertismentsControl {
    private var interstitial: GADInterstitialAd? = nil
    static var shared = AdvertismentsControl()
    var vc: UIViewController?
    
    func loadRewardedAd(vc: UIViewController) {
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
            self.show(vc: vc)
            print("Rewarded ad loaded.")
        }
    }
    
    func show(vc: UIViewController) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: vc)
        }
    }
}
