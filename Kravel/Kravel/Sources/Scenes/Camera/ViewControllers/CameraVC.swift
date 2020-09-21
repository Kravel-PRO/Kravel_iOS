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
    
    var placeId: Int?
    
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
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        if let picker = self.picker {
                            picker.sourceType = .photoLibrary
                            self.present(picker, animated: true, completion: nil)
                        }
                    }
                case .notDetermined: return
                case .restricted: return
                case .denied: return
                case .limited: return
                @unknown default: return
                }
            }
        case .restricted:
            presentPopupVC(by: "Gallery")
        case .denied:
            presentPopupVC(by: "Gallery")
        case .limited:
            return
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
            setCameraView()
            DispatchQueue.main.async {
                self.setCameraLayout()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setCameraView()
                        DispatchQueue.main.async {
                            self.setCameraLayout()
                        }
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
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
        DispatchQueue.main.async {
            self.videoPreviewLayer?.frame = self.view.layer.bounds
            self.view.layer.addSublayer(self.videoPreviewLayer!)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    // 카메라 총합적으로 설정하기
    private func setCameraView() {
        initCameraDevice()
        initCameraInputData()
        initCameraOutputData()
        displayPreview()
    }
    
    // 카메라에 대한 기능 UI 요소 추가
    private func setCameraLayout() {
        setCaptureButton()
        setGalleryButton()
        setSampleImageButton()
        setCancelButton()
        setDescriptionLabel()
        setCaptureButtonLayout()
        setCancelButtonLayout()
        setGalleryImageViewLayout()
        setGalleryDescriptionLabelLayout()
        setSampleImageViewLayout()
        setSampleDesctiptionLabelLayout()
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
//        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
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
        self.view.bringSubviewToFront(captureOutlineImageView)
        self.view.bringSubviewToFront(captureInlineImageView)
        self.view.bringSubviewToFront(captureButton)
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
        self.view.bringSubviewToFront(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
    }
    
    @objc func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 갤러리 사진 보여주는 ImageView 설정
    let galleryButton: UIButton = {
        // FIXME: 여기 갤러리 제일 마지막 사진 보이게 수정
        let galleryButton = UIButton()
        galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        galleryButton.contentMode = .scaleAspectFit
        galleryButton.clipsToBounds = true
        return galleryButton
    }()
    
    private func setGalleryButton() {
        self.view.addSubview(galleryButton)
        self.view.bringSubviewToFront(galleryButton)
        galleryButton.addTarget(self, action: #selector(openLibrary), for: .touchUpInside)
    }
    
    private func setGalleryImageViewLayout() {
        NSLayoutConstraint.activate([
            galleryButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            galleryButton.bottomAnchor.constraint(equalTo: galleryDescriptionLabel.topAnchor, constant: -4),
            galleryButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.112),
            galleryButton.heightAnchor.constraint(equalTo: galleryButton.widthAnchor)
        ])
        galleryButton.layer.cornerRadius = self.view.frame.width * 0.112 / 6
    }
    
    private func requestPhotoLibraryAuthor() {
        DispatchQueue.main.async {
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                self.setPhotoLibraryImage()
                DispatchQueue.main.async {
                    self.setPickerController()
                }
                PHPhotoLibrary.shared().register(self)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    switch status {
                    case .authorized:
                        self.setPhotoLibraryImage()
                        DispatchQueue.main.async {
                            self.setPickerController()
                        }
                        PHPhotoLibrary.shared().register(self)
                    case .notDetermined:
                        DispatchQueue.main.async {
                            self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
                        }
                    case .restricted:
                        DispatchQueue.main.async {
                            self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
                        }
                    case .denied:
                        DispatchQueue.main.async {
                            self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
                        }
                    @unknown default:
                        break
                    }
                }
            case .restricted:
                self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
            case .denied:
                self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
            case .limited:
                self.galleryButton.setImage(UIImage(named: ImageKey.noGallery), for: .normal)
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func setPhotoLibraryImage() {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 1
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchPhotos = PHAsset.fetchAssets(with: fetchOption)
        if let photo = fetchPhotos.firstObject {
            DispatchQueue.main.async {
                ImageManager.shared.requestImage(from: photo, thumnailSize: self.galleryButton.frame.size) { image in
                    DispatchQueue.main.async {
                        self.galleryButton.setImage(image, for: .normal)
                    }
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
    
    // MARK: - 필터 CollectionView 구현
    var filterCollectionView: UICollectionView?
    
    // MARK: - 샘플 사진 보여주는 ImageView 설정
    let sampleImageButton: UIButton = {
        let sampleImageButton = UIButton()
        sampleImageButton.translatesAutoresizingMaskIntoConstraints = false
        sampleImageButton.layer.borderColor = UIColor.white.cgColor
        sampleImageButton.layer.borderWidth = 1
        sampleImageButton.clipsToBounds = true
        sampleImageButton.isHidden = true
        return sampleImageButton
    }()
    
    private func setSampleImageButton() {
        self.view.addSubview(sampleImageButton)
        self.view.bringSubviewToFront(sampleImageButton)
        sampleImageButton.addTarget(self, action: #selector(showSampleImage), for: .touchUpInside)
    }
    
    @objc func showSampleImage() {
        if let buttonImage = sampleImageButton.currentImage { presentPhotoView(buttonImage) }
    }
    
    private func setSampleImageViewLayout() {
        NSLayoutConstraint.activate([
            sampleImageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            sampleImageButton.bottomAnchor.constraint(equalTo: sampleDescriptionLabel.topAnchor, constant: -4),
            sampleImageButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.112),
            sampleImageButton.heightAnchor.constraint(equalTo: sampleImageButton.widthAnchor)
        ])
        sampleImageButton.layer.cornerRadius = self.view.frame.width * 0.112 / 6
    }
    
    // MARK: - 샘플 사진 알려주는 설명 Label 설정
    let sampleDescriptionLabel: UILabel = {
        let sampleDescriptionLabel = UILabel()
        sampleDescriptionLabel.isHidden = true
        sampleDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        sampleDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        sampleDescriptionLabel.textColor = .white
        sampleDescriptionLabel.text = "예시".localized
        return sampleDescriptionLabel
    }()
    
    private func setSampleDesctiptionLabelLayout() {
        NSLayoutConstraint.activate([
            sampleDescriptionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sampleDescriptionLabel.centerXAnchor.constraint(equalTo: sampleImageButton.centerXAnchor)
        ])
    }
    
    private func setDescriptionLabel() {
        self.view.addSubview(galleryDescriptionLabel)
        self.view.addSubview(sampleDescriptionLabel)
        self.view.bringSubviewToFront(galleryDescriptionLabel)
        self.view.bringSubviewToFront(sampleDescriptionLabel)
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestCameraAuthor()
        requestPhotoLibraryAuthor()
        if let placeId = self.placeId { requestDetailInform(of: placeId) }
    }
    
    // MARK: - UIViewController viewWillAppear 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
    
    private func setNav() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - UIViewController viewWillDisappear override 설정
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UIViewController viewDidDisappear override 설정
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
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
        guard let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        
        photoContainerView = UIView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.frame.width, height: self.view.frame.height))
        guard let photoContainerView = self.photoContainerView else { return }
        photoContainerView.clipsToBounds = true
        photoContainerView.translatesAutoresizingMaskIntoConstraints = false
        photoContainerView.backgroundColor = .black
        
        let cancelButton = UIButton()
        cancelButton.setImage(UIImage(named: ImageKey.btnCancelWhite), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissPhotoView(_:)), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let photoImageView = UIImageView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: self.view.frame.width, height: self.view.frame.height))
        photoImageView.clipsToBounds = true
        photoImageView.image = image
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        keyWindow.addSubview(photoContainerView)
        photoContainerView.addSubview(photoImageView)
        photoContainerView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            photoContainerView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
            photoContainerView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
            photoContainerView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
            photoContainerView.topAnchor.constraint(equalTo: keyWindow.topAnchor),
            cancelButton.topAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cancelButton.widthAnchor.constraint(equalTo: keyWindow.widthAnchor, multiplier: 0.1),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 1)
        ])
        
        photoContainerView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.2) {
            photoContainerView.transform = .identity
        }
        
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: photoContainerView.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: photoContainerView.centerYAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: photoContainerView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoContainerView.heightAnchor)
        ])
    }
    
    @objc func dismissPhotoView(_ sender: Any) {
        self.photoContainerView?.removeFromSuperview()
    }
}

