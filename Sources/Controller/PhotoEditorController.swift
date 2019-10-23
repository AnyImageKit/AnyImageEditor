//
//  PhotoEditorController.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject. All rights reserved.
//

import UIKit
import SnapKit

public protocol PhotoEditorControllerDelegate: class {
    
    func photoEditor(_ editor: PhotoEditorController, didFinish photo: UIImage)
}

open class PhotoEditorController: UINavigationController {
    
    open weak var editorDelegate: PhotoEditorControllerDelegate?
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    required public init(delegate: PhotoEditorControllerDelegate) {
        let rootViewController = _PhotoEditorController()
        super.init(rootViewController: rootViewController)
        self.editorDelegate = delegate
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, deprecated, message: "init(coder:) has not been implemented")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
