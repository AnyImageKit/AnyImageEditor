//
//  ViewController.swift
//  Example
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit
import AnyImageEditor

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        presentController()
    }
    
    private func presentController() {
        guard let image = UIImage(named: "test-image") else { return }
        let config = ImageEditorController.PhotoConfig()
        let controller = ImageEditorController(imageType: .photo(config: config, image: image), delegate: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: ImageEditorControllerDelegate {
    
    func imageEditor(_ editor: ImageEditorController, didFinish photo: UIImage) {
        
    }
    
}
