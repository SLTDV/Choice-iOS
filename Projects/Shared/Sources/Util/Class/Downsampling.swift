import UIKit

public enum Downsampling {
    public static func optimization(
        imageAt imageURL: URL,
        to pointSize: CGSize,
        scale: CGFloat,
        completion: @escaping (UIImage?) -> Void
    ) {
        DispatchQueue.global().async {
            let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
            
            let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
            ] as [CFString : Any] as CFDictionary
            
            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                let returnImage = UIImage(cgImage: downsampledImage)
                print("return = \(returnImage)")
                completion(returnImage)
            }
        }
    }
}
