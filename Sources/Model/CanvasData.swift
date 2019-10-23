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
    
    func layer(of points: [CGPoint], brush: Brush) -> CAShapeLayer {
        let path = UIBezierPath.create(with: points)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineWidth = 3
        // Brush
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = brush.color.cgColor
        return shapeLayer
    }
    
    func undo() {
        if elements.isEmpty { return }
        let element = elements.removeLast()
        for layer in element.layerList {
            layer.removeFromSuperlayer()
        }
    }
}
