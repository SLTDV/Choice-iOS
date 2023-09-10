import UIKit

public enum Downsampling {
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    public static func optimization(
        imageAt imageURL: URL,
        to pointSize: CGSize,
        scale: CGFloat,
        completion: @escaping (UIImage?) -> Void
    ) {
        // 이미지 캐시 확인
        DispatchQueue.global(qos: .userInteractive).async {
            if let cachedImage = imageCache.object(
                forKey: imageURL as NSURL
            ) {
                DispatchQueue.main.async {
                    completion(cachedImage)
                }
                return
            }
            
            let maxDimensionInPixels = max(
                pointSize.width,
                pointSize.height
            ) * scale
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: false,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels,
            ] as [CFString : Any] as CFDictionary
            
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error! - \(error)")
                }
                
                guard let data = data,
                      let imageSource = CGImageSourceCreateWithData(
                        data as CFData, nil
                      ) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(
                    imageSource,
                    0,
                    downsampleOptions as CFDictionary
                ) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                let downsampledUIImage = UIImage(data: UIImage(
                    cgImage: downsampledImage
                ).jpegData(compressionQuality: 0.7)!)
                
                imageCache.setObject(
                    downsampledUIImage!,
                    forKey: imageURL as NSURL
                )
                
                DispatchQueue.main.async {
                    completion(downsampledUIImage)
                }
            }.resume()
        }
    }
}
