//
//  _PhotoEditorController.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class PhotoEditorController: UIViewController {

    lazy var canvasController: CanvasController = {
        let controller = CanvasController()
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(undoButtonTapped(_:)))
        
        addChild(canvasController)
        view.addSubview(canvasController.view)
        canvasController.view.frame = view.bounds
    }
}

// MARK: - Action
extension PhotoEditorController {
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func undoButtonTapped(_ sender: UIButton) {
//        canvas.undo()
    }
}
