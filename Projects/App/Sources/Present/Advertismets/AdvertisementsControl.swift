import Foundation
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

protocol AdvertisementsHandlerProtocol {
    var interstitial: GADInterstitialAd? { set get }
    static var shared: AdvertisementsHandlerProtocol { get }
    
    func loadRewardedAd(vc: UIViewController)
}

class AdvertisementsControl: AdvertisementsHandlerProtocol {
    internal var interstitial: GADInterstitialAd?
    static var shared: AdvertisementsHandlerProtocol = AdvertisementsControl()
    
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
        }
    }
    
    func show(vc: UIViewController) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: vc)
        }
    }
}
