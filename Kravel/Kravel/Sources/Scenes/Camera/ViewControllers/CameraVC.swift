//
//  CameraVC.swift
//  Kravel
//
//  Created by 윤동민 on 2020/08/29.
//  Copyright © 2020 윤동민. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraPosition {
    case front
    case rear
}

class CameraVC: UIViewController {
    static let identifier = "CameraVC"
    
    // MARK: - AVFoundation 이용 Camera 설정
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraDevice: AVCaptureDevice?
    var cameraOutput: AVCapturePhotoOutput?
    
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
    private func addCaptureButton() {
        self.view.addSubview(captureOutlineImageView)
        self.view.addSubview(captureInlineImageView)
        self.view.addSubview(captureButton)
    }
    
    private func addButtonAction() {
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
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        cameraOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - 찍은 사진 보여주는 ImageView 설정
    let sampleImageView: UIImageView = {
        let sampleImageView = UIImageView(image: UIImage(named: "yuna"))
        sampleImageView.translatesAutoresizingMaskIntoConstraints = false
        sampleImageView.contentMode = .scaleAspectFill
        sampleImageView.clipsToBounds = true
        return sampleImageView
    }()
    
    private func setTakePictureImageViewLayout() {
        NSLayoutConstraint.activate([
            sampleImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            sampleImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            sampleImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.17),
            sampleImageView.heightAnchor.constraint(equalTo: sampleImageView.widthAnchor)
        ])
    }
    
    private func addSampleImageView() {
        self.view.addSubview(sampleImageView)
    }
    
    // MARK: - UIViewController viewDidLoad 설정
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCameraDevice()
        initCameraInputData()
        initCameraOutputData()
        displayPreview()
        addCaptureButton()
        addButtonAction()
        addSampleImageView()
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
        setTakePictureImageViewLayout()
    }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        sampleImageView.image = UIImage(data: imageData)
    }
}
