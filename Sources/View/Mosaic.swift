//
//  Mosaic.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/25.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class Mosaic: UIView {
    
    private let mosaicImage: UIImage
    
    // 展示马赛克图片的涂层
    private lazy var mosaicImageLayer: CALayer = {
        let layer = CALayer()
        layer.frame = bounds
        layer.contents = mosaicImage.cgImage
        return layer
    }()
    // 遮罩层，用于设置形状路径
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.lineWidth = 10.0
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = nil
        return layer
    }()
    
    var path = CGMutablePath()
    
    init(frame: CGRect, mosaicImage: UIImage) {
        self.mosaicImage = mosaicImage
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.addSublayer(mosaicImageLayer)
        layer.addSublayer(shapeLayer)
        mosaicImageLayer.mask = shapeLayer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.preciseLocation(in: self)
        path.move(to: point)
        shapeLayer.path = path.copy()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.preciseLocation(in: self)
        path.addLine(to: point)
        shapeLayer.path = path.copy()
    }
}