extension CameraVC {
    // MARK: - 장소 디테일 API 요청
    private func requestDetailInform(of placeId: Int) {
        NetworkHandler.shared.requestAPI(apiCategory: .getPlaceOfID(placeId)) { result in
            switch result {
            case .success(let detailInform):
                guard let detailInform = detailInform as? PlaceDetailInform else { return }
                DispatchQueue.main.async {
                    self.setFilterByImage(detailInform.subImageUrl, detailInform.filterImageUrl)
                }
            case .requestErr:
                break
            case .serverErr:
                print("Server Error")
            case .networkFail:
                guard let networkFailPopupVC = UIStoryboard(name: "NetworkFailPopup", bundle: nil).instantiateViewController(withIdentifier: NetworkFailPopupVC.identifier) as? NetworkFailPopupVC else { return }
                networkFailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(networkFailPopupVC, animated: false, completion: nil)
            }
        }
    }
    
    private func setFilterByImage(_ subImageUrl: String?, _ filterImageUrl: String?) {
        guard let subImageUrl = subImageUrl,
              let filterImageUrl = filterImageUrl else { return }
        
        let tempImageView = UIImageView()
        tempImageView.setImage(with: subImageUrl) { successImage in
            self.sampleImageButton.setImage(successImage, for: .normal)
            self.sampleImageButton.isHidden = false
            self.sampleDescriptionLabel.isHidden = false
        }
        
        initFilterView()
    }
    
    private func initFilterView() {
        let cellWidth: CGFloat = self.view.frame.width / 5.6
        let cellHeight: CGFloat = 26
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: self.view.frame.width/2 - cellWidth/2, bottom: 0, right: self.view.frame.width/2 - cellWidth/2)
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 7
        
        filterCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 26), collectionViewLayout: collectionViewLayout)
        
        guard let filterCollectionView = self.filterCollectionView else { return }
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        filterCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(filterCollectionView)
        NSLayoutConstraint.activate([
            filterCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            filterCollectionView.bottomAnchor.constraint(equalTo: captureOutlineImageView.topAnchor, constant: -36),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
    }
}

extension CameraVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell else { return UICollectionViewCell() }
        filterCell.layer.cornerRadius = filterCell.frame.width / 5.28
        filterCell.clipsToBounds = true
        filterCell.filterName = "기생충"
        return filterCell
    }
}

extension CameraVC: UICollectionViewDelegate {
}
