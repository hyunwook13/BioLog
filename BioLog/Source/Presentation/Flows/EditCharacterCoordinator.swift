//
//  EditCharacterCoordinator.swift
//  BioLog
//
//  Created by 이현욱 on 3/24/25.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

class EditCharacterCoordinator: Coordinator, ImagePickerDelegate {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [Coordinator] = []
    
    private let container: EditCharacterDIContainer
    private let nav: UINavigationController
    
    init(nav: UINavigationController, container: EditCharacterDIContainer) {
        self.container = container
        self.nav = nav
    }
    
    func start() {
        let actions = EditCharacterAction(addHandler: addImage,
                                          editNoteHandler: pushNote(_:))
        
        let viewController = container.makeEditCharacterViewController(action: actions)
        nav.pushViewController(viewController, animated: true)
    }
    
    private func pushNote(_ note: NoteDTO) {
        let container = container.makeEditNoteDIContainer(note: note)
        let childCoor = container.makeEditNoteCoordinator(nav: nav)
        
        self.childCoordinators.append(childCoor)
        childCoor.parentCoordinator = self
        childCoor.start()
    }
    
    func addImage() {
        let actionSheet = UIAlertController(title: "프로필 이미지 선택", message: "이미지를 선택하는 방법을 선택하세요", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라로 촬영", style: .default) { [weak self] _ in
            // 카메라 실행 로직
            self?.openImagePicker()
        }
        
        let libraryAction = UIAlertAction(title: "사진 앨범에서 선택", style: .default) { [weak self] _ in
            // 사진 앨범 실행 로직
            self?.openImagePicker()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        nav.present(actionSheet, animated: true)
    }
    
    func openImagePicker() {
        let imagePickerVC = ImagePickerViewController()
        imagePickerVC.delegate = self
        nav.present(imagePickerVC, animated: true)
    }
    
    // ImagePickerDelegate method
    func didSelectImage(_ image: UIImage) {
        // 선택된 이미지를 EditCharacterViewController로 전달
        if let editCharacterVC = nav.viewControllers.last as? EditCharacterViewController {
            editCharacterVC.updateProfileImage(image)
        }
    }
}


class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: ImagePickerDelegate?
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            delegate?.didSelectImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            delegate?.didSelectImage(originalImage)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
