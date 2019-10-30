//
//  PhotoContentView+Crop.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

// MARK: - Public function
extension PhotoContentView {

    func cropStart() {
        isCrop = true
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutCrop()
        }) { (_) in
            self.setCropHidden(false, animated: true)
        }
    }
    
    func cropCancel() {
        isCrop = false
        setCropHidden(true, animated: false)
        UIView.animate(withDuration: 0.25) {
            self.layout()
        }
    }
    
    func cropDone() {
        isCrop = false
    }
    
    func cropReset() {
        
    }
}

// MARK: - Target
extension PhotoContentView {
    
    
}

// MARK: - Private function
extension PhotoContentView {
    
    internal func cropSetupView() {
        addSubview(topLeftCorner)
        addSubview(topRightCorner)
        addSubview(bottomLeftCorner)
        addSubview(bottomRightCorner)
    }
    
    private func layoutCrop() {
        scrollView.frame = CGRect(x: 15, y: 0, width: bounds.width-30, height: bounds.height)
        scrollView.maximumZoomScale = 15.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
        var cropFrame = cropFrame2
        imageView.frame = cropFrame
        scrollView.contentSize = imageView.bounds.size
        
        cropFrame.origin.x += 15
        setCropRect(cropFrame)
        
        let bottomInset = bounds.height - cropRect.size.height + 1
        scrollView.contentInset = UIEdgeInsets(top: 0.1, left: 0.1, bottom: bottomInset, right: 0.1)
    }
    
    private func setCropRect(_ rect: CGRect) {
        cropRect = rect
        let origin = rect.origin
        let size = rect.size
        topLeftCorner.center = origin
        topRightCorner.center = CGPoint(x: origin.x + size.width, y: origin.y)
        bottomLeftCorner.center = CGPoint(x: origin.x, y: origin.y + size.height)
        bottomRightCorner.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        
        gridLayer?.removeFromSuperlayer()
        gridLayer = CropGridLayer(frame: rect, color: UIColor.white.withAlphaComponent(0.5))
        layer.addSublayer(gridLayer!)
    }
    
    private func setCropHidden(_ hidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.topLeftCorner.alpha = hidden ? 0 : 1
            self.topRightCorner.alpha = hidden ? 0 : 1
            self.bottomLeftCorner.alpha = hidden ? 0 : 1
            self.bottomRightCorner.alpha = hidden ? 0 : 1
            self.gridLayer?.isHidden = hidden
        }
    }
    
    
}
