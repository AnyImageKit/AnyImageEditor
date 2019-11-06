//
//  Ex+UIBezierPath.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/23.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func create(with points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: points.first!)
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        return path
    }
}
