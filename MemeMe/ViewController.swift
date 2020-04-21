//
//  ViewController.swift
//  MemeMe
//
//  Created by Patrick Groß on 21.04.20.
//  Copyright © 2020 Patrick Groß. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	
	let imagePicker = UIImagePickerController()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
	}

	@IBAction func pickPicture(_ sender: UIBarButtonItem) {
		
		
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.mediaTypes = ["public.image"]
		imagePicker.sourceType = .photoLibrary
		
		present(imagePicker, animated: true, completion: nil)
		
	}
	
	@IBAction func takePhoto(_ sender: Any) {
		
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.mediaTypes = ["public.image"]
		imagePicker.sourceType = .camera
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		  if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			   imageView.contentMode = .scaleAspectFit
			   imageView.image = pickedImage
		   }
		
		   dismiss(animated: true, completion: nil)
	}
}


