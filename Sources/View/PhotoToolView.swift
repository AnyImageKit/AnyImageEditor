//
//  PhotoToolView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol PhotoToolViewDelegate: class {
    
    func toolView(_ toolView: PhotoToolView, optionDidChange option: ImageEditorController.PhotoEditOption?)
    
    func toolView(_ toolView: PhotoToolView, colorDidChange idx: Int)
    
    func toolViewUndoButtonTapped(_ toolView: PhotoToolView)
}

final class PhotoToolView: UIView {
    
    weak var delegate: PhotoToolViewDelegate?
    
    var currentOption: ImageEditorController.PhotoEditOption? {
        editOptionsView.currentOption
    }
    
    private let config: ImageEditorController.PhotoConfig
    
    private lazy var topCoverLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let statusBarHeight = StatusBarHelper.height
        layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: statusBarHeight + 120)
        layer.colors = [
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.06).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor]
        layer.locations = [0, 0.7, 0.85, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    private lazy var bottomCoverLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        let height: CGFloat = 100 + (UIDevice.isMordenPhone ? 34 : 0)
        layer.frame = CGRect(x: 0, y: bounds.height-height, width: UIScreen.main.bounds.width, height: height)
        layer.colors = [
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.12).cgColor,
            UIColor.black.withAlphaComponent(0.06).cgColor,
            UIColor.black.withAlphaComponent(0).cgColor]
        layer.locations = [0, 0.7, 0.85, 1]
        layer.startPoint = CGPoint(x: 0.5, y: 1)
        layer.endPoint = CGPoint(x: 0.5, y: 0)
        return layer
    }()
    
    private lazy var editOptionsView: PhotoEditOptionsView = {
        let view = PhotoEditOptionsView(frame: .zero, options: config.editOptions)
        view.delegate = self
        return view
    }()
    private lazy var penToolView: PhotoPenToolView = {
        let view = PhotoPenToolView(frame: .zero, colors: config.penColors, defaultIdx: config.defaultPenIdx)
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    
    init(frame: CGRect, config: ImageEditorController.PhotoConfig) {
        self.config = config
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.addSublayer(topCoverLayer)
        layer.addSublayer(bottomCoverLayer)
        addSubview(editOptionsView)
        addSubview(penToolView)
        
        editOptionsView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(20)
            if #available(iOS 11, *) {
                maker.bottom.equalTo(safeAreaLayoutGuide).offset(-14)
            } else {
                maker.bottom.equalToSuperview().offset(-14)
            }
            maker.height.equalTo(50)
        }
        penToolView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview().inset(20)
            maker.bottom.equalTo(editOptionsView.snp.top).offset(-20)
            maker.height.equalTo(20)
        }
    }
}

// MARK: - PhotoEditOptionsViewDelegate
extension PhotoToolView: PhotoEditOptionsViewDelegate {
    
    func editOptionsView(_ editOptionsView: PhotoEditOptionsView, optionDidChange option: ImageEditorController.PhotoEditOption?) {
        delegate?.toolView(self, optionDidChange: option)
        
        guard let option = option else {
            penToolView.isHidden = true
            return
        }
        
        penToolView.isHidden = option != .pen
    }
}

// MARK: - PhotoPenToolViewDelegate
extension PhotoToolView: PhotoPenToolViewDelegate {
    
    func penToolView(_ penToolView: PhotoPenToolView, colorDidChange idx: Int) {
        delegate?.toolView(self, colorDidChange: idx)
    }
    
    func penToolViewUndoButtonTapped(_ penToolView: PhotoPenToolView) {
        delegate?.toolViewUndoButtonTapped(self)
    }
}

// MARK: - ResponseTouch
extension PhotoToolView: ResponseTouch {
    
    @discardableResult
    func responseTouch(_ point: CGPoint) -> Bool {
        let subViews = [editOptionsView, penToolView].filter{ !$0.isHidden }
        for subView in subViews {
            let viewPoint = point.subtraction(with: subView.frame.origin)
            if let subView = subView as? ResponseTouch, subView.responseTouch(viewPoint) {
                return true
            }
        }
        return false
    }
}
