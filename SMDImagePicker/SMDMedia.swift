//
//  SMDMedia.swift
//  SMDImagePicker
//
//  Created by Tejas on 15/10/17.
//  Copyright © 2017 Gajjar Tejas. All rights reserved.
//

import UIKit
import Photos

open class SMDMedia: NSObject {
    
    /// The value for this key is an NSString object containing a type code such as kUTTypeImage or kUTTypeMovie.(UIImagePickerControllerMediaType)
    public var mediaType: String?
    
    /// The value for this key is a UIImage object.(UIImagePickerControllerOriginalImage)
    public var originalImage: UIImage?
    
    /// The value of this key is a NSURL that you can use to retrieve the image file. The image in this file matches the image found in the UIImagePickerControllerOriginalImage key of the dictionary.(UIImagePickerControllerImageURL)
    public var imageURL: NSURL?
    
    /// The value for this key is a UIImage object.(UIImagePickerControllerEditedImage)
    public var editedImage: UIImage?
    
    /// The value for this key is an NSValue object containing a CGRect opaque type.(UIImagePickerControllerCropRect)
    public var cropRect: NSValue?
    
    /// The value for this key is an NSURL object.(UIImagePickerControllerMediaURL)
    public var mediaURL: NSURL?
    
    /// This key is valid only when using an image picker whose source type is set to camera, and applies only to still images. The value for this key is an NSDictionary object that contains the metadata of the photo that was just captured.(UIImagePickerControllerMediaMetadata)
    public var metadata: NSDictionary?
    
    // TODO: Handel for iOS 9
    /// When the user picks or captures a Live Photo, the editingInfo dictionary contains the UIImagePickerControllerLivePhoto key, with a PHLivePhoto representation of the photo as the corresponding value.(UIImagePickerControllerLivePhoto)
    //var livePhoto: PHLivePhoto?
    
    /// The value of this key is a PHAsset object.(UIImagePickerControllerPHAsset)
    public var phAsset: PHAsset?
    
    init(fromDictionary dictionary: [String:Any]) {
        
        mediaType = dictionary[UIImagePickerControllerMediaType] as? String
        
        originalImage = dictionary[UIImagePickerControllerOriginalImage] as? UIImage
        
        if #available(iOS 11.0, *) {
            imageURL = dictionary[UIImagePickerControllerImageURL] as? NSURL
        } else {
            // Fallback on earlier versions
        }
        
        editedImage = dictionary[UIImagePickerControllerEditedImage] as? UIImage
        
        cropRect = dictionary[UIImagePickerControllerCropRect] as? NSValue
        
        mediaURL = dictionary[UIImagePickerControllerMediaURL] as? NSURL
        
        metadata = dictionary[UIImagePickerControllerMediaMetadata] as? NSDictionary
        
        if #available(iOS 11.0, *) {
            phAsset = dictionary[UIImagePickerControllerPHAsset] as? PHAsset
        } else {
            // Fallback on earlier versions
        }
    }
}

extension SMDMedia {
    
    public var videoThumb: UIImage? {
     
        get {
            
            guard let url = mediaURL else {
                return nil
            }
            
            let videoThumb = getThumbnailFrom(path: url as URL)
            
            return videoThumb
            
        }
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
            
        }
        
    }
}
