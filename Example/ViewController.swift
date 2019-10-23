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
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let controller = PhotoEditorController(delegate: self)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: PhotoEditorControllerDelegate {
    
    func photoEditor(_ editor: PhotoEditorController, didFinish photo: UIImage) {
        
    }
    
}
