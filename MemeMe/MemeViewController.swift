//
//  ViewController.swift
//  MemeMe
//
//  Created by Patrick Groß on 21.04.20.
//  Copyright © 2020 Patrick Groß. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	let imagePicker = UIImagePickerController()
	
	let memeTextAttributes: [NSAttributedString.Key: Any] = [
		NSAttributedString.Key.strokeColor: UIColor.black,
		NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSAttributedString.Key.strokeWidth:  1.5
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		//MARK: Set up all text attributes
		topTextField.delegate = self
		topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.textAlignment = .center

		bottomTextField.delegate = self
		bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.textAlignment = .center
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	// MARK: Open the Picture Roll
	@IBAction func pickPicture(_ sender: UIBarButtonItem) {
		
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		imagePicker.mediaTypes = ["public.image"]
		imagePicker.sourceType = .photoLibrary
		
		present(imagePicker, animated: true, completion: nil)
		
	}
	
	// MARK: Open the camera if is available
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
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.placeholder = ""
		
		if textField == bottomTextField {
			subscribeToKeyboardNotifications()
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == bottomTextField {
			unsubscribeFromKeyboardNotifications()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {

		view.frame.origin.y = -getKeyboardHeight(notification)
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}


