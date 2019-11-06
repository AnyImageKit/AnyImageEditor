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
        
        /// 编辑功能，会按顺序排布
        /// 默认：[.pen, .crop, .mosaic]
        public var editOptions: [PhotoEditOption]
        
        /// 画笔颜色，会按顺序排布
        /// 默认：[white, black, red, yellow, green, blue, purple]
        public var penColors: [UIColor]
        
        /// 默认选中画笔的下标
        /// 默认：2
        public var defaultPenIdx: Int
        
        /// 马赛克的种类，会按顺序排布
        /// 默认：[.default, .colorful]
        public var mosaicOptions: [PhotoMosaicOption]
        
        /// 默认选中马赛克的下标
        /// 默认：0
        public var defaultMosaicIdx: Int
        
        /// 马赛克模糊度，仅用于默认马赛克样式
        /// 默认：30
        public var mosaicLevel: Int
        
        public init(editOptions: [PhotoEditOption] = [.pen, .crop, .mosaic],
                    penColors: [UIColor] = Palette.all,
                    defaultPenIdx: Int = 2,
                    mosaicOptions: [PhotoMosaicOption] = [.default, .colorful],
                    defaultMosaicIdx: Int = 0,
                    mosaicLevel: Int = 30) {
            self.editOptions = editOptions
            self.penColors = penColors
            self.defaultPenIdx = defaultPenIdx
            self.mosaicOptions = mosaicOptions
            self.defaultMosaicIdx = defaultMosaicIdx
            self.mosaicLevel = mosaicLevel
        }
    }
    
    public enum PhotoEditOption {
        /// 画笔
        case pen
        /// 文字 未完成
        case text
        /// 裁剪
        case crop
        /// 马赛克
        case mosaic
    }
    
    public enum PhotoMosaicOption {
        /// 默认马赛克
        case `default`
        /// 彩色图片马赛克
        case colorful
        /// 自定义马赛克
        case custom(icon: UIImage, mosaic: UIImage)
    }
    
}

// MARK: - Extension
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

