//
//  Ex+CABasicAnimation.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/11/4.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

extension CABasicAnimation {
    
    static func create(keyPath: String = "path", duration: CFTimeInterval, fromValue: CGPath?, toValue: CGPath?) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}
