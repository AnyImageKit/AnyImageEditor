//
//  _PhotoEditorController.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class PhotoEditorController: UIViewController {

    private lazy var canvasView: CanvasContentView = {
        let view = CanvasContentView(frame: self.view.bounds)
        return view
    }()
    private lazy var toolView: PhotoToolView = {
        let view = PhotoToolView(frame: self.view.bounds, options: PhotoManager.shared.config.editOptions)
        
        return view
    }()
    private lazy var backButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(BundleHelper.image(named: "ReturnBackButton"), for: .normal)
        view.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    private lazy var singleTap: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(onSingleTap(_:)))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        view.addSubview(canvasView)
        view.addSubview(toolView)
        view.addSubview(backButton)
        view.addGestureRecognizer(singleTap)
        
        backButton.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            } else {
                maker.top.equalToSuperview().offset(40)
            }
            maker.left.equalToSuperview().offset(20)
            maker.width.height.equalTo(30)
        }
    }
}

// MARK: - Target
extension PhotoEditorController {
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onSingleTap(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: toolView)
        toolView.responseTouch(point)
    }
}
