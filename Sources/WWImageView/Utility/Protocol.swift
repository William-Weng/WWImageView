//
//  Protocol.swift
//  WWImageView
//
//  Created by William.Weng on 2025/2/26.
//

import UIKit

// MARK: - WWImageViewDelegate
public protocol WWImageViewDelegate: AnyObject {
    
    /// 取得點到的畫面顏色
    /// - Parameters:
    ///   - imageView: WWImageView
    ///   - colorResult: Result<UIColor, Error>
    ///   - touches: Set<UITouch>
    ///   - event: UIEvent?
    func touched(imageView: WWImageView, colorResult: Result<UIColor, Error>, touches: Set<UITouch>, event: UIEvent?)
}
