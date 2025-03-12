//
//  WWImageView.swift
//  WWImageView
//
//  Created by William.Weng on 2025/2/26.
//

import UIKit

// MARK: - 將UIImageView加上一些功能
open class WWImageView: UIImageView {
    
    public weak var delegate: WWImageViewDelegate?
    
    private var originalImage: UIImage?
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchesBeganAction(touches, with: event)
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - 公開函式
public extension WWImageView {
    
    /// 取得該點的顏色值
    /// - Parameter point: CGPoint
    /// - Returns: Result<UIColor, Error>
    func color(with point: CGPoint) -> Result<UIColor, Error> {
        
        defer { image = originalImage }
        originalImage = image
        
        return _color(point: point)
    }
}

// MARK: - 小工具
private extension WWImageView {
    
    /// 點下去的處理
    /// - Parameters:
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func touchesBeganAction(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let delegate = delegate {
            
            defer { image = originalImage }
            originalImage = image
            
            delegate.touched(imageView: self, colorResult: self._color(with: touches), touches: touches, event: event)
        }
    }
}
