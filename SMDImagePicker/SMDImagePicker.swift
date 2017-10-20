//
//  SMDImagePicker.swift
//  HSwiftTemp
//
//  Created by JuanFelix on 10/28/15.
//  Copyright © 2015 SKKJ-JuanFelix. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import MobileCoreServices
import Photos

public class SMDImagePicker: NSObject {
    
    public typealias SMDCompletion = (SMDMedia?, SMDStatus) -> Void
    
    internal var pickPhotoEnd: SMDCompletion?
    internal var mediaType: SMDMediaType = .none
    
    /// Properties: For Photo Capture
    public var photoCaptureOptions = PhotoCaptureOptions()
    
    /// Properties: For Video Record
    public var videoRecorderOptions = VideoRecorderOptions()
    
    /// Properties: For Taking Photo From Gallary
    public var photoGallaryOptions = PhotoGallaryOptions()
    
    /// Properties: For Taking Video From Gallary
    public var videoGallaryOptions = VideoGallaryOptions()
    
    /// Properties: For Ipad
    public var ipadOptions = IPadOptions()
    
    public func configure(_ configuration: PhotoCaptureOptions) {
        self.photoCaptureOptions.mediaTypes = configuration.mediaTypes
        self.photoCaptureOptions.allowsEditing = configuration.allowsEditing
        self.photoCaptureOptions.cameraDevice = configuration.cameraDevice
        self.photoCaptureOptions.flashMode = configuration.flashMode
    }
    
    public func configure(_ configuration: VideoRecorderOptions) {
        self.videoRecorderOptions.allowsEditing = configuration.allowsEditing
        self.videoRecorderOptions.cameraDevice = configuration.cameraDevice
        self.videoRecorderOptions.maximumDuration = configuration.maximumDuration
        self.videoRecorderOptions.quality = configuration.quality
        self.videoRecorderOptions.flashMode = configuration.flashMode
    }
    
    public func configure(_ configuration: PhotoGallaryOptions) {
        self.photoGallaryOptions.mediaTypes = configuration.mediaTypes
        self.photoGallaryOptions.allowsEditing = configuration.allowsEditing
    }
    
    public func configure(_ configuration: VideoGallaryOptions) {
        self.videoGallaryOptions.allowsEditing = configuration.allowsEditing
        self.videoGallaryOptions.mediaTypes = configuration.mediaTypes
        self.videoGallaryOptions.maximumDuration = configuration.maximumDuration
        self.videoGallaryOptions.quality = configuration.quality
    }
    
