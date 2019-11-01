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
    
    @objc func panCropCorner(_ gr: UIPanGestureRecognizer) {
        guard let cornerView = gr.view as? CropCornerView else { return }
        let position = cornerView.position
        let moveP = gr.translation(in: self)
        gr.setTranslation(.zero, in: self)
        
        if gr.state == .began {
            cropStartRect = cropRect
        }
        
        updateCropRect(moveP, position)
        
        if gr.state == .ended {
            updateScrollViewAndCropRect(position)
        }
    }
    
}

// MARK: - Private function
extension PhotoContentView {
    
    internal func cropSetupView() {
//        layer.addSublayer(gridLayer)
        addSubview(topLeftCorner)
        addSubview(topRightCorner)
        addSubview(bottomLeftCorner)
        addSubview(bottomRightCorner)
    }
    
    private func layoutCrop() {
        let y = 15 + topMargin
        let bottom = 65 + bottomMargin + 50
        scrollView.frame = CGRect(x: 15, y: y, width: bounds.width-30, height: bounds.height-y-bottom)
        scrollView.maximumZoomScale = 15.0
        scrollView.minimumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
        var cropFrame = cropFrame2
        imageView.frame = cropFrame
        imageView.frame.origin.y -= y
        scrollView.contentSize = imageView.bounds.size
        
        cropFrame.origin.x += 15
        setCropRect(cropFrame)
        
        let rightInset = scrollView.bounds.width - cropRect.width + 0.1
        let bottomInset = scrollView.bounds.height - cropRect.height + 0.1
        scrollView.contentInset = UIEdgeInsets(top: 0.1, left: 0.1, bottom: bottomInset, right: rightInset)
    }
    
    private func setCropRect(_ rect: CGRect) {
        cropRect = rect
        let origin = rect.origin
        let size = rect.size
        topLeftCorner.center = origin
        topRightCorner.center = CGPoint(x: origin.x + size.width, y: origin.y)
        bottomLeftCorner.center = CGPoint(x: origin.x, y: origin.y + size.height)
        bottomRightCorner.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
//        gridLayer.frame = rect
//        gridLayer.reload(rect)
    }
    
    private func setCropHidden(_ hidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.topLeftCorner.alpha = hidden ? 0 : 1
            self.topRightCorner.alpha = hidden ? 0 : 1
            self.bottomLeftCorner.alpha = hidden ? 0 : 1
            self.bottomRightCorner.alpha = hidden ? 0 : 1
            self.gridLayer.isHidden = hidden
        }
    }
    
    private func updateCropRect(_ moveP: CGPoint, _ position: CropCornerPosition) {
        let limit: CGFloat = 55
        var rect = cropRect
        let isXUp = rect.size.width - moveP.x > limit && rect.origin.x + moveP.x > imageView.frame.origin.x + scrollView.frame.origin.x - scrollView.contentOffset.x
        let isXDown = rect.size.width + moveP.x > limit && rect.size.width + moveP.x < imageView.frame.size.width - scrollView.contentOffset.x
        let isYUp = rect.size.height - moveP.y > limit && rect.origin.y + moveP.y > imageView.frame.origin.y + scrollView.frame.origin.y - scrollView.contentOffset.y
        let isYDown = rect.size.height + moveP.y > limit && rect.size.height + moveP.y < imageView.frame.size.height - scrollView.contentOffset.y
        switch position {
        case .topLeft: // x+ y+
            if isXUp {
                rect.origin.x += moveP.x
                rect.size.width -= moveP.x
            }
            if isYUp  {
                rect.origin.y += moveP.y
                rect.size.height -= moveP.y
            }
        case .topRight: // x- y+
            if isXDown {
                rect.size.width += moveP.x
            }
            if isYUp {
                rect.origin.y += moveP.y
                rect.size.height -= moveP.y
            }
        case .bottomLeft: // x+ y-
            if isXUp {
                rect.origin.x += moveP.x
                rect.size.width -= moveP.x
            }
            if isYDown {
                rect.size.height += moveP.y
            }
        case .bottomRight:// x- y-
            if isXDown {
                rect.size.width += moveP.x
            }
            if isYDown {
                rect.size.height += moveP.y
            }
        }
        setCropRect(rect)
    }
    
    private func updateScrollViewAndCropRect(_ position: CropCornerPosition) {
        // zoom
        let maxZoom = scrollView.maximumZoomScale
        let zoom1 = imageView.bounds.width / (cropRect.width / scrollView.zoomScale)
        let zoom2 = scrollView.bounds.height / (cropRect.height / scrollView.zoomScale)
        let isVertical = cropRect.height * (scrollView.bounds.width / cropRect.width) > scrollView.bounds.height
        let zoom: CGFloat
        if !isVertical {
            zoom = zoom1 > maxZoom ? maxZoom : zoom1
        } else {
            zoom = zoom2 > maxZoom ? maxZoom : zoom2
        }
        
        // offset
        let zoomScale = zoom / scrollView.zoomScale
        let offsetX = (scrollView.contentOffset.x * zoomScale) + ((cropRect.origin.x - 15) * zoomScale)
        let offsetY = (scrollView.contentOffset.y * zoomScale) + ((cropRect.origin.y - cropStartRect.origin.y) * zoomScale)
        let offset: CGPoint
        switch position {
        case .topLeft:
            offset = CGPoint(x: offsetX, y: offsetY)
        case .topRight:
            offset = CGPoint(x: scrollView.contentOffset.x * zoomScale, y: offsetY)
        case .bottomLeft:
            offset = CGPoint(x: offsetX, y: scrollView.contentOffset.y * zoomScale)
        case .bottomRight:
            offset = CGPoint(x: scrollView.contentOffset.x * zoomScale, y: scrollView.contentOffset.y * zoomScale)
        }
        
        // newCropRect
        let newCropRect: CGRect
        if (zoom == maxZoom && !isVertical) || zoom == zoom1 {
            let scale = scrollView.bounds.width / cropRect.width
            let height = cropRect.height * scale
            let y = (scrollView.bounds.height - height) / 2 + scrollView.frame.origin.y
            newCropRect = CGRect(x: scrollView.frame.origin.x, y: y, width: scrollView.bounds.width, height: height)
        } else {
            let scale = scrollView.bounds.height / cropRect.height
            let width = cropRect.width * scale
            let x = (scrollView.bounds.width - width + scrollView.frame.origin.x) / 2
            newCropRect = CGRect(x: x, y: scrollView.frame.origin.y, width: width, height: scrollView.frame.height)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.setCropRect(newCropRect)
            self.imageView.frame.origin.x = newCropRect.origin.x - self.scrollView.frame.origin.x
            self.imageView.frame.origin.y = newCropRect.origin.y - self.scrollView.frame.origin.y
            self.scrollView.zoomScale = zoom
            self.scrollView.contentOffset = offset
        })
        
        // contentInset
        let rightInset = scrollView.bounds.width - cropRect.width + 0.1
        let bottomInset = scrollView.bounds.height - cropRect.height + 0.1
        scrollView.contentInset = UIEdgeInsets(top: 0.1, left: 0.1, bottom: bottomInset, right: rightInset)
    }
}
