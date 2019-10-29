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
        let deltaWidth = scrollView.bounds.width - scrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = scrollView.bounds.height - scrollView.contentSize.height
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
    /// 裁剪的图片size
    private var cropSize: CGSize {
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
    private var cropFrame: CGRect {
        let size = cropSize
        let x = (scrollView.bounds.width - size.width) > 0 ? (scrollView.bounds.width - size.width) * 0.5 : 0
        let y = (scrollView.bounds.height - size.height) > 0 ? (scrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    /// 裁剪的scrollView frame
    private var cropScrollViewFrame: CGRect {
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
    
    private let image: UIImage
    private let config: ImageEditorController.PhotoConfig
    
    /// 存储马赛克过程图片 // TODO: 改成磁盘存储
    private var mosaicImageList: [UIImage] = []
    
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
    
    private func layout() {
        scrollView.frame = bounds
        scrollView.maximumZoomScale = 3.0
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = fitFrame
        canvas.frame = CGRect(origin: .zero, size: imageView.bounds.size)
        scrollView.minimumZoomScale = getDefaultScale()
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
    private func layoutCrop() {
        scrollView.frame = cropScrollViewFrame
        scrollView.maximumZoomScale = 15.0
        scrollView.setZoomScale(1.0, animated: false)
        imageView.frame = cropFrame
        scrollView.contentSize = imageView.bounds.size
    }

}

// MARK: - Public function
extension PhotoContentView {
    
    func canvasUndo() {
        canvas.undo()
    }
    
    func canvasCanUndo() -> Bool {
        return canvas.canUndo()
    }
    
    func setMosaicImage(_ idx: Int) {
        mosaic?.setMosaicCoverImage(idx)
        imageView.image = mosaicImageList.last ?? image
    }
    
    func mosaicUndo() {
        if mosaicImageList.isEmpty { return }
        mosaicImageList.removeLast()
        imageView.image = mosaicImageList.last ?? image
        mosaic?.reset()
    }
    
    func mosaicCanUndo() -> Bool {
        return !mosaicImageList.isEmpty
    }
    
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

// MARK: - Private function
extension PhotoContentView {
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
                self.mosaic = Mosaic(frame: CGRect(origin: .zero, size: self.imageView.bounds.size), originalMosaicImage: mosaicImage, mosaicOptions: self.config.mosaicOptions)
                self.mosaic?.delegate = self
                self.mosaic?.dataSource = self
                self.mosaic?.isUserInteractionEnabled = false
                self.imageView.insertSubview(self.mosaic!, belowSubview: self.canvas)
                self.delegate?.mosaicDidCreated()
            }
        }
    }
    
    /// 生成截图
    private func getScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, true, UIScreen.main.scale)
        imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - CanvasDelegate
extension PhotoContentView: CanvasDelegate {
    
    func canvasDidBeginPen() {
        delegate?.photoDidBeginPen()
    }
    
    func canvasDidEndPen() {
        delegate?.photoDidEndPen()
    }
}

// MARK: - CanvasDataSource
extension PhotoContentView: CanvasDataSource {
    
    func canvasGetScale(_ canvas: Canvas) -> CGFloat {
        return scrollView.zoomScale
    }
}

// MARK: - MosaicDelegate
extension PhotoContentView: MosaicDelegate {
    
    func mosaicDidBeginPen() {
        delegate?.photoDidBeginPen()
    }
    
    func mosaicDidEndPen() {
        delegate?.photoDidEndPen()
        guard let screenshot = getScreenshot() else { return }
        mosaicImageList.append(screenshot)
        imageView.image = screenshot
        mosaic?.reset()
    }
}

// MARK: - MosaicDataSource
extension PhotoContentView: MosaicDataSource {
    
    func mosaicGetScale(_ mosaic: Mosaic) -> CGFloat {
        return scrollView.zoomScale
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
