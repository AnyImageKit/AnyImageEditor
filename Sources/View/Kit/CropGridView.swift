//
//  CropGridView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/11/1.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CropGridView: UIView {

    private lazy var rectLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    private lazy var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.strokeColor = UIColor.white.withAlphaComponent(0.7).cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var cropRect: CGRect = .zero
    
    private var animated: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.addSublayer(rectLayer)
        layer.addSublayer(lineLayer)
    }
    
    override func draw(_ rect: CGRect) {
        let rectPath = UIBezierPath()
        rectPath.move(to: cropRect.origin)
        rectPath.addLine(to: CGPoint(x: cropRect.origin.x + cropRect.width, y: cropRect.origin.y))
        rectPath.addLine(to: CGPoint(x: cropRect.origin.x + cropRect.width, y: cropRect.origin.y + cropRect.height))
        rectPath.addLine(to: CGPoint(x: cropRect.origin.x, y: cropRect.origin.y + cropRect.height))
        rectPath.addLine(to: cropRect.origin)
        
        let linePath = UIBezierPath()
        let widthSpace = cropRect.width / 3
        let heightSpace = cropRect.height / 3
        for i in 1...2 {
            let x = widthSpace * CGFloat(i) + cropRect.origin.x
            let y = heightSpace * CGFloat(i) + cropRect.origin.y
            // 竖线
            linePath.move(to: CGPoint(x: x, y: cropRect.origin.y))
            linePath.addLine(to: CGPoint(x: x, y: cropRect.origin.y + cropRect.height))
            // 横线
            linePath.move(to: CGPoint(x: cropRect.origin.x, y: y))
            linePath.addLine(to: CGPoint(x: cropRect.origin.x + cropRect.width, y: y))
        }
        
        if animated {
            animated = false
            let rectAnimation = createAnimation(name: "path", fromValue: rectLayer.path, toValue: rectPath.cgPath)
            rectLayer.add(rectAnimation, forKey: "path")
            let lineAnimation = createAnimation(name: "path", fromValue: lineLayer.path, toValue: linePath.cgPath)
            lineLayer.add(lineAnimation, forKey: "path")
        }
        lineLayer.path = linePath.cgPath
        rectLayer.path = rectPath.cgPath
    }
    
    func createAnimation(name: String, fromValue: CGPath?, toValue: CGPath?) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: name)
        animation.duration = 0.5
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}

extension CropGridView {
    
    func setRect(_ rect: CGRect, animated: Bool = false) {
        self.animated = animated
        cropRect = rect
        setNeedsDisplay()
    }
}
