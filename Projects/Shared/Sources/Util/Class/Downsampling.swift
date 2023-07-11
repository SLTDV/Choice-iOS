import UIKit

public enum Downsampling {
    public static func optimization(
        imageAt imageURL: URL,
        to pointSize: CGSize,
        scale: CGFloat,
        completion: @escaping (UIImage?) -> Void
    ) {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ]
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            DispatchQueue.global().async {
                if let error = error {
                    print("Error! - \(error)")
                }
                
                let imageSource = CGImageSourceCreateWithData(data! as CFData, imageSourceOptions)
                guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource!, 0, downsampleOptions as CFDictionary) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(UIImage(cgImage: downsampledImage))
                }
            }
        }.resume()
    }
}
