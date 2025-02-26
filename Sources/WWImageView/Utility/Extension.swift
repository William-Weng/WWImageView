//
//  Extension.swift
//  WWImageView
//
//  Created by William.Weng on 2025/2/26.
//

import UIKit

// MARK: - CGPoint (function)
extension CGPoint {
        
    /// 將點擊座標 => 圖片座標 (圖片原始大小)
    /// - Parameter image: UIImage
    /// - Returns: CGPoint
    func _imagePoint(with imageView: UIImageView) -> CGPoint? {
        
        guard let image = imageView.image else { return nil }
        
        let imagePoint = CGPoint(
            x: x * image.size.width / imageView.frame.size.width,
            y: y * image.size.height / imageView.frame.size.height
        )
        
        return imagePoint
    }
    
    /// 將UIKit坐標系 - 左上(0, 0) => 轉成CoreGraphics坐標系 - 右下(0, 0)
    /// - Parameter size: CGSize
    /// - Returns: CGPoint
    func _convertToCGCoordinate(size: CGSize) -> CGPoint {
        return CGPoint(x: -x, y: y - size.height)
    }
}

// MARK: - CGContext (static function)
extension CGContext {
    
    /// 建立Context
    /// - Parameters:
    ///   - info: UInt32
    ///   - size: CGSize
    ///   - pixelData: UnsafeMutableRawPointer?
    ///   - bitsPerComponent: Int
    ///   - bytesPerRow: Int
    ///   - colorSpace: CGColorSpace
    /// - Returns: CGContext?
    static func _build(with info: UInt32, size: CGSize, pixelData: UnsafeMutableRawPointer?, bitsPerComponent: Int, bytesPerRow: Int, colorSpace: CGColorSpace) -> CGContext? {
        let context = CGContext(data: pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: info)
        return context
    }
    
    /// 建立Context
    /// - Parameters:
    ///   - info: UInt32
    ///   - size: CGSize
    ///   - pixelData: UnsafeMutableRawPointer?
    ///   - bitsPerComponent: Int
    ///   - bytesPerRow: Int
    ///   - colorSpaceType: CGColorSpace
    /// - Returns: CGContext?
    static func _build(with info: UInt32, size: CGSize, pixelData: UnsafeMutableRawPointer?, bitsPerComponent: Int, bytesPerRow: Int, colorSpaceType: WWImageView.CGColorSpaceType) -> CGContext? {
        return Self._build(with: info, size: size, pixelData: pixelData, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, colorSpace: colorSpaceType.value())
    }
}

// MARK: - CGContext (function)
extension CGContext {
    
    /// 坐標轉換
    /// - Parameter point: CGPoint
    func _translate(by point: CGPoint) {
        translateBy(x: point.x, y: point.y)
    }
}

// MARK: - UIColor (function)
extension UIColor {
    
    /// Data => RGBAInformation
    /// - Parameter bytes: Data
    /// - Returns: WWImageView.RGBAInformation?
    static func _colorInfo(with bytes: UnsafePointer<UInt8>) -> WWImageView.RGBAInformation? {
        
        let red = CGFloat(bytes[0]) / 255
        let green = CGFloat(bytes[1]) / 255
        let blue = CGFloat(bytes[2]) / 255
        let alpha = CGFloat(bytes[3]) / 255
        
        return (red, green, blue, alpha)
    }
    
    /// Data => UIColor
    /// - Parameter bytes: Data
    /// - Returns: UIColor?
    static func _convertColor(with bytes: UnsafePointer<UInt8>) -> UIColor? {
        guard let info = Self._colorInfo(with: bytes) else { return nil }
        return UIColor(red: info.red, green: info.green, blue: info.blue, alpha: info.alpha)
    }
}

// MARK: - UIImage (function)
extension UIImage {
    
    /// 取得該位置上的圖片顏色
    /// - Parameter imagePoint: CGPoint
    /// - Returns: UIColor?
    func _color(imagePoint: CGPoint?) -> Result<UIColor, Error> {
        
        guard let cgImage = cgImage,
              let imagePoint = imagePoint
        else {
            return .failure(WWImageView.CustomError.isNull)
        }
        
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let bytesPerRow = 4
        let cgPoint = imagePoint._convertToCGCoordinate(size: size)
        
        var pixelData = [UInt8](repeating: 0, count: bytesPerRow)
        
        guard let context = CGContext._build(with: bitmapInfo, size: .init(width: 1, height: 1), pixelData: &pixelData, bitsPerComponent: 8, bytesPerRow: bytesPerRow, colorSpaceType: .RGB) else { return  .failure(WWImageView.CustomError.isNull) }
        
        context.setBlendMode(.copy)
        context._translate(by: cgPoint)
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        guard let color = UIColor._convertColor(with: &pixelData) else { return .failure(WWImageView.CustomError.isNull) }
        return .success(color)
    }
}

// MARK: - UIImageView (function)
extension UIImageView {
    
    /// 取得點擊圖片上的顏色 (.scaleAspectFill)
    /// - Parameter touches: Set<UITouch>
    /// - Returns: UIColor?
    func _color(with touches: Set<UITouch>) -> Result<UIColor, Error> {
        return _color(point: touches.first?.location(in: self))
    }
    
    /// 取得該位置圖片上的顏色 (比照原圖 / 擷圖當底圖)
    /// - Parameter point: CGPoint
    /// - Returns: UIColor?
    func _color(point: CGPoint?) -> Result<UIColor, Error> {
        
        guard let point = point,
              let imagePoint = point._imagePoint(with: self),
              let screenshot = Optional.some(_screenshot())
        else {
            return .failure(WWImageView.CustomError.isNull)
        }
        
        self.image = screenshot
        return screenshot._color(imagePoint: imagePoint)
    }
    
    /// [擷取UIView的畫面](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-uigraphicsimagerenderer-將-view-變成圖片-41d00c568903)
    /// - Parameter afterScreenUpdates: 更新後才擷取嗎？
    /// - Returns: UIImage
    func _screenshot(afterScreenUpdates: Bool = true) -> UIImage {
        
        let render = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = render.image { (_) in drawHierarchy(in: self.bounds, afterScreenUpdates: afterScreenUpdates) }
        
        return image
    }
}
