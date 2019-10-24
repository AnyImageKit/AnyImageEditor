//
//  ImageEditorController+Config.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

extension ImageEditorController {
    
    public struct PhotoConfig {
        
        public var editOptions: [PhotoEditOption] = [.pan, .text, .crop, .mosaic]
        
        public var panColors: [UIColor] = [.panWhite, .panBlack, .panRed, .panYellow, .panGreen, .panBlue, .panPurple]
        
    }
    
    public enum PhotoEditOption {
        /// 画笔
        case pan
        /// 文字
        case text
        /// 裁剪
        case crop
        /// 马赛克
        case mosaic
    }
    
}

extension ImageEditorController.PhotoEditOption {
    var imageName: String {
        switch self {
        case .pan:
            return "PhotoToolPan"
        case .text:
            return "PhotoToolText"
        case .crop:
            return "PhotoToolCrop"
        case .mosaic:
            return "PhotoToolMosaic"
        }
    }
}
