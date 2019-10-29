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
        canvas.undo()
    }
    
    func canvasCanUndo() -> Bool {
        return canvas.canUndo()
    }
}

// MARK: - CanvasDelegate
extension PhotoContentView: CanvasDelegate {
    
    func canvasDidBeginPen() {
        delegate?.photoDidBeginPen()
    }
    
    func canvasDidEndPen() {
        delegate?.photoDidEndPen()
    }
}

// MARK: - CanvasDataSource
extension PhotoContentView: CanvasDataSource {
    
    func canvasGetScale(_ canvas: Canvas) -> CGFloat {
        return scrollView.zoomScale
    }
}
