//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2025/2/26.
//

import UIKit
import WWImageView

// MARK: - ViewController
final class ViewController: UIViewController {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var myImageView: WWImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.delegate = self
        myImageView.isUserInteractionEnabled = true
    }
}

// MARK: - WWImageViewDelegate
extension ViewController: WWImageViewDelegate {
    
    func touched(imageView: WWImageView, colorResult: Result<UIColor, Error>) {
        
        switch colorResult {
        case .failure(let error): print(error)
        case .success(let color): colorView.backgroundColor = color
        }
    }
}
