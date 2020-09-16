//
//  CameraVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraVC: UIViewController {
    static let identifier = "CameraVC"
    
    // MARK: - UIImagePickerController 설정
    private var picker: UIImagePickerController?
    private var photoContainerView: UIView?
    
    private func setPickerController() {
        picker = UIImagePickerController()
        picker?.delegate = self
    }
    
    @objc func openLibrary() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            if let picker = self.picker {
                picker.sourceType = .photoLibrary
                present(picker, animated: true, completion: nil)
            }
        case .notDetermined:
            presentPopupVC(by: "Gallery")
        case .restricted:
            presentPopupVC(by: "Gallery")
        case .denied:
            presentPopupVC(by: "Gallery")
        @unknown default:
            return
        }
    }
    
    // MARK: - AVFoundation 이용 Camera 설정
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraDevice: AVCaptureDevice?
    var cameraOutput: AVCapturePhotoOutput?
    
    // 카메라 권한 허용하는 작업
    private func requestCameraAuthor() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            initCameraDevice()
            initCameraInputData()
            initCameraOutputData()
            displayPreview()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.initCameraDevice()
                    self.initCameraInputData()
                    self.initCameraOutputData()
                    self.displayPreview()
                } else {
                    // FIXME: 카메라 설정창으로 가서 카메라 허용할 수 있게 설정하는 화면 뜨게 하기
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case .restricted:
            presentPopupVC(by: "Camera")
        case .denied:
            presentPopupVC(by: "Camera")
        @unknown default:
            fatalError()
        }
    }
    
    // 카메라 장치 설정 - 뒷면으로 설정
    private func initCameraDevice() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        cameraDevice = captureDevice
    }

    // 카메라 Input 설정
    private func initCameraInputData() {
        if let cameraDevice = self.cameraDevice {
            do {
                let input = try AVCaptureDeviceInput(device: cameraDevice)
                if captureSession.canAddInput(input) { captureSession.addInput(input) }
            } catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    // 카메라 Output 설정 - Photo
    private func initCameraOutputData() {
        cameraOutput = AVCapturePhotoOutput()
        if let cameraOutput = self.cameraOutput {
            if captureSession.canAddOutput(cameraOutput) { captureSession.addOutput(cameraOutput) }
        }
    }
    
    // 카메라 화면 설정
    private func displayPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    // MARK: - 사진 찍는 버튼 설정
    var captureButton: UIButton = {
        let captureButton = UIButton()
        captureButton.setTitle("", for: .normal)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        return captureButton
    }()
    
    // 사진찍기 버튼 안쪽 이미지
    var captureInlineImageView: UIImageView = {
        let inlineImage = UIImage(named: ImageKey.btnPickInline)
        let captureInlineImageView = UIImageView(image: inlineImage)
        captureInlineImageView.translatesAutoresizingMaskIntoConstraints = false
        return captureInlineImageView
    }()
    
    // 사진찍기 이미지 바깥쪽 이미지
    var captureOutlineImageView: UIImageView = {
        let outlineImage = UIImage(named: ImageKey.btnPickOutline)
        let captureOutlineImageView = UIImageView(image: outlineImage)
        captureOutlineImageView.translatesAutoresizingMaskIntoConstraints = false
        return captureOutlineImageView
    }()
    
    // 사진찍기 버튼 Layout 수정
    private func setCaptureButtonLayout() {
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            captureButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.19),
            captureButton.heightAnchor.constraint(equalTo: captureButton.widthAnchor),
            captureOutlineImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            captureOutlineImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            captureOutlineImageView.widthAnchor.constraint(equalTo: captureButton.widthAnchor),
            captureOutlineImageView.heightAnchor.constraint(equalTo: captureButton.heightAnchor),
            captureInlineImageView.bottomAnchor.constraint(equalTo: captureOutlineImageView.bottomAnchor, constant: -8),
            captureInlineImageView.leadingAnchor.constraint(equalTo: captureOutlineImageView.leadingAnchor, constant: 8),
            captureInlineImageView.trailingAnchor.constraint(equalTo: captureOutlineImageView.trailingAnchor, constant: -8),
            captureInlineImageView.topAnchor.constraint(equalTo: captureOutlineImageView.topAnchor, constant: 8)
        ])
    }
    
    // 버튼 화면에 추가해주기
    private func setCaptureButton() {
        self.view.addSubview(captureOutlineImageView)
        self.view.addSubview(captureInlineImageView)
        self.view.addSubview(captureButton)
        captureButton.addTarget(self, action: #selector(takePicture(_:)), for: .touchUpInside)
    }
    
    // 사진 찍기
    @objc func takePicture(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.captureInlineImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { isCompletion in
            UIView.animate(withDuration: 0.1) {
                self.captureInlineImageView.transform = .identity
            }
        })
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        cameraOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - 이전 뷰로 돌아가기 취소 버튼
    var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("", for: .normal)
        cancelButton.setImage(UIImage(named: ImageKey.btnCancelWhite), for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private func setCancelButtonLayout() {
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.1),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1.0)
        ])
    }
    
    private func setCancelButton() {
        self.view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
    }
    
    @objc func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 갤러리 사진 보여주는 ImageView 설정
    let galleryButton: UIButton = {
        // FIXME: 여기 갤러리 제일 마지막 사진 보이게 수정
        let galleryButton = UIButton()
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        galleryButton.contentMode = .scaleAspectFit
        galleryButton.clipsToBounds = true
        return galleryButton
    }()
    
    private func setGalleryButton() {
        self.view.addSubview(galleryButton)
        galleryButton.addTarget(self, action: #selector(openLibrary), for: .touchUpInside)
    }
    
    private func setGalleryImageViewLayout() {
        NSLayoutConstraint.activate([
            galleryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            galleryButton.bottomAnchor.constraint(equalTo: galleryDescriptionLabel.topAnchor, constant: -4),
            galleryButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.112),
            galleryButton.heightAnchor.constraint(equalTo: galleryButton.widthAnchor)
        ])
        galleryButton.layer.cornerRadius = galleryButton.frame.width / 6
    }
    
    private func requestPhotoLibraryAuthor() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            // FIXME: 첫번째 Photo Library 사진 가져오도록 수정
            setPhotoLibraryImage()
            PHPhotoLibrary.shared().register(self)
        case .notDetermined:
            galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
        case .restricted:
            galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
        case .denied:
            galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
        @unknown default:
            fatalError()
        }
    }
    
    private func setPhotoLibraryImage() {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 1
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        if let photo = fetchPhotos.firstObject {
            ImageManager.shared.requestImage(from: photo, thumnailSize: galleryButton.frame.size) { image in
                DispatchQueue.main.async {
                    self.galleryButton.setImage(image, for: .normal)
                }
            }
        } else {
            self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
        }
    }
    
    // MARK: - 갤러리 사진 알려주는 설명 Label 설정
    let galleryDescriptionLabel: UILabel = {
        let galleryDescriptionLabel = UILabel()
        galleryDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        galleryDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        galleryDescriptionLabel.textColor = .white
        galleryDescriptionLabel.text = "갤러리".localized
        return galleryDescriptionLabel
    }()
    
    private func setGalleryDescriptionLabelLayout() {
        NSLayoutConstraint.activate([
            galleryDescriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            galleryDescriptionLabel.centerXAnchor.constraint(equalTo: galleryButton.centerXAnchor)
        ])
    }
    
    // FIXME: 샘플 사진 없을 시 라벨과 Image가 안뜰 수 있게 설정해야함
    // MARK: - 샘플 사진 보여주는 ImageView 설정
    let samepleImageButton: UIButton = {
        let sampleImageButton = UIButton()
        sampleImageButton.isHidden = true
        // FIXME: 임시로 지정해서 확인
        sampleImageButton.setImage(UIImage(named: ImageKey.icAccessTiger), for: .normal)
        sampleImageButton.translatesAutoresizingMaskIntoConstraints = false
        sampleImageButton.layer.borderColor = UIColor.white.cgColor
        sampleImageButton.layer.borderWidth = 1
        sampleImageButton.clipsToBounds = true
        return sampleImageButton
    }()
    
    private func setSampleImageButton() {
        self.view.addSubview(samepleImageButton)
        samepleImageButton.addTarget(self, action: #selector(showSampleImage), for: .touchUpInside)
    }
    
    @objc func showSampleImage() {
        print("여기 눌림")
    }
    
    private func setSampleImageViewLayout() {
        NSLayoutConstraint.activate([
            samepleImageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            samepleImageButton.bottomAnchor.constraint(equalTo: sampleDescriptionLabel.topAnchor, constant: -4),
            samepleImageButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.112),
            samepleImageButton.heightAnchor.constraint(equalTo: samepleImageButton.widthAnchor)
        ])
        samepleImageButton.layer.cornerRadius = samepleImageButton.frame.width / 6
    }
    
    // MARK: - 샘플 사진 알려주는 설명 Label 설정
    let sampleDescriptionLabel: UILabel = {
        let sampleDescriptionLabel = UILabel()
        sampleDescriptionLabel.isHidden = true
        // FIXME: - 고치기
        sampleDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sampleDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        sampleDescriptionLabel.textColor = .white
        sampleDescriptionLabel.text = "예시".localized
        return sampleDescriptionLabel
    }()
    
    private func setSampleDesctiptionLabelLayout() {
        NSLayoutConstraint.activate([
            sampleDescriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sampleDescriptionLabel.centerXAnchor.constraint(equalTo: samepleImageButton.centerXAnchor)
        ])
    }
    
    private func addImageView() {
        self.view.addSubview(galleryDescriptionLabel)
        self.view.addSubview(sampleDescriptionLabel)
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestCameraAuthor()
        requestPhotoLibraryAuthor()
        setPickerController()
        setCaptureButton()
        setGalleryButton()
        setSampleImageButton()
        setCancelButton()
        addImageView()
    }
    
    // MARK: - UIViewController viewWillAppear 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UIViewController viewDidDisappear override 설정
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - UIViewController viewDidLayoutSubviews override 설정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCaptureButtonLayout()
        setCancelButtonLayout()
        setGalleryImageViewLayout()
        setGalleryDescriptionLabelLayout()
        setSampleImageViewLayout()
        setSampleDesctiptionLabelLayout()
    }
}

