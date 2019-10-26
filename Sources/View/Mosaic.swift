//
//  Mosaic.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/25.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol MosaicDelegate: class {
    
    func mosaicDidBeginPen()
    func mosaicDidEndPen()
}

final class Mosaic: UIView {
    
    weak var delegate: MosaicDelegate?
    
    private let originalMosaicImage: UIImage
    private let mosaicOptions: [ImageEditorController.PhotoMosaicOption]
    
    /// 当前马赛克覆盖的图片
    private var mosaicImage: UIImage!
    /// 马赛克覆盖图片
    private var mosaicCoverImage: [UIImage] = []
    /// 展示马赛克图片的涂层
    private var mosaicImageLayer = CALayer()
    /// 遮罩层，用于设置形状路径
    private var shapeLayer = CAShapeLayer()
    /// 路径
    private var path = CGMutablePath()
    /// 步长
    private var lenth = 0
    
    
    init(frame: CGRect, originalMosaicImage: UIImage, mosaicOptions: [ImageEditorController.PhotoMosaicOption]) {
        self.originalMosaicImage = originalMosaicImage
        self.mosaicOptions = mosaicOptions
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // create
        for option in mosaicOptions {
            let image: UIImage
            switch option {
            case .default:
                image = originalMosaicImage
            case .colorful:
                image = BundleHelper.image(named: "CustomMosaic")!
            case .custom(_, let customMosaic):
                image = customMosaic
            }
            mosaicCoverImage.append(image)
        }
        setMosaicCoverImage(mosaicCoverImage.first!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.preciseLocation(in: self)
        pushPoint(point, state: .begin)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.preciseLocation(in: self)
        pushPoint(point, state: .move)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.preciseLocation(in: self)
        pushPoint(point, state: .end)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.preciseLocation(in: self)
        pushPoint(point, state: .cancel)
    }
}

// MARK: - Public function
extension Mosaic {
    func reset() {
        path = CGMutablePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.frame = frame
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        shapeLayer.lineWidth = 20.0
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = nil
        mosaicImageLayer = CALayer()
        mosaicImageLayer.frame = frame
        mosaicImageLayer.contents = mosaicImage.cgImage
        
        layer.addSublayer(mosaicImageLayer)
        layer.addSublayer(shapeLayer)
        mosaicImageLayer.mask = shapeLayer
    }
}

// MARK: - Private function
extension Mosaic {
    
    private func setMosaicCoverImage(_ image: UIImage) {
        mosaicImage = image
        reset()
    }
    
    private func pushPoint(_ point: CGPoint, state: TouchState) {
        switch state {
        case .begin:
            lenth = 0
            path.move(to: point)
        default:
            lenth += 1
            path.addLine(to: point)
        }
        
        if lenth <= 1 { return }
        if lenth == 2 { delegate?.mosaicDidBeginPen() }
        guard let copyPath = path.copy() else { return }
        shapeLayer.path = copyPath
        
        if (state == .end || state == .cancel) { //&& lenth > 1
            delegate?.mosaicDidEndPen()
        }
    }
}
