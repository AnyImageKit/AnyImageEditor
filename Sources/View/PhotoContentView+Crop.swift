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

    /// 开始裁剪
    func cropStart() {
        isCrop = true
        cropLayer.removeFromSuperlayer()
        UIView.animate(withDuration: 0.25, animations: {
            if !self.didCrop {
                self.layoutStartCrop()
            } else {
                self.layoutStartCroped()
            }
        }) { (_) in
            self.setCropHidden(false, animated: true)
        }
    }
    
    /// 取消裁剪
    func cropCancel() {
        isCrop = false
        setCropHidden(true, animated: false)
        if didCrop {
            scrollView.zoomScale = lastCropData.zoomScale
            scrollView.contentSize = lastCropData.contentSize
            imageView.frame = lastCropData.imageViewFrame
            scrollView.contentOffset = lastCropData.contentOffset
            setCropRect(lastCropData.rect, animated: true)
        }
        UIView.animate(withDuration: 0.25) {
            if self.didCrop {
                self.layouEndCrop()
            } else {
                self.layout()
            }
        }
    }
    
    /// 裁剪完成
    func cropDone() {
        isCrop = false
        didCrop = cropRect.size != scrollView.contentSize
        setCropHidden(true, animated: false)
        layouEndCrop()
    }
    
    /// 重置裁剪
    func cropReset() {
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutStartCrop(animated: true)
        })
    }
}

// MARK: - Target
extension PhotoContentView {
    
    /// 白色裁剪框4个角的pan手势
    @objc func panCropCorner(_ gr: UIPanGestureRecognizer) {
        guard let cornerView = gr.view as? CropCornerView else { return }
        let position = cornerView.position
        let moveP = gr.translation(in: self)
        gr.setTranslation(.zero, in: self)
        
        if gr.state == .began {
            cropStartPanRect = cropRect
        }
        
        updateCropRect(moveP, position)
        
        if gr.state == .ended {
            updateScrollViewAndCropRect(position)
        }
    }
    
}

// MARK: - Private function
extension PhotoContentView {
    
    /// 设置裁剪相关控件
    internal func cropSetupView() {
        addSubview(gridView)
        addSubview(topLeftCorner)
        addSubview(topRightCorner)
        addSubview(bottomLeftCorner)
        addSubview(bottomRightCorner)
    }
    
    /// 布局开始裁剪 - 未裁剪过
    private func layoutStartCrop(animated: Bool = false) {
        let top = cropY
        let bottom = cropBottomOffset
        scrollView.frame = CGRect(x: cropX, y: top, width: bounds.width-cropX*2, height: bounds.height-top-bottom)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = cropMaximumZoomScale
        scrollView.zoomScale = 1.0
        
        var cropFrame = self.cropFrame
        imageView.frame = cropFrame
        imageView.frame.origin.y -= top
        scrollView.contentSize = imageView.bounds.size
        
        cropFrame.origin.x += scrollView.frame.origin.x
        setCropRect(cropFrame, animated: animated)
        
        setupContentInset()
    }
    
    /// 布局开始裁剪 - 已裁剪过
    private func layoutStartCroped() {
        let top = cropY
        let bottom = cropBottomOffset
        scrollView.frame = CGRect(x: cropX, y: top, width: bounds.width-cropX*2, height: bounds.height-top-bottom)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = cropMaximumZoomScale
  
        scrollView.zoomScale = lastCropData.zoomScale
        scrollView.contentSize = lastCropData.contentSize
        imageView.frame = lastCropData.imageViewFrame
        scrollView.contentOffset = lastCropData.contentOffset
        setCropRect(lastCropData.rect, animated: true)
        
        setupContentInset()
    }
    
