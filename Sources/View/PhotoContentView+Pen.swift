//
//  PhotoContentView+Pen.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

// MARK: - Public function
extension PhotoContentView {
    
    func canvasUndo() {
//        canvas.undo()
        if penImageList.isEmpty { return }
        penImageList.removeLast()
        canvas.lastPenImage.image = penImageList.last
        canvas.reset()
    }
    
    func canvasCanUndo() -> Bool {
//        return canvas.canUndo()
        return !penImageList.isEmpty
    }
}

// MARK: - Internal function
extension PhotoContentView {
    
    func updateCanvasFrame() {
        canvas.frame = CGRect(origin: .zero, size: imageView.bounds.size)
    }
}

// MARK: - CanvasDelegate
extension PhotoContentView: CanvasDelegate {
    
    func canvasDidBeginPen() {
        delegate?.photoDidBeginPen()
    }
    
    func canvasDidEndPen() {
        delegate?.photoDidEndPen()
        
        guard let screenshot = canvas.screenshot else { return }
        print("Pen take screenshot")
        penImageList.append(screenshot)
        canvas.lastPenImage.image = screenshot
        canvas.reset()
    }
}

// MARK: - CanvasDataSource
extension PhotoContentView: CanvasDataSource {
    
    func canvasGetScale(_ canvas: Canvas) -> CGFloat {
        return scrollView.zoomScale
    }
}
