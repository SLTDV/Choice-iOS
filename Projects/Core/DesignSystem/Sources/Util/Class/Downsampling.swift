import UIKit

public enum Downsampling {
    private static let imageCache = NSCache<NSURL, UIImage>()
    
    public static func optimization(
        imageAt imageURL: URL,
        to pointSize: CGSize,
        scale: CGFloat
    ) async throws -> UIImage? {
        // 이미지 캐시 확인
        if let cachedImage = imageCache.object(
            forKey: imageURL as NSURL
        ) {
            return cachedImage
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
        
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil) else {
            return nil
        }
        
        guard let downsampledIamge = CGImageSourceCreateThumbnailAtIndex(
            imageSource,
            0,
            downsampleOptions as CFDictionary
        ) else {
            return nil
        }
        
        let downsampledUIImage = UIImage(
            data: UIImage(cgImage: downsampledIamge).jpegData(compressionQuality: 1)!
        )
        
        imageCache.setObject(
            downsampledUIImage!,
            forKey: imageURL as NSURL
        )
        
        return downsampledUIImage
    }
}
