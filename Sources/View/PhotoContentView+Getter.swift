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
    /// 全面屏的顶部边距
    var topMargin: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.top
        } else {
            return 0
        }
    }
    /// 全面屏的底部边距
    var bottomMargin: CGFloat {
        if #available(iOS 11, *) {
            return safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}

// MARK: - Crop
extension PhotoContentView {
    /// 裁剪 X 的偏移量
    var cropX: CGFloat {
        return 15
    }
    /// 裁剪 Y 的偏移量
    var cropY: CGFloat {
        return topMargin + 15
    }
    /// 裁剪底部的偏移量
    var cropBottomOffset: CGFloat {
        return bottomMargin + 65 + 50
    }
    /// 裁剪的scrollView frame
    var cropScrollViewFrame: CGRect {
        let y = cropY
        let height = bounds.height - y - cropBottomOffset
        return CGRect(x: cropX, y: y, width: bounds.width-cropX*2, height: height)
    }
    /// 裁剪区最大的Size
    var cropMaxSize: CGSize {
        let y = cropY
        let height = bounds.height - y - cropBottomOffset
        return CGSize(width: bounds.width-cropX*2, height: height)
    }
    /// 裁剪的图片size
    var cropSize: CGSize {
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
    /// 裁剪的图片frame
    var cropFrame: CGRect {
        let maxSize = cropMaxSize
        let size = cropSize
        let top = cropY
        let x = (scrollView.bounds.width - size.width) > 0 ? (scrollView.bounds.width - size.width) * 0.5 : 0
        let y = ((maxSize.height - size.height) > 0 ? (maxSize.height - size.height) * 0.5 : 0) + top
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    /// 裁剪时最大的缩放比例
    var cropMaximumZoomScale: CGFloat {
        let maxSize = cropMaxSize
        let size = cropSize
        var zoom: CGFloat = 1.0
        if size.width > size.height {
            zoom = maxSize.height / size.height
        } else {
            zoom = maxSize.width / size.width
        }
        return zoom * 6.0
    }
}
