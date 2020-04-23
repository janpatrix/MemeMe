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
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var toolbarImage: UIBarButtonItem!
	@IBOutlet weak var toolbarSave: UIBarButtonItem!
	@IBOutlet weak var toolbarPhoto: UIBarButtonItem!
	@IBOutlet weak var toolbarEdit: UIBarButtonItem!
	@IBOutlet weak var nextMemeButton: UIBarButtonItem!
	@IBOutlet weak var previousMemeButton: UIBarButtonItem!
	
	let imagePicker = UIImagePickerController()
	var memes: [Meme] = []
	var memeIndex = 0
	
	let memeTextAttributes: [NSAttributedString.Key: Any] = [
		NSAttributedString.Key.strokeColor: UIColor.black,
		NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSAttributedString.Key.strokeWidth:  -4.5
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		//MARK: Set up all text attributes
		topTextField.delegate = self
		topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
		topTextField.defaultTextAttributes = memeTextAttributes
		topTextField.textAlignment = .center

		bottomTextField.delegate = self
		bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
		bottomTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.textAlignment = .center
		
		toolbarPhoto.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		toolbarEdit.isEnabled = false
		toolbarSave.isEnabled = false
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
	// MARK: ACTIONS
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
	
	@IBAction func saveMeme(_ sender: UIBarButtonItem) {

		let actualImage = imageView.image
		let memedImage = generateMemedImage()
		imageView.image = generateMemedImage()
		let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, origImage: actualImage!, memedImage: memedImage)
		
		memes.append(meme)
		memeIndex = memes.count - 1
		if(memes.count >= 2) {
			previousMemeButton.isEnabled = true
		}
		changeUIControls(topTextEnabled: true, bottomTextEnabled: true, toolbarPhotoEnabled: false, toolbarSaveEnabled: false, toolbarImageEnabled: false, toolbarEditEnabled: true)
	}
	
	@IBAction func editMeme(_ sender: UIBarButtonItem) {
		let meme = memes[memeIndex]
		imageView.image = meme.origImage
		imageView.reloadInputViews()
		bottomTextField.text = meme.bottomText
		topTextField.text = meme.topText
		
		changeUIControls(topTextEnabled: false, bottomTextEnabled: false, toolbarPhotoEnabled: true, toolbarSaveEnabled: true, toolbarImageEnabled: true, toolbarEditEnabled: false)

	}
	
	@IBAction func previousMeme(_ sender: UIBarButtonItem) {
		print(memeIndex)
		if memeIndex == 0 {
			previousMemeButton.isEnabled = false
			imageView.image = memes[memeIndex].memedImage
		} else {
			memeIndex -= 1
			imageView.image = memes[memeIndex].memedImage
			if memeIndex == 0 {previousMemeButton.isEnabled = false }
			nextMemeButton.isEnabled = true
		}
	}
	
	@IBAction func nextMeme(_ sender: UIBarButtonItem) {
		if memeIndex == memes.count - 1{
			sender.isEnabled = false
			imageView.image = memes[memeIndex].memedImage
			previousMemeButton.isEnabled = true
		} else {
			memeIndex += 1
			imageView.image = memes[memeIndex].memedImage
			if memeIndex == memes.count - 1 {nextMemeButton.isEnabled = false }
			previousMemeButton.isEnabled = true
		}
	}
	
	func changeUIControls(topTextEnabled: Bool, bottomTextEnabled: Bool, toolbarPhotoEnabled: Bool, toolbarSaveEnabled: Bool, toolbarImageEnabled: Bool, toolbarEditEnabled: Bool ) {
		topTextField.isHidden = topTextEnabled
		bottomTextField.isHidden = bottomTextEnabled
		
		if toolbarPhotoEnabled {
			toolbarPhoto.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		} else {
			toolbarPhoto.isEnabled = false
		}

		toolbarSave.isEnabled = toolbarSaveEnabled
		toolbarImage.isEnabled = toolbarImageEnabled
		toolbarEdit.isEnabled = toolbarEditEnabled
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		  if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			
			imageView.contentMode = .scaleAspectFit
		    imageView.image = pickedImage
			toolbarSave.isEnabled = true
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
	
	func generateMemedImage() -> UIImage {

		toolbar.isHidden = true

		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		toolbar.isHidden = false
		
		return memedImage
	}
}


