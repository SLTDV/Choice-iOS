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
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels,
        ] as [CFString : Any]
        
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error! - \(error)")
            }
            guard let data = data, let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions as CFDictionary) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.sync {
                let downsampledUIImage = UIImage(cgImage: downsampledImage)
                completion(downsampledUIImage)
            }
        }
        
        task.resume()
    }
}
