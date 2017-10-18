//
//  SMDImagePickerEnum.swift
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
    public enum SMDStatus {
        case success
        case canceled
        case cameraNotAvailable
        case photoLibNotAvailable
        case notImage
        case notVideo
        case notDetermined
        case restricted
        case denied
        case authorized
        case unknown
        
        public func description() -> String {
            switch self {
            case .success:
                return "Success"
            case .canceled:
                return "Cancel selection"
            case .cameraNotAvailable:
                return "This device does not support camera"
            case .photoLibNotAvailable:
                return "The device does not support gallary"
            case .notImage:
                return "Can not get picture"
            case .notVideo:
                return "Can not get video"
            case .notDetermined:
                return "No authorization is made"
            case .restricted:
                return "Blocked Album/Camera access"
            case .denied:
                return "Album/Camera access denied"
            case .authorized:
                return "Authorized"
            case .unknown:
                return "Unknown error"
            }
        }
    }
    
    public enum SMDMediaType {
        case takePhoto, takeVideo, choosePhoto, chooseVideo, none
        public func description() -> String? {
            switch self {
            case .takePhoto, .takeVideo:
                return "Camera"
            case .choosePhoto, .chooseVideo:
                return "Album"
                
            default:
                return nil
            }
        }
    }
}
