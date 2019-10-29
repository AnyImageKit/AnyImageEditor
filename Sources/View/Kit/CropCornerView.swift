//
//  CropCornerView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CropCornerView: UIView {
    
    private let color: UIColor
    private let position: CropCornerPosition
    
    init(frame: CGRect, color: UIColor, position: CropCornerPosition) {
        self.color = color
        self.position = position
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let path = UIBezierPath()
        switch position {
        case .topLeft:
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
        case .topRight:
            path.move(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: .zero)
            path.move(to: CGPoint(x: bounds.width, y: 0))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        case .bottomLeft:
            path.move(to: CGPoint(x: 0, y: bounds.height))
            path.addLine(to: .zero)
            path.move(to: CGPoint(x: 0, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        case .bottomRight:
            path.move(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: bounds.width, y: 0))
            path.move(to: CGPoint(x: bounds.width, y: bounds.height))
            path.addLine(to: CGPoint(x: 0, y: bounds.height))
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        layer.addSublayer(shapeLayer)
    }
    
}

enum CropCornerPosition: Int {
    case topLeft = 1
    case topRight
    case bottomLeft
    case bottomRight
}
