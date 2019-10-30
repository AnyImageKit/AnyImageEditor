//
//  PhotoContentView+Mosaic.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

// MARK: - Public function
extension PhotoContentView {
    
    func setMosaicImage(_ idx: Int) {
        mosaic?.setMosaicCoverImage(idx)
        imageView.image = mosaicImageList.last ?? image
    }
    
    func mosaicUndo() {
        if mosaicImageList.isEmpty { return }
        mosaicImageList.removeLast()
        imageView.image = mosaicImageList.last ?? image
        mosaic?.reset()
    }
    
    func mosaicCanUndo() -> Bool {
        return !mosaicImageList.isEmpty
    }
}

// MARK: - Private function
extension PhotoContentView {
    
    /// 在子线程创建马赛克图片
    internal func setupMosaicView() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let mosaicImage = UIImage.createMosaicImage(from: self.image, level: 20) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("Mosaic created")
                self.mosaic = Mosaic(frame: CGRect(origin: .zero, size: self.imageView.bounds.size), originalMosaicImage: mosaicImage, mosaicOptions: self.config.mosaicOptions)
                self.mosaic?.delegate = self
                self.mosaic?.dataSource = self
                self.mosaic?.isUserInteractionEnabled = false
                self.imageView.insertSubview(self.mosaic!, belowSubview: self.canvas)
                self.delegate?.mosaicDidCreated()
            }
        }
    }
    
    /// 生成截图
    private func getScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, true, UIScreen.main.scale)
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - MosaicDelegate
extension PhotoContentView: MosaicDelegate {
    
    func mosaicDidBeginPen() {
        delegate?.photoDidBeginPen()
    }
    
    func mosaicDidEndPen() {
        delegate?.photoDidEndPen()
        guard let screenshot = getScreenshot() else { return }
        mosaicImageList.append(screenshot)
        imageView.image = screenshot
        mosaic?.reset()
    }
}

// MARK: - MosaicDataSource
extension PhotoContentView: MosaicDataSource {
    
    func mosaicGetScale(_ mosaic: Mosaic) -> CGFloat {
        return scrollView.zoomScale
    }
}
