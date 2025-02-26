//
//  Constant.swift
//  WWImageView
//
//  Created by William.Weng on 2025/2/26.
//

import CoreGraphics

// MARK: - typealias
extension WWImageView {
    
    typealias RGBAInformation = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)   // [RGBA色彩模式的數值](https://stackoverflow.com/questions/28644311/how-to-get-the-rgb-code-int-from-an-uicolor-in-swift)
}

// MARK: - enum
extension WWImageView {
    
    /// 自定義錯誤
    enum CustomError: Error {
    case isNull
    }
    
    /// ColorSpace類型
    enum CGColorSpaceType {
        
        case Gray
        case RGB
        case CMYK
        
        /// 取得其值
        /// - Returns: CGColorSpace
        func value() -> CGColorSpace {
            
            switch self {
            case .Gray: return CGColorSpaceCreateDeviceGray()
            case .RGB: return CGColorSpaceCreateDeviceRGB()
            case .CMYK: return CGColorSpaceCreateDeviceCMYK()
            }
        }
    }
}
