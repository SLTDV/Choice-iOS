import UIKit

public enum Downsampling {
    public static func optimization(
        imageAt imageURL: URL,
        to pointSize: CGSize,
        scale: CGFloat,
        completion: @escaping (UIImage?) -> Void
    ) {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        var returnImage: UIImage?
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                completion(nil)
                print("Tast Error = \(error)")
                return
            }
            
            guard let data = data, let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
                let downsampleOptions = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceShouldCacheImmediately: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
                ] as [CFString : Any] as CFDictionary
                
                guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
                    completion(nil)
                    return
                }
                
                returnImage = UIImage(cgImage: downsampledImage)
                completion(returnImage)
            }
        }.resume()
    }
}