    public func capture(media: SMDMediaType, presentFrom rootVC: UIViewController, completion: SMDCompletion?) {
        self.pickPhotoEnd = completion
        if SMDImagePicker.isCameraAvailable() && SMDImagePicker.doesCameraSupportTakingPhotos() {
            SMDImagePicker.cameraAuthorized { (authorized, status) in
                if authorized || status == .notDetermined {
                    let controller = UIImagePickerController()
                    controller.view.backgroundColor = UIColor.white
                    controller.sourceType = UIImagePickerControllerSourceType.camera
                    
                    controller.delegate = self
                    
                    if media == .takePhoto {
                        controller.mediaTypes = self.photoCaptureOptions.mediaTypes
                        controller.allowsEditing = self.photoCaptureOptions.allowsEditing
                        controller.cameraDevice = self.photoCaptureOptions.cameraDevice
                        controller.cameraFlashMode = self.photoCaptureOptions.flashMode
                    } else if media == .takeVideo {
                        controller.allowsEditing = self.videoRecorderOptions.allowsEditing
                        controller.cameraDevice = self.videoRecorderOptions.cameraDevice
                        controller.videoMaximumDuration = self.videoRecorderOptions.maximumDuration
                        controller.videoQuality = self.videoRecorderOptions.quality
                        controller.cameraFlashMode = self.videoRecorderOptions.flashMode
                    }
                    
                    if #available(iOS 8.0, *) {
                        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    }
                    rootVC.present(controller, animated: true, completion: nil)
                } else {
                    self.pickPhotoEnd?(nil, status)
                }
            }
        } else {
            self.pickPhotoEnd?(nil, SMDStatus.cameraNotAvailable)
        }
    }
    
    public func choose(media: SMDMediaType, presentFrom rootVC: UIViewController, completion: SMDCompletion?) {
        self.pickPhotoEnd = completion
        if SMDImagePicker.isPhotoLibraryAvailable() {
            SMDImagePicker.photoAuthorized({ (authorized, status) in
                if authorized || status == .notDetermined {
                    let controller = UIImagePickerController()
                    controller.view.backgroundColor = UIColor.white
                    controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    
                    if media == .choosePhoto {
                        controller.allowsEditing = self.photoGallaryOptions.allowsEditing
                        if SMDImagePicker.canUserPickPhotosFromPhotoLibrary() {
                            controller.mediaTypes = self.photoGallaryOptions.mediaTypes
                        }
                    } else if media == .chooseVideo {
                        controller.allowsEditing = self.videoGallaryOptions.allowsEditing
                        controller.videoMaximumDuration = self.videoGallaryOptions.maximumDuration
                        if SMDImagePicker.canUserPickVideosFromPhotoLibrary() {
                            controller.mediaTypes = self.videoGallaryOptions.mediaTypes
                        }
                    }
                    
                    if #available(iOS 8.0, *) {
                        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    }
                    controller.popoverPresentationController?.sourceView = self.ipadOptions.sourceView
                    
                    controller.delegate = self
                    rootVC.present(controller, animated: true, completion: nil)
                } else {
                    self.pickPhotoEnd?(nil, status)
                }
            })
        } else {
            self.pickPhotoEnd?(nil, SMDStatus.photoLibNotAvailable)
        }
    }
    
    // MARK: Whether the user is authorized
    public static func cameraAuthorized(_ completion: ((Bool, SMDStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion?(true, .authorized)
        case .notDetermined:
            completion?(false, .notDetermined)
        case .restricted:
            completion?(false, .restricted)
        case .denied:
            completion?(false, .denied)
        }
    }
    
    public static func photoAuthorized(_ completion: ((Bool, SMDStatus) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion?(true, .authorized)
        case .notDetermined:
            completion?(false, .notDetermined)
        case .restricted:
            completion?(false, .restricted)
        case .denied:
            completion?(false, .denied)
        }
    }
    
    // MARK: Whether the camera function is available
    public static func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    // MARK: Whether the front camera is available
    public static func isFrontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
    }
    
    // MARK: Whether the rear camera is available
    public static func isRearCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear)
    }
    
    // MARK: To determine whether to support a certain multimedia type: camera, video
    public static func cameraSupports(mediaType: NSString, sourceType: UIImagePickerControllerSourceType) -> Bool {
        var result = false
        if mediaType.length == 0 {
            return false
        }
        let availableMediaTypes = NSArray(array: UIImagePickerController.availableMediaTypes(for: sourceType)!)
        availableMediaTypes.enumerateObjects({ (obj: Any, _: Int, stop: UnsafeMutablePointer<ObjCBool>) in
            if let type = obj as? NSString {
                if type.isEqual(to: mediaType as String) {
                    result = true
                    stop[0] = true
                }
            }
        })
        return result
    }
    
    // MARK: Check whether the camera supports video recording
    public static func doesCameraSupportShootingVides() -> Bool {
        let sourceType = UIImagePickerControllerSourceType.camera
        return self.cameraSupports(mediaType: kUTTypeMovie, sourceType: sourceType)
    }
    
    // MARK: Check whether the camera supports taking pictures
    public static func doesCameraSupportTakingPhotos() -> Bool {
        let sourceType = UIImagePickerControllerSourceType.camera
        return self.cameraSupports(mediaType: kUTTypeImage, sourceType: sourceType)
    }
    
    // MARK: Whether the album is available
    public static func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    // MARK: Whether you can select a video in the album
    public static func canUserPickVideosFromPhotoLibrary() -> Bool {
        let sourceType = UIImagePickerControllerSourceType.photoLibrary
        return self.cameraSupports(mediaType: kUTTypeMovie, sourceType: sourceType)
    }
    
    // MARK: Whether you can select an image in the album
    public static func canUserPickPhotosFromPhotoLibrary() -> Bool {
        let sourceType = UIImagePickerControllerSourceType.photoLibrary
        return self.cameraSupports(mediaType: kUTTypeImage, sourceType: sourceType)
    }
    
    public static func showTips(at rootVC: UIViewController!, type: SMDMediaType) {
        if #available(iOS 8.0, *) {
            let message = "Please allow \(String(describing: type.description())) access permission!"
            let title = "Open Setting"
            let preferredStyle = UIAlertControllerStyle.actionSheet
            let alertVC = UIAlertController(title: nil, message: message, preferredStyle: preferredStyle)
            let style = UIAlertActionStyle.default
            let openIt = UIAlertAction(title: title, style: style, handler: { (_: UIAlertAction) -> Void in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            alertVC.addAction(openIt)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                
            })
            alertVC.addAction(cancelAction)
            rootVC.present(alertVC, animated: true, completion: nil)
        } else {
            let message = "Please go to the 'system settings | privacy | \(String(describing: type.description()))' Turn on camera access"
            let alertVC = UIAlertController(title: nil,
                                            message: message,
                                            preferredStyle: UIAlertControllerStyle.alert)
            rootVC.present(alertVC, animated: true, completion: nil)
        }
    }
    
    public static func showTips(at rootVC: UIViewController!, message: String) {
        if #available(iOS 8.0, *) {
            let alertVC = UIAlertController(title: nil,
                                            message: message,
                                            preferredStyle: UIAlertControllerStyle.alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            })
            alertVC.addAction(okAction)
            rootVC.present(alertVC, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: nil,
                                            message: message,
                                            preferredStyle: UIAlertControllerStyle.alert)
            rootVC.present(alertVC, animated: true, completion: nil)
        }
    }
}
