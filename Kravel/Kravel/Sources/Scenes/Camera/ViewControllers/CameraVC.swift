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
            // FIXME: 카메라 설정창으로 가서 카메라 허용할 수 있게 설정하는 화면 뜨게 하기
            guard let authorizationVC = UIStoryboard(name: "AuthorizationPopup", bundle: nil).instantiateViewController(withIdentifier: AuthorizationPopupVC.identifier) as? AuthorizationPopupVC else { return }
            authorizationVC.setAuthorType(author: .camera)
            authorizationVC.modalPresentationStyle = .overFullScreen
            self.present(authorizationVC, animated: false) {
                self.dismiss(animated: false, completion: nil)
            }
        case .denied:
            // FIXME: 카메라 설정창으로 가서 카메라 허용할 수 있게 설장하는 화면 뜨게 하기
            guard let authorizationVC = UIStoryboard(name: "AuthorizationPopup", bundle: nil).instantiateViewController(withIdentifier: AuthorizationPopupVC.identifier) as? AuthorizationPopupVC else { return }
            authorizationVC.setAuthorType(author: .camera)
            authorizationVC.modalPresentationStyle = .overFullScreen
            self.present(authorizationVC, animated: false)
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
    let galleryImageView: UIImageView = {
        // FIXME: 여기 갤러리 제일 마지막 사진 보이게 수정
        let galleryImageView = UIImageView()
        galleryImageView.translatesAutoresizingMaskIntoConstraints = false
        galleryImageView.contentMode = .scaleAspectFill
        galleryImageView.clipsToBounds = true
        return galleryImageView
    }()
    
    private func setGalleryImageViewLayout() {
        NSLayoutConstraint.activate([
            galleryImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            galleryImageView.bottomAnchor.constraint(equalTo: galleryDescriptionLabel.topAnchor, constant: -4),
            galleryImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.112),
            galleryImageView.heightAnchor.constraint(equalTo: galleryImageView.widthAnchor)
        ])
        galleryImageView.layer.cornerRadius = galleryImageView.frame.width / 20
    }
    
    private func requestPhotoLibraryAuthor() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            // FIXME: 첫번째 Photo Library 사진 가져오도록 수정
            setPhotoLibraryImage()
            PHPhotoLibrary.shared().register(self)
        case .notDetermined:
            galleryImageView.image = UIImage(named: ImageKey.noGallery)
        case .restricted:
            galleryImageView.image = UIImage(named: ImageKey.noGallery)
        case .denied:
            galleryImageView.image = UIImage(named: ImageKey.noGallery)
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
            ImageManager.shared.requestImage(from: photo, thumnailSize: galleryImageView.frame.size) { image in
                DispatchQueue.main.async {
                    self.galleryImageView.image = image
                }
            }
        } else {
            // FIXME: 만약 사진 앨범 빈 경우 빈 이미지 넣게 설정
            self.galleryImageView.image = UIImage(named: ImageKey.btnLike)
        }
    }
    
    // MARK: - 갤러리 사진 알려주는 설명 Label 설정
    let galleryDescriptionLabel: UILabel = {
        let galleryDescriptionLabel = UILabel()
        galleryDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        galleryDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        galleryDescriptionLabel.textColor = .white
        galleryDescriptionLabel.text = "갤러리"
        return galleryDescriptionLabel
    }()
    
    private func setGalleryDescriptionLabelLayout() {
        NSLayoutConstraint.activate([
            galleryDescriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            galleryDescriptionLabel.centerXAnchor.constraint(equalTo: galleryImageView.centerXAnchor)
        ])
    }
    
    // MARK: - 샘플 사진 보여주는 ImageView 설정
    let sampleImageView: UIImageView = {
        let sampleImageView = UIImageView()
        sampleImageView.translatesAutoresizingMaskIntoConstraints = false
        sampleImageView.contentMode = .scaleAspectFill
        sampleImageView.clipsToBounds = true
        return sampleImageView
    }()
    
    private func setSampleImageViewLayout() {
        NSLayoutConstraint.activate([
            sampleImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            sampleImageView.bottomAnchor.constraint(equalTo: sampleDescriptionLabel.topAnchor, constant: -4),
            sampleImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.112),
            sampleImageView.heightAnchor.constraint(equalTo: sampleImageView.widthAnchor)
        ])
        sampleImageView.layer.cornerRadius = sampleImageView.frame.width / 20
    }
    
    // MARK: - 샘플 사진 알려주는 설명 Label 설정
    let sampleDescriptionLabel: UILabel = {
        let sampleDescriptionLabel = UILabel()
        sampleDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sampleDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        sampleDescriptionLabel.textColor = .white
        sampleDescriptionLabel.text = "예시"
        return sampleDescriptionLabel
    }()
    
    private func setSampleDesctiptionLabelLayout() {
        NSLayoutConstraint.activate([
            sampleDescriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sampleDescriptionLabel.centerXAnchor.constraint(equalTo: sampleImageView.centerXAnchor)
        ])
    }
    
    private func addImageView() {
        self.view.addSubview(galleryImageView)
        self.view.addSubview(galleryDescriptionLabel)
        self.view.addSubview(sampleImageView)
        self.view.addSubview(sampleDescriptionLabel)
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestCameraAuthor()
        requestPhotoLibraryAuthor()
        setCaptureButton()
        setCancelButton()
        addImageView()
        addObserver()
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

extension CameraVC {
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(popByNotAllowed), name: .dismissAuthorPopupView, object: nil)
    }
    
    @objc func popByNotAllowed() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges({
                let creationRequest = PHAssetCreationRequest.forAsset()
                guard let photoData = photo.fileDataRepresentation() else { return }
                creationRequest.addResource(with: .photo, data: photoData, options: nil)
            }, completionHandler: { isCompletion, error in
                guard error == nil else { return }
                if isCompletion {
                    guard let imageData = photo.fileDataRepresentation() else { return }
                    DispatchQueue.main.async {
                        self.galleryImageView.image = UIImage(data: imageData)
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
