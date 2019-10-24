//
//  CanvasContentView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class CanvasContentView: UIView {

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.maximumZoomScale = 3.0 // 15.0
        view.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()
    private(set) lazy var canvas: Canvas = {
        let view = Canvas()
        view.dataSource = self
        return view
    }()
    
    /// 计算contentSize应处于的中心位置
    var centerOfContentSize: CGPoint {
        let deltaWidth = bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - scrollView.contentSize.height
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.addSubview(canvas)
        
        imageView.image = BundleHelper.image(named: "test-image")
        layout()
    }
    
    private func layout() {
        scrollView.frame = bounds
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        canvas.frame = CGRect(origin: .zero, size: imageView.bounds.size)
        scrollView.minimumZoomScale = getDefaultScale()
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }

}

// MARK: - Private functino
extension CanvasContentView {
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
extension CanvasContentView: CanvasDataSource {
    
    func canvasGetScale(_ canvas: Canvas) -> CGFloat {
        return scrollView.zoomScale
    }
}

// MARK: - UIScrollViewDelegate
extension CanvasContentView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = centerOfContentSize
    }
}
