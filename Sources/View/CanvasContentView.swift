//
//  CanvasContentView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol CanvasContentViewDelegate: class {
    
    func canvasDidBeginPen()
    func canvasDidEndPen()
    
    func mosaicDidCreated()
}

final class CanvasContentView: UIView {

    weak var delegate: CanvasContentViewDelegate?
    
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.maximumZoomScale = 3.0 // 15.0
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: image)
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    /// 画板 - pen
    private(set) lazy var canvas: Canvas = {
        let view = Canvas()
        view.delegate = self
        view.dataSource = self
        view.isUserInteractionEnabled = false
        return view
    }()
    /// 马赛克，延时加载
    private(set) var mosaic: Mosaic?
    
    /// 计算contentSize应处于的中心位置
    private var centerOfContentSize: CGPoint {
        let deltaWidth = bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - scrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                       y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    /// 取图片适屏size
    private var fitSize: CGSize {
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
    private var fitFrame: CGRect {
        let size = fitSize
        let y = (scrollView.bounds.height - size.height) > 0 ? (scrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(x: 0, y: y, width: size.width, height: size.height)
    }
    
    private var image: UIImage
    
    init(frame: CGRect, image: UIImage) {
        self.image = image
        super.init(frame: frame)
        setupView()
        setupMosaicView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.addSubview(canvas)
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
    
    /// 在子线程创建马赛克图片
    private func setupMosaicView() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let mosaicImage = UIImage.createMosaicImage(from: self.image, level: 20) else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("Mosaic created")
                self.mosaic = Mosaic(frame: CGRect(origin: .zero, size: self.imageView.bounds.size), mosaicImage: mosaicImage)
                self.mosaic?.isUserInteractionEnabled = false
                self.imageView.insertSubview(self.mosaic!, belowSubview: self.canvas)
                self.delegate?.mosaicDidCreated()
            }
        }
    }
}

// MARK: - CanvasDelegate
extension CanvasContentView: CanvasDelegate {
    
    func canvasDidBeginPen() {
        delegate?.canvasDidBeginPen()
    }
    
    func canvasDidEndPen() {
        delegate?.canvasDidEndPen()
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
