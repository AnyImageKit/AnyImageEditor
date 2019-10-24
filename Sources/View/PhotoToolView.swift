//
//  PhotoToolView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol PhotoToolViewDelegate: class {
    
}

final class PhotoToolView: UIView {
    
    private lazy var topCoverLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let statusBarHeight = StatusBarHelper.height
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: statusBarHeight + 120)
        layer.colors = [
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.06).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor]
        layer.locations = [0, 0.7, 0.85, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    private lazy var bottomCoverLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let height: CGFloat = 100 + (UIDevice.isMordenPhone ? 34 : 0)
        layer.frame = CGRect(x: 0, y: bounds.height-height, width: UIScreen.main.bounds.width, height: height)
        layer.colors = [
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.06).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor]
        layer.locations = [0, 0.7, 0.85, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 1)
        layer.endPoint = CGPoint(x: 0.5, y: 0)
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.addSublayer(topCoverLayer)
        layer.addSublayer(bottomCoverLayer)
    }
}

// MARK: - Public function
extension PhotoToolView {
    
}
