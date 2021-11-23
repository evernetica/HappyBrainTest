//
//  PhotoPickerManager.swift
//  HappyBrainTest
//
//  Created by Alexander Malygin on 11/23/21.
//

import Foundation
import Photos
import Combine
import UIKit

final class PhotoPickerManager {
    static let shared = PhotoPickerManager()
    
    private let manager = PHImageManager.default()
    private var fetchOptions: PHFetchOptions {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return options
    }
    
    private var imageRequestOptions: PHImageRequestOptions {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
        return options
    }
    
    func getAllPhotos() -> AnyPublisher<[UIImage], Never> {
        let results = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var photos: [UIImage] = []
        let size = CGSize(width: 400, height: 200)
        let subject = PassthroughSubject<[UIImage], Never>()
        
        DispatchQueue.global(qos: .background).async {
            for item in 0..<results.count {
                let asset = results.object(at: item)
                self.manager.requestImage(for: asset,
                                             targetSize: size,
                                             contentMode: .aspectFill,
                                             options: self.imageRequestOptions) { (thumbnail, info) in
                    if let image = thumbnail {
                        photos.append(image)
                        subject.send(photos)
                    }
                }
            }
        }
        return subject.eraseToAnyPublisher()
    }
}
