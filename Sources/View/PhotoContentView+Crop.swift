//
//  PhotoContentView+Crop.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

// MARK: - Public function
extension PhotoContentView {

    func cropStart() {
        UIView.animate(withDuration: 0.25) {
            self.layoutCrop()
        }
    }
    
    func cropCancel() {
        UIView.animate(withDuration: 0.25) {
            self.layout()
        }
    }
    
    func cropDone() {
        
    }
    
    func cropReset() {
        
    }
}
