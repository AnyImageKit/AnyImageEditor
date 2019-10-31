//
//  PhotoContentView+Getter.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/29.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

extension PhotoContentView {
    
    /// 计算contentSize应处于的中心位置
    var centerOfContentSize: CGPoint {
        let deltaWidth = scrollView.bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = scrollView.bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    /// 取图片适屏size
    var fitSize: CGSize {
        guard let image = imageView.image else { return CGSize.zero }
        let width = scrollView.bounds.width
        let scale = image.size.height / image.size.width
        return CGSize(width: width, height: scale * width)
    }
    /// 取图片适屏frame
    var fitFrame: CGRect {
        let size = fitSize
        let x = (scrollView.bounds.width - size.width) > 0 ? (scrollView.bounds.width - size.width) * 0.5 : 0
        let y = (scrollView.bounds.height - size.height) > 0 ? (scrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    /// 裁剪的图片size
    var cropSize: CGSize {
        guard let image = imageView.image else { return CGSize.zero }
        let width = scrollView.bounds.width
        let scale = image.size.height / image.size.width
        let size = CGSize(width: width, height: scale * width)
        let screenSize = scrollView.bounds.size //UIScreen.main.bounds.size
        if size.height > screenSize.height {
            let scale2 = screenSize.height / size.height
            return CGSize(width: size.width * scale2, height: screenSize.height)
        }
        return size
    }
    /// 裁剪的图片frame
    var cropFrame: CGRect {
        let size = cropSize
        let x = (scrollView.bounds.width - size.width) > 0 ? (scrollView.bounds.width - size.width) * 0.5 : 0
        let y = (scrollView.bounds.height - size.height) > 0 ? (scrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    /// 裁剪的scrollView frame
    var cropScrollViewFrame: CGRect {
        let y: CGFloat
        let height: CGFloat
        if #available(iOS 11, *) {
            y = 15 + safeAreaInsets.top
            height = bounds.height - y - 125 - safeAreaInsets.bottom
        } else {
            y = 15
            height = bounds.height - y - 125
        }
        return CGRect(x: 15, y: y, width: bounds.width-30, height: height)
    }
    
    var cropMaxSize: CGSize {
        let y: CGFloat
        let height: CGFloat
        if #available(iOS 11, *) {
            y = 15 + safeAreaInsets.top
            height = bounds.height - y - 125 - safeAreaInsets.bottom
        } else {
            y = 15
            height = bounds.height - y - 125
        }
        return CGSize(width: bounds.width-30, height: height)
    }
    var cropSize2: CGSize {
        guard let image = imageView.image else { return CGSize.zero }
        let maxSize = cropMaxSize
        let scale = image.size.height / image.size.width
        let size = CGSize(width: maxSize.width, height: scale * maxSize.width)
        if size.height > maxSize.height {
            let scale2 = maxSize.height / size.height
            return CGSize(width: size.width * scale2, height: maxSize.height)
        }
        return size
    }
    var cropFrame2: CGRect {
        let maxSize = cropMaxSize
        let size = cropSize2
        let offset = 15 + topMargin
        let x = (scrollView.bounds.width - size.width) > 0 ? (scrollView.bounds.width - size.width) * 0.5 : 0
        let y = ((maxSize.height - size.height) > 0 ? (maxSize.height - size.height) * 0.5 : 0) + offset
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    var topMargin: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.top
        } else {
            return 0
        }
    }
}
