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
    private let mosaicOptions: [ImageEditorController.PhotoMosaicOption]
    
    private var data: [MosaicData] = []
    private var current: MosaicData!
    
    init(frame: CGRect, mosaicImage: UIImage, mosaicOptions: [ImageEditorController.PhotoMosaicOption]) {
        self.mosaicImage = mosaicImage
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
                image = mosaicImage
            case .colorful:
                image = BundleHelper.image(named: "CustomMosaic")!
            case .custom(_, let customMosaic):
                image = customMosaic
            }
            data.append(MosaicData(frame: bounds, image: image))
        }
        if !data.isEmpty {
            current = data.first!
        }
        
        for item in data {
            layer.addSublayer(item.mosaicImageLayer)
            layer.addSublayer(item.shapeLayer)
        }
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

extension Mosaic {
    
}

// MARK: - Private function
extension Mosaic {
    
    private func pushPoint(_ point: CGPoint, state: TouchState) {
        switch state {
        case .begin:
            current.path.move(to: point)
        default:
            current.path.addLine(to: point)
        }
        
        guard let copyPath = current.path.copy() else { return }
        current.shapeLayer.path = copyPath
        
        if state == .end || state == .cancel {
            current.elements.append(copyPath)
            // TODO: 记录每次操作对象，便于 undo
        }
    }
}
