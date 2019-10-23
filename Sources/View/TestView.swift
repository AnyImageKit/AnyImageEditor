//
//  TestView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject. All rights reserved.
//

import UIKit

class TestView: UIView {

    var lines: [[CGPoint]] = []
    var current: [CGPoint] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let point = touch.preciseLocation(in: self)
        current = [point]
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let point = touch.preciseLocation(in: self)
        current.append(point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let point = touch.preciseLocation(in: self)
        current.append(point)
        lines.append(current)
        current = []
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        for line in lines {
            let path = UIBezierPath()
//            path.lineWidth = 2
            
            for (idx, point) in line.enumerated() {
                if idx == 0 {
                    path.move(to: line.first!)
                } else {
                    path.addLine(to: point)
                }
            }
            
//            UIColor.red.setFill()
//            path.fill()
            
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath //存入UIBezierPath的路径
            shapeLayer.fillColor = UIColor.clear.cgColor //设置填充色
            shapeLayer.lineWidth = 2  //设置路径线的宽度
            shapeLayer.strokeColor = UIColor.green.cgColor //路径颜色
            //如果想变为虚线设置这个属性，[实线宽度，虚线宽度]，若两宽度相等可以简写为[宽度]
//            shapeLayer.lineDashPattern = [2]
            //一般可以填"path"  "strokeStart" "strokeEnd"  具体还需研究
//            let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
//            baseAnimation.duration = 2   //持续时间
//            baseAnimation.fromValue = 0  //开始值
//            baseAnimation.toValue = 2    //结束值
//            baseAnimation.repeatDuration = 5  //重复次数
//            shapeLayer.addAnimation(baseAnimation, forKey: nil) //给ShapeLayer添
            //显示在界面上
//            self.view.layer.addSublayer(shapeLayer)
            self.layer.addSublayer(shapeLayer)
            
        }
    }

}
