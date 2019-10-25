//
//  MosaicData.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/25.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class MosaicData {
    
    // 展示马赛克图片的涂层
    let mosaicImageLayer: CALayer
    // 遮罩层，用于设置形状路径
    let shapeLayer: CAShapeLayer
    // 路径
    var elements: [CGPath] = []
    var path = CGMutablePath()
    
    init(frame: CGRect, image: UIImage) {
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer.frame = frame
        self.shapeLayer.lineCap = .round
        self.shapeLayer.lineJoin = .round
        self.shapeLayer.lineWidth = 20.0
        self.shapeLayer.strokeColor = UIColor.white.cgColor
        self.shapeLayer.fillColor = nil
        
        self.mosaicImageLayer = CALayer()
        self.mosaicImageLayer.frame = frame
        self.mosaicImageLayer.contents = image.cgImage
        self.mosaicImageLayer.mask = self.shapeLayer
    }
}

extension MosaicData {
    
    func undo() {
//        removeEmptyElement()
        if elements.isEmpty { return }
        elements.removeLast()
        if elements.isEmpty {
            path = CGMutablePath()
        } else {
            path = elements.last!.mutableCopy() ?? CGMutablePath()
        }
    }
    
    func removeEmptyElement() {
//        var idx = elements.count-1
//        for element in elements.reversed() {
//            if element.layerList.count < 3 {
//                for layer in element.layerList {
//                    layer.removeFromSuperlayer()
//                }
//                elements.remove(at: idx)
//            }
//            idx -= 1
//        }
    }
}
