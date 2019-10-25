//
//  PhotoManager.swift
//  AnyImageEditor
//
//  Created by 蒋惠 on 2019/10/24.
//  Copyright © 2019 AnyImageProject.org. All rights reserved.
//

import UIKit

final class PhotoManager {
    
    static let shared: PhotoManager = PhotoManager()
    
    var config = ImageEditorController.PhotoConfig()
    var image: UIImage {
        switch imageType {
        case .photo(_, let image):
            return image
        }
        fatalError()
    }
    
    var imageType: ImageEditorController.ImageType = .photo(config: ImageEditorController.PhotoConfig(), image: UIImage())
    
    private init() { }
    
}