// MARK: - 팝업 뷰 보이게 세팅
extension CameraVC {
    private func presentPopupVC(by authorType: String) {
        guard let authorizationVC = UIStoryboard(name: "AuthorizationPopup", bundle: nil).instantiateViewController(withIdentifier: AuthorizationPopupVC.identifier) as? AuthorizationPopupVC else { return }
        authorizationVC.modalPresentationStyle = .overFullScreen
        if authorType == "Camera" {
            authorizationVC.setAuthorType(author: .camera)
            authorizationVC.cancelHandler = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } else {
            authorizationVC.setAuthorType(author: .gallery)
        }
        self.present(authorizationVC, animated: false, completion: nil)
    }
}

// MARK: - 사진 촬영을 하고 난 후 이벤트 드리븐을 해주는 구간
extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                DispatchQueue.main.async {
                    self.presentPopupVC(by: "Gallery")
                }
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                guard let photoData = photo.fileDataRepresentation() else { return }
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            }, completionHandler: { isCompletion, error in
                guard error == nil else { return }
                if isCompletion {
                    // 사진 찍기를 완료했을 때, 동작하길 원하는 로직 코딩
                    guard let imageData = photo.fileDataRepresentation() else { return }
                    DispatchQueue.main.async {
                        self.galleryButton.setImage(UIImage(data: imageData), for: .normal)
                    }
                }
            })
        }
    }
}

extension CameraVC: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.setPhotoLibraryImage()
        }
    }
}

extension CameraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            self.dismiss(animated: true) {
                self.presentPhotoView(image)
                print(url)
            }
        }
    }
    
    private func presentPhotoView(_ image: UIImage) {
        photoContainerView = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0))
        guard let photoContainerView = self.photoContainerView else { return }
        photoContainerView.clipsToBounds = true
        photoContainerView.translatesAutoresizingMaskIntoConstraints = false
        photoContainerView.backgroundColor = .black
        
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: ImageKey.btnCancelWhite), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPhotoView(_:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let photoImageView = UIImageView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.frame.width, height: self.view.frame.width))
        photoImageView.clipsToBounds = true
        photoImageView.image = image
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(photoContainerView)
        photoContainerView.addSubview(cancelButton)
        photoContainerView.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photoContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            photoContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            photoContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.1),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1)
        ])
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: photoContainerView.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: photoContainerView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoContainerView.widthAnchor)
        ])
    }
    
    @objc func dismissPhotoView(_ sender: Any) {
        self.photoContainerView?.removeFromSuperview()
    }
}
