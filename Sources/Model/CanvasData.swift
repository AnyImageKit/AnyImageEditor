//
//  CanvasData.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CanvasDataElement {
    var layerList: [CAShapeLayer] = []
}

final class CanvasData {
    
    var elements: [CanvasDataElement] = []
    var currentElement: CanvasDataElement = CanvasDataElement()
    
}

// MARK: - Public function
extension CanvasData {
    
    func layer(of points: [CGPoint], brush: Brush, scale: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath.create(with: points)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineWidth = 5.0 / scale
        // Brush
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = brush.color.cgColor
        return shapeLayer
    }
    
    func canUndo() -> Bool {
        removeEmptyElement()
        return !elements.isEmpty
    }
    
    func undo() {
        removeEmptyElement()
        if elements.isEmpty { return }
        let element = elements.removeLast()
        for layer in element.layerList {
            layer.removeFromSuperlayer()
        }
    }
    
    /// 删除空的元素
    func removeEmptyElement() {
        var idx = elements.count-1
        for element in elements.reversed() {
            if element.layerList.count < 3 {
                for layer in element.layerList {
                    layer.removeFromSuperlayer()
                }
                elements.remove(at: idx)
            }
            idx -= 1
        }
    }
}
