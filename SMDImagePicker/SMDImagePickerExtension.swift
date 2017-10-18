//
//  SMDImagePickerExtension.swift
//  SMDImagePicker
//
//  Created by Tejas on 04/08/17.
//  Copyright © 2017 Gajjar Tejas. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import MobileCoreServices
import Photos

extension SMDImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let media = SMDMedia(fromDictionary: info)
        
        picker.dismiss(animated: true) {
            self.pickPhotoEnd?(media, SMDStatus.success)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.pickPhotoEnd?(nil, SMDStatus.canceled)
        }
    }
}
