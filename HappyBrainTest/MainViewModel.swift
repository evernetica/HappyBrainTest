//
//  MainViewModel.swift
//  HappyBrainTest
//
//  Created by Alexander Malygin on 11/23/21.
//

import Foundation
import UIKit
import Photos
import Combine

final class MainViewModel: ObservableObject {
    @Published var dataSource: [UIImage] = []
    @Published var errorMessage : String = ""
    @Published var showAlert: Bool = false
    
    private let accessLevel: PHAccessLevel = .readWrite
    private var cancellable = Set<AnyCancellable>()
    let photoPickerManager = PhotoPickerManager.shared
    
    init() {
        checkPermission()
    }
    
    private func checkPermission() {
        PHPhotoLibrary.requestAuthorization(for: accessLevel) { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                    self.errorMessage = "Photo access permission not determined"
                    self.showAlert = true
                }
            case .restricted, .denied:
                DispatchQueue.main.async {
                    self.errorMessage = "Photo access permission denied"
                    self.showAlert = true
                }
            case .authorized, .limited:
                self.photoPickerManager.getAllPhotos()
                    .receive(on: DispatchQueue.main)
                    .sink { images in
                        self.dataSource = images
                    }.store(in: &self.cancellable)
            @unknown default:
                break
            }
        }
    }
}
