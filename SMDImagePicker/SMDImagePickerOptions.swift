//
//  SMDImagePickerOptions.swift
//  SMDImagePicker
//
//  Created by Tejas on 6/25/17.
//  Copyright © 2017 Gajjar Tejas. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import MobileCoreServices
import Photos

extension SMDImagePicker {
    
    public struct PhotoCaptureOptions {
        
        var allowsEditing: Bool = false
        var cameraDevice: UIImagePickerControllerCameraDevice = .front
        var mediaTypes: [String] = [kUTTypeImage as String]
        var flashMode: UIImagePickerControllerCameraFlashMode = .auto
        
        public init(allowsEditing: Bool = true,
                    cameraDevice: UIImagePickerControllerCameraDevice = .front,
                    mediaTypes: [String] = [kUTTypeImage as String],
                    flashMode: UIImagePickerControllerCameraFlashMode = .auto) {
            
            self.allowsEditing = allowsEditing
            self.cameraDevice = cameraDevice
            self.mediaTypes = mediaTypes
            self.flashMode = flashMode
        }
    }
    
    public struct VideoRecorderOptions {
        
        var allowsEditing: Bool = false
        var cameraDevice: UIImagePickerControllerCameraDevice = .front
        var maximumDuration: TimeInterval = 60*10// default value is 10 minutes.
        var quality: UIImagePickerControllerQualityType = .typeMedium
        var flashMode: UIImagePickerControllerCameraFlashMode = .auto
        
        public init(allowsEditing: Bool = true,
                    cameraDevice: UIImagePickerControllerCameraDevice = .front,
                    maximumDuration: TimeInterval = 60*10,
                    quality: UIImagePickerControllerQualityType = .typeMedium,
                    flashMode: UIImagePickerControllerCameraFlashMode = .auto) {
            
            self.allowsEditing = allowsEditing
            self.cameraDevice = cameraDevice
            self.maximumDuration = maximumDuration
            self.quality = quality
            self.flashMode = flashMode
        }
    }
    
    public struct PhotoGallaryOptions {
        
        var allowsEditing: Bool = false
        var mediaTypes: [String] = [kUTTypeImage as String]
        
        public init(allowsEditing: Bool = true,
                    mediaTypes: [String] = [kUTTypeImage as String]
            ) {
            self.allowsEditing = allowsEditing
            self.mediaTypes = mediaTypes
        }
    }
    
    public struct VideoGallaryOptions {
        
        var allowsEditing: Bool = false
        var mediaTypes: [String] = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeMPEG4 as String]
        var maximumDuration: TimeInterval = 60*10// default value is 10 minutes.
        var quality: UIImagePickerControllerQualityType = .typeMedium
        
        public init(allowsEditing: Bool = false,
                    mediaTypes: [String] = [kUTTypeMovie as String, kUTTypeVideo as String, kUTTypeMPEG4 as String],
                    maximumDuration: TimeInterval = 60*10,
                    quality: UIImagePickerControllerQualityType = .typeMedium
            ) {
            
            self.allowsEditing = allowsEditing
            self.mediaTypes = mediaTypes
            self.maximumDuration = maximumDuration
            self.quality = quality
        }
    }
}
