//
//  _PhotoEditorController.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject. All rights reserved.
//

import UIKit

final class PhotoEditorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tv = TestView()
        tv.isUserInteractionEnabled = true
        tv.backgroundColor = UIColor.lightGray
        view.addSubview(tv)
        tv.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

}