    /// 布局裁剪结束
    private func layouEndCrop() {
        lastCropData.rect = cropRect
        lastCropData.zoomScale = scrollView.zoomScale
        lastCropData.contentSize = scrollView.contentSize
        lastCropData.contentOffset = scrollView.contentOffset
        lastCropData.imageViewFrame = imageView.frame
        
        let contentOffset = scrollView.contentOffset
        var contentSize: CGSize = .zero
        contentSize.width = bounds.width
        contentSize.height = bounds.width * cropRect.height / cropRect.width
        
        var imageSize: CGSize = .zero
        imageSize.width = bounds.width * (imageView.bounds.width * scrollView.zoomScale) / cropRect.width
        imageSize.height = contentSize.height * (imageView.bounds.height * scrollView.zoomScale) / cropRect.height
        
        let x = (bounds.width - contentSize.width) > 0 ? (bounds.width - contentSize.width) * 0.5 : 0
        let y = (bounds.height - contentSize.height) > 0 ? (bounds.height - contentSize.height) * 0.5 : 0
        let offsetX = contentOffset.x * imageSize.width / (imageView.bounds.width * scrollView.zoomScale)
        let offsetY = contentOffset.y * imageSize.height / (imageView.bounds.height * scrollView.zoomScale)
        
        // Set
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.frame = self.bounds
            self.scrollView.minimumZoomScale = self.scrollView.zoomScale
            self.scrollView.maximumZoomScale = self.scrollView.zoomScale
            self.scrollView.contentInset = .zero
            
            self.imageView.frame.origin = CGPoint(x: x - offsetX, y: y - offsetY)
            self.imageView.frame.size = imageSize
            self.scrollView.contentSize = contentSize
        })
        
        // CropLayer
        layer.addSublayer(cropLayer)
        let cropPath = UIBezierPath(rect: bounds)
        let rectPath = UIBezierPath(rect: cropRect)
        cropPath.append(rectPath)
        cropLayer.path = cropPath.cgPath
        
        let newCropPath = UIBezierPath(rect: bounds)
        let newRectPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: x, y: y), size: contentSize))
        newCropPath.append(newRectPath)
        let cropAnimation = CABasicAnimation.create(duration: 0.3, fromValue: cropLayer.path, toValue: newCropPath.cgPath)
        cropLayer.add(cropAnimation, forKey: "path")
        cropLayer.path = newCropPath.cgPath
    }
    
    /// 设置白色裁剪框的frame
    private func setCropRect(_ rect: CGRect, animated: Bool = false) {
        cropRect = rect
        let origin = rect.origin
        let size = rect.size
        topLeftCorner.center = origin
        topRightCorner.center = CGPoint(x: origin.x + size.width, y: origin.y)
        bottomLeftCorner.center = CGPoint(x: origin.x, y: origin.y + size.height)
        bottomRightCorner.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
        gridView.setRect(rect, animated: animated)
    }
    
    /// 显示/隐藏白色裁剪框
    private func setCropHidden(_ hidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.gridView.alpha = hidden ? 0 : 1
            self.topLeftCorner.alpha = hidden ? 0 : 1
            self.topRightCorner.alpha = hidden ? 0 : 1
            self.bottomLeftCorner.alpha = hidden ? 0 : 1
            self.bottomRightCorner.alpha = hidden ? 0 : 1
        }
    }
    
    /// 设置contentInset
    private func setupContentInset() {
        let rightInset = scrollView.bounds.width - cropRect.width + 0.1
        let bottomInset = scrollView.bounds.height - cropRect.height + 0.1
        scrollView.contentInset = UIEdgeInsets(top: 0.1, left: 0.1, bottom: bottomInset, right: rightInset)
    }
    
    // MARK: - Calculate
    /// pan手势移动中，计算新的裁剪框的位置
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
    
    /// pan手势移动结束，根据裁剪框位置，计算scrollView的zoomScale、minimumZoomScale、contentOffset，以及新的裁剪框的位置
    private func updateScrollViewAndCropRect(_ position: CropCornerPosition) {
        // zoomScale
        let maxZoom = scrollView.maximumZoomScale
        let zoom1 = scrollView.bounds.width / (cropRect.width / scrollView.zoomScale)
        let zoom2 = scrollView.bounds.height / (cropRect.height / scrollView.zoomScale)
        let isVertical = cropRect.height * (scrollView.bounds.width / cropRect.width) > scrollView.bounds.height
        let zoom: CGFloat
        if !isVertical {
            zoom = zoom1 > maxZoom ? maxZoom : zoom1
        } else {
            zoom = zoom2 > maxZoom ? maxZoom : zoom2
        }
        
        // contentOffset
        let zoomScale = zoom / scrollView.zoomScale
        let offsetX = (scrollView.contentOffset.x * zoomScale) + ((cropRect.origin.x - cropStartPanRect.origin.x) * zoomScale)
        let offsetY = (scrollView.contentOffset.y * zoomScale) + ((cropRect.origin.y - cropStartPanRect.origin.y) * zoomScale)
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
        
        // minimumZoomScale
        let mZoom1 = scrollView.bounds.width / imageView.bounds.width
        let mZoom2 = scrollView.bounds.height / imageView.bounds.height
        let mZoom: CGFloat
        if !isVertical {
            mZoom = (imageView.bounds.height < newCropRect.height) ? (newCropRect.height / imageView.bounds.height) : mZoom1
        } else {
            mZoom = (imageView.bounds.width < newCropRect.width) ? (newCropRect.width / imageView.bounds.width) : mZoom2
        }
        
        // set
        UIView.animate(withDuration: 0.5, animations: {
            self.setCropRect(newCropRect, animated: true)
            self.imageView.frame.origin.x = newCropRect.origin.x - self.scrollView.frame.origin.x
            self.imageView.frame.origin.y = newCropRect.origin.y - self.scrollView.frame.origin.y
            self.scrollView.zoomScale = zoom
            self.scrollView.contentOffset = offset
        })
        
        // set
        setupContentInset()
        scrollView.minimumZoomScale = mZoom
    }
}
