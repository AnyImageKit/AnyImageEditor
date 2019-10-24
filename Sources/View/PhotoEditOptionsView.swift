//
//  PhotoEditOptionsView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol PhotoEditOptionsViewDelegate: class {
    
    func editOptionsView(_ editOptionsView: PhotoEditOptionsView, optionDidChange option: ImageEditorController.PhotoEditOption?)
    
}

final class PhotoEditOptionsView: UIView {
    
    weak var delegate: PhotoEditOptionsViewDelegate?
    
    private(set) var current: ImageEditorController.PhotoEditOption?
    
    private let options: [ImageEditorController.PhotoEditOption]
    private var buttons: [UIButton] = []
    
    init(frame: CGRect, options: [ImageEditorController.PhotoEditOption]) {
        self.options = options
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        for (idx, option) in options.enumerated() {
            let button = createButton(with: option)
            button.tag = idx
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.spacing = 25
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(25)
        }
        
        for button in buttons {
            button.snp.makeConstraints { (maker) in
                maker.width.height.equalTo(stackView.snp.height)
            }
        }
    }
    
    private func createButton(with option: ImageEditorController.PhotoEditOption) -> UIButton {
        let button = UIButton(type: .custom)
        let image = BundleHelper.image(named: option.imageName)
        button.setImage(image, for: .normal)
        button.setImage(BundleHelper.image(named: "ReturnBackButton"), for: .selected) // TODO: change
        return button
    }
}

// MARK: - Public function
extension PhotoEditOptionsView {
    
    func tap(_ point: CGPoint) {
        for (idx, button) in buttons.enumerated() {
            let inside = button.point(inside: point, with: nil)
            if inside {
                if let current = current, options[idx] == current {
                    self.current = nil
                    button.isSelected = false
                } else {
                    self.current = options[idx]
                    button.isSelected = true
                }
                delegate?.editOptionsView(self, optionDidChange: self.current)
                return
            }
        }
    }
}
