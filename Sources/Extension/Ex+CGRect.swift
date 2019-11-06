//
//  Ex+CGRect.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

extension CGRect {
    
    func bigger(_ edge: UIEdgeInsets) -> CGRect {
        return CGRect(x: origin.x-edge.left, y: origin.y-edge.top, width: width+edge.left+edge.right, height: height+edge.top+edge.bottom)
    }
}
