//
//  CropView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CropView: UIView {
    
    private let cornerFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
    private(set) lazy var topLeftCorner: CropCornerView = {
        let view = CropCornerView(frame: cornerFrame, color: .white, position: .topLeft)
        return view
    }()
    private(set) lazy var topRightCorner: CropCornerView = {
        let view = CropCornerView(frame: cornerFrame, color: .white, position: .topRight)
        return view
    }()
    private(set) lazy var bottomLeftCorner: CropCornerView = {
        let view = CropCornerView(frame: cornerFrame, color: .white, position: .bottomLeft)
        return view
    }()
    private(set) lazy var bottomRightCorner: CropCornerView = {
        let view = CropCornerView(frame: cornerFrame, color: .white, position: .bottomRight)
        return view
    }()
    private(set) lazy var gridLayer: CropGridLayer = {
        let view = CropGridLayer(bgColor: .white, gridColor: UIColor.black.withAlphaComponent(0.5))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.addSublayer(gridLayer)
        addSubview(topLeftCorner)
        addSubview(topRightCorner)
        addSubview(bottomLeftCorner)
        addSubview(bottomRightCorner)
    }

}
