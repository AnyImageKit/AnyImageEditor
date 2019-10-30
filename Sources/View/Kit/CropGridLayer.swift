//
//  CropGridLayer.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CropGridLayer: CAShapeLayer {
    
    private let color: UIColor
    
    init(frame: CGRect, color: UIColor) {
        self.color = color
        super.init()
        self.frame = frame
        self.isHidden = true
        setupView()
        
        /// TODO: 换掉
        borderWidth = 1
        borderColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let path = UIBezierPath()
        let widthSpace = frame.width / 3
        let heightSpace = frame.height / 3
        for i in 1...2 {
            let x = widthSpace * CGFloat(i)
            let y = heightSpace * CGFloat(i)
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: frame.height))
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: frame.width, y: y))
        }
        self.path = path.cgPath
        self.lineWidth = 1
        self.strokeColor = color.cgColor
    }
}
