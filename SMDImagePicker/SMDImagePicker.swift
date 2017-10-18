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
    
    // MARK : Private Properties: For Photo Capture
    private var photoCaptureMediaTypes: [String] = [kUTTypeImage as String]
    private var photoCaptureAllowsEditing: Bool = false
    private var photoCapturecameraDevice: UIImagePickerControllerCameraDevice = .front
    private var photoCaptureFlashMode: UIImagePickerControllerCameraFlashMode = .auto
    
    // MARK : Private Properties: For Video Record
    private var videoRecorderAllowsEditing: Bool = false
    private var videoRecordercameraDevice: UIImagePickerControllerCameraDevice = .front
    private var videoRecorderMaximumDuration: TimeInterval = 60*10 // default value is 10 minutes.
    private var videoRecorderQuality: UIImagePickerControllerQualityType = .typeMedium
    private var videoRecorderFlashMode: UIImagePickerControllerCameraFlashMode = .auto
    
    // MARK : Private Properties: For Taking Photo From Gallary
    private var photoGallaryMediaTypes: [String] = [kUTTypeImage as String]
    private var photoGallaryAllowsEditing: Bool = false
    
    // MARK : Private Properties: For Taking Video From Gallary
    private var videoGallaryAllowsEditing: Bool = false
    private var videoGallaryMediaTypes: [String] = [kUTTypeMovie as String]
    private var videoGallaryMaximumDuration: TimeInterval = 60*10// default value is 10 minutes.
    private var videoGallaryQuality: UIImagePickerControllerQualityType = .typeMedium
    
    public func configure(_ configuration: PhotoCaptureOptions) {
        self.photoCaptureMediaTypes = configuration.mediaTypes
        self.photoCaptureAllowsEditing = configuration.allowsEditing
        self.photoCapturecameraDevice = configuration.cameraDevice
        self.photoCaptureFlashMode = configuration.flashMode
    }
    
    public func configure(_ configuration: VideoRecorderOptions) {
        self.videoRecorderAllowsEditing = configuration.allowsEditing
        self.videoRecordercameraDevice = configuration.cameraDevice
        self.videoRecorderMaximumDuration = configuration.maximumDuration
        self.videoRecorderQuality = configuration.quality
        self.videoRecorderFlashMode = configuration.flashMode
    }
    
    public func configure(_ configuration: PhotoGallaryOptions) {
        self.photoGallaryMediaTypes = configuration.mediaTypes
        self.photoGallaryAllowsEditing = configuration.allowsEditing
    }
    
    public func configure(_ configuration: VideoGallaryOptions) {
        self.videoGallaryAllowsEditing = configuration.allowsEditing
        self.videoGallaryMediaTypes = configuration.mediaTypes
        self.videoGallaryMaximumDuration = configuration.maximumDuration
        self.videoGallaryQuality = configuration.quality
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
                        controller.mediaTypes = self.photoCaptureMediaTypes
                        controller.allowsEditing = self.photoCaptureAllowsEditing
                        controller.cameraDevice = self.photoCapturecameraDevice
                        controller.cameraFlashMode = self.photoCaptureFlashMode
                    } else if media == .takeVideo {
                        controller.allowsEditing = self.videoRecorderAllowsEditing
                        controller.cameraDevice = self.videoRecordercameraDevice
                        controller.videoMaximumDuration = self.videoRecorderMaximumDuration
                        controller.videoQuality = self.videoRecorderQuality
                        controller.cameraFlashMode = self.videoRecorderFlashMode
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
                        controller.allowsEditing = self.photoGallaryAllowsEditing
                        if SMDImagePicker.canUserPickPhotosFromPhotoLibrary() {
                            controller.mediaTypes = self.photoGallaryMediaTypes
                        }
                    } else if media == .chooseVideo {
                        controller.allowsEditing = self.videoGallaryAllowsEditing
                        controller.videoMaximumDuration = self.videoGallaryMaximumDuration
                        if SMDImagePicker.canUserPickVideosFromPhotoLibrary() {
                            controller.mediaTypes = self.videoGallaryMediaTypes
                        }
                    }
                    
                    if #available(iOS 8.0, *) {
                        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    }
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
