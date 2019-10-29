//
//  PhotoContentView.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

protocol PhotoContentViewDelegate: class {
    
    func photoDidBeginPen()
    func photoDidEndPen()
    
    func mosaicDidCreated()
}

final class PhotoContentView: UIView {

    weak var delegate: PhotoContentViewDelegate?
    
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.clipsToBounds = false
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.maximumZoomScale = 3.0 // 15.0
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    private(set) lazy var imageView: UIImageView = {
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
    internal var mosaic: Mosaic?
    
    internal let image: UIImage
    internal let config: ImageEditorController.PhotoConfig
    
    /// 存储马赛克过程图片 // TODO: 改成磁盘存储
    internal var mosaicImageList: [UIImage] = []
    
    init(frame: CGRect, image: UIImage, config: ImageEditorController.PhotoConfig) {
        self.image = image
        self.config = config
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
    
    internal func layout() {
        scrollView.frame = bounds
        scrollView.maximumZoomScale = 3.0
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        canvas.frame = CGRect(origin: .zero, size: imageView.bounds.size)
        scrollView.minimumZoomScale = scrollViewDefaultScale
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
    internal func layoutCrop() {
        scrollView.frame = cropScrollViewFrame
        scrollView.maximumZoomScale = 15.0
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = cropFrame
        scrollView.contentSize = imageView.bounds.size
    }

}

// MARK: - UIScrollViewDelegate
extension PhotoContentView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = centerOfContentSize
    }
}
