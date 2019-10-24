//
//  CanvasController.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CanvasController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.maximumZoomScale = 15.0
        view.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    private lazy var canvas: Canvas = {
        let view = Canvas()
        view.dataSource = self
        return view
    }()
    
    /// 计算contentSize应处于的中心位置
    var centerOfContentSize: CGPoint {
        let deltaWidth = view.bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = view.bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    /// 取图片适屏size
    var fitSize: CGSize {
        guard let image = imageView.image else { return CGSize.zero }
        let width = scrollView.bounds.width
        let scale = image.size.height / image.size.width
        var size = CGSize(width: width, height: scale * width)
        let screenSize = UIScreen.main.bounds.size
        if size.width > size.height {
            size.width = size.width * screenSize.height / size.height
            size.height = screenSize.height
        }
        return size
    }
    
    /// 取图片适屏frame
    var fitFrame: CGRect {
        let size = fitSize
        let y = (scrollView.bounds.height - size.height) > 0 ? (scrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(x: 0, y: y, width: size.width, height: size.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.addSubview(canvas)
        
        imageView.image = BundleHelper.image(named: "test-image")
        layout()
    }
    
    /// 重新布局
    private func layout() {
        scrollView.frame = view.bounds
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        canvas.frame = CGRect(origin: .zero, size: imageView.bounds.size)
        scrollView.minimumZoomScale = getDefaultScale()
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }

}

extension CanvasController {
    
}

// MARK: - Private functino
extension CanvasController {
    /// 获取缩放比例
    private func getDefaultScale() -> CGFloat {
        guard let image = imageView.image else { return 1.0 }
        let width = scrollView.bounds.width
        let scale = image.size.height / image.size.width
        let size = CGSize(width: width, height: scale * width)
        let screenSize = UIScreen.main.bounds.size
        if size.width > size.height {
            return size.height / screenSize.height
        }
        return 1.0
    }
}

// MARK: - CanvasDataSource
extension CanvasController: CanvasDataSource {
    
    func canvasGetScale(_ canvas: Canvas) -> CGFloat {
        return scrollView.zoomScale
    }
}

// MARK: - UIScrollViewDelegate
extension CanvasController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = centerOfContentSize
    }
}
