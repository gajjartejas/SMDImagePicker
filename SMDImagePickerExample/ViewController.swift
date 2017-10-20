//
//  ViewController.swift
//  SMDImagePickerExample
//
//  Created by Tejas on 6/25/17.
//  Copyright © 2017 Gajjar Tejas. All rights reserved.
//

import UIKit
import SMDImagePicker
import MobileCoreServices
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    let imagePicker = SMDImagePicker()
    var videoUrl: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isHidden = true
    }
    
    @IBAction func pickTapped(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: "Choose", preferredStyle: .actionSheet)
        actionsheet.popoverPresentationController?.sourceView  = self.playButton
        let capturePhotoAction = UIAlertAction(title: "Capture Photo", style: .default) { (_) in
            self.capturePhotoAction()
        }
        
        let recordVideoAction = UIAlertAction(title: "Record Video", style: .default) { (_) in
            self.recordVideoAction()
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose Photo from Gallary", style: .default) { (_) in
            self.choosePhotoAction()
        }
        
        let chooseVideoAction = UIAlertAction(title: "Choose Video from Gallary", style: .default) { (_) in
            self.chooseVideoAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        actionsheet.addAction(capturePhotoAction)
        actionsheet.addAction(recordVideoAction)
        actionsheet.addAction(choosePhotoAction)
        actionsheet.addAction(chooseVideoAction)
        actionsheet.addAction(cancelAction)
        
        self.present(actionsheet, animated: true) {
            
        }
    }
    
    func capturePhotoAction() {
        
        playButton.isHidden = true
        //Optional
        let options =  SMDImagePicker.PhotoCaptureOptions(allowsEditing: true,
                                                          cameraDevice: .rear,
                                                          mediaTypes: [kUTTypeImage as String],
                                                          flashMode: .auto)
        imagePicker.configure(options)
        
        imagePicker.capture(media: .takePhoto, presentFrom: self) { (media, status) in
            if status == .success {
                self.imageView.image = media?.editedImage
                self.playButton.isHidden = true
            } else {
                
                switch status {
                    
                case .cameraNotAvailable:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                case.canceled:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                default:
                    SMDImagePicker.showTips(at: self, message: status.description())
                }
            }
        }
    }
    
    func recordVideoAction() {
        
        //Optional
        let options = SMDImagePicker.VideoRecorderOptions(allowsEditing: true,
                                                          cameraDevice: .rear,
                                                          maximumDuration: 2*60, //Duration 2 Minutes
                                                          quality: .typeHigh,
                                                          flashMode: .auto)
        
        imagePicker.configure(options)
        
        imagePicker.capture(media: .takeVideo, presentFrom: self) { (media, status) in
            if status == .success {
                let thumb = media?.videoThumb
                
                self.imageView.image = thumb
                self.videoUrl = media!.mediaURL! as URL
                self.playButton.isHidden = false
                
            } else {
                
                switch status {
                    
                case .cameraNotAvailable:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                case.canceled:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                default:
                    SMDImagePicker.showTips(at: self, message: status.description())
                }
            }
        }
    }
    
    func choosePhotoAction() {
        
        //Optional
        let options = SMDImagePicker.PhotoGallaryOptions(allowsEditing: true,
                                                         mediaTypes: [kUTTypeImage as String])
        imagePicker.configure(options)
        
        imagePicker.ipadOptions = SMDImagePicker.IPadOptions()
        imagePicker.ipadOptions.sourceView = self.playButton
        imagePicker.choose(media: .choosePhoto, presentFrom: self) { (media, status) in
            if status == .success {
                self.imageView.image = media?.editedImage
                self.playButton.isHidden = true
            } else {
                
                switch status {
                    
                case .cameraNotAvailable:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                case .canceled:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                case .denied,.restricted:
                    SMDImagePicker.showTips(at: self, type: SMDImagePicker.SMDMediaType.choosePhoto)
                    break
                    
                default:
                    SMDImagePicker.showTips(at: self, message: status.description())
                }
                
            }
        }
    }
    
    func chooseVideoAction() {
        
        //Optional
        let options = SMDImagePicker.VideoGallaryOptions(allowsEditing: false,
                                                         mediaTypes: [kUTTypeMovie as String],
                                                         maximumDuration: 2*60, //Duration 2 Minutes
            
            quality: UIImagePickerControllerQualityType.typeMedium)
        imagePicker.configure(options)
        
        imagePicker.choose(media: .chooseVideo, presentFrom: self) { (media, status) in
            if status == .success {
                
                let thumb = media?.videoThumb
                
                self.imageView.image = thumb
                self.videoUrl = media!.mediaURL! as URL
                self.playButton.isHidden = false
                
            } else {
                
                switch status {
                    
                case .cameraNotAvailable:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                case.canceled:
                    SMDImagePicker.showTips(at: self, message: status.description())
                    break
                    
                default:
                    SMDImagePicker.showTips(at: self, message: status.description())
                }
            }
        }
    }
    
    @IBAction func playAction(_ sender: UIButton, forEvent event: UIEvent) {
        let player = AVPlayer(url: videoUrl!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true) {
            player.play()
        }
    }
}
