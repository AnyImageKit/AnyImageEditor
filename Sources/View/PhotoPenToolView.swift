//
//  PhotoPenToolView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol PhotoPenToolViewDelegate: class {
    
    func penToolView(_ penToolView: PhotoPenToolView, colorDidChange idx: Int)
    
    func penToolViewUndoButtonTapped(_ penToolView: PhotoPenToolView)
}

final class PhotoPenToolView: UIView {
    
    weak var delegate: PhotoPenToolViewDelegate?
    
    private(set) var currentIdx: Int
    
    private(set) lazy var undoButton: UIButton = {
        let view = UIButton(type: .custom)
        view.isEnabled = false
        view.setImage(BundleHelper.image(named: "PhotoToolUndo"), for: .normal)
        return view
    }()
    
    private let colors: [UIColor]
    private var colorViews:[UIView] = []
    private let spacing: CGFloat = 20
    
    init(frame: CGRect, colors: [UIColor], defaultIdx: Int) {
        self.colors = colors
        self.currentIdx = defaultIdx
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (idx, colorView) in colorViews.enumerated() {
            let scale: CGFloat = idx == currentIdx ? 1.25 : 1.0
            colorView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private func setupView() {
        setupColorView()
        addSubview(undoButton)
        
        undoButton.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(22)
        }
    }
    
    private func setupColorView() {
        for (idx, color) in colors.enumerated() {
            colorViews.append(createColorView(color, idx: idx))
        }
        let stackView = UIStackView(arrangedSubviews: colorViews)
        stackView.spacing = spacing
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(22)
        }
        
        for colorView in colorViews {
            colorView.snp.makeConstraints { (maker) in
                maker.width.height.equalTo(stackView.snp.height)
            }
        }
    }
    
    private func createColorView(_ color: UIColor, idx: Int) -> UIView {
        let view = UIView()
        view.tag = idx
        view.backgroundColor = color
        view.clipsToBounds = true
        view.layer.cornerRadius = 11
        view.layer.borderWidth = 2.5
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }

}

// MARK: - ResponseTouch
extension PhotoPenToolView: ResponseTouch {
    
    @discardableResult
    func responseTouch(_ point: CGPoint) -> Bool {
        // Color view
        for (idx, colorView) in colorViews.enumerated() {
            let frame = colorView.frame.bigger(.init(top: spacing/4, left: spacing/2, bottom: spacing*0.8, right: spacing/2))
            if frame.contains(point) { // inside
                if currentIdx != idx {
                    currentIdx = idx
                    layoutSubviews()
                }
                delegate?.penToolView(self, colorDidChange: currentIdx)
                return true
            }
        }
        // Undo
        let undoFrame = undoButton.frame.bigger(.init(top: spacing/4, left: spacing/2, bottom: spacing*0.8, right: spacing/2))
        if undoFrame.contains(point) {
            delegate?.penToolViewUndoButtonTapped(self)
        }
        return false
    }
}
