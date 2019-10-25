//
//  ImageEditorController+Config.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

extension ImageEditorController {
    
    public enum ImageType {
        case photo(config: PhotoConfig, image: UIImage)
    }
    
    public struct PhotoConfig {
        
        public var editOptions: [PhotoEditOption] = [.pen, .text, .crop, .mosaic]
        
        public var penColors: [UIColor] = [.penWhite, .penBlack, .penRed, .penYellow, .penGreen, .penBlue, .penPurple]
        
        public var defaultPenIdx: Int = 2
        
        public init() { }
    }
    
    public enum PhotoEditOption {
        /// 画笔
        case pen
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
        case .pen:
            return "PhotoToolPen"
        case .text:
            return "PhotoToolText"
        case .crop:
            return "PhotoToolCrop"
        case .mosaic:
            return "PhotoToolMosaic"
        }
    }
}
