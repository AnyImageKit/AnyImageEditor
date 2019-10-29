//
//  CropGridLayer.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CropGridLayer: CALayer {
    
    var clippingRect: CGRect = .zero
    private let bgColor: UIColor
    private let gridColor: UIColor
    
    init(bgColor: UIColor, gridColor: UIColor) {
        self.bgColor = bgColor
        self.gridColor = gridColor
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        var rect = bounds
        ctx.setFillColor(bgColor.cgColor)
        ctx.fill(rect)
        
        ctx.clear(clippingRect)
        
        ctx.setStrokeColor(gridColor.cgColor)
        ctx.setLineWidth(1)
        
        rect = clippingRect
        
        ctx.beginPath()
        var dW: CGFloat = 0
        for _ in 0..<4 {
            ctx.move(to: CGPoint(x: rect.origin.x + dW, y: rect.origin.y))
            ctx.addLine(to: CGPoint(x: rect.origin.x + dW, y: rect.origin.y + rect.size.height))
            dW += clippingRect.size.width / 3
        }
        
        dW = 0
        for _ in 0..<4 {
            ctx.move(to: CGPoint(x: rect.origin.x, y: rect.origin.y + dW))
            ctx.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + dW))
            dW += rect.size.height / 3
        }
        ctx.strokePath()
    }
}
