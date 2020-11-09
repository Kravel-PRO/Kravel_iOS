# Kravel
<br>

### Work Flow

![screen1](./images/workflow.png)

<br>

---

### Convention

* **[Kravel Convention](/docs/Convention.md)**

<br>

---

### 개발 환경

* **Xcode Version 12.1**
* **Swift 5**

<br>

---

### 라이브러리

* **Alamofire 5.2**
* **NMapsMap**
* **lottie-ios**
* **Kingfisher 5.0**

<br>

---

### 실행화면

> **홈 화면**

<img src="./images/Home1.png" width="200px" align="center"><img src="./images/Home2.png" width="200px" align="center">

<br>

> **검색 화면**

<img src="./images/search1.png" width="200px" align="center"><img src="./images/search2.png" width=200px align="center">

<br>

> **최근 검색어 화면**

<img src="./images/recentsearch.png" width="200px" align="center">

<br>

> **지도 화면**

<img src="./images/map1.png" width="200px" align="center"><img src="./images/map2.png" width="200px" align="center"><img src="./images/map3.png" width="200px" align="center">

<br>

> **카메라 화면**

<img src="./images/camera.png" width="200px" align="center">

<br>

---

### 📕 새롭게 알게 된 것

<br>

**1️⃣ Cell에 Shadow + CornerRadius 같이 적용하기**

```swift
// 우선 Shadow을 지정하기 위해선 clipsToBounds 설정이 false여야한다.
// 그러나 CornerRadius을 위해선 clipsToBounds 설정이 true여야한다.
// 여기서 서로 다르기 때문에 Cell에 동시에 지정하기 위해 ContentView을 활용한다.
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  guard let nearPlaceCell = collectionView.dequeueReusableCell(withReuseIdentifier: NearPlaceCell.identifier, for: indexPath) as? NearPlaceCell else { return UICollectionViewCell() }
  
  // 내용을 표시하기 위한 View의 layer을 둥글게 만들어 표시
  nearPlaceCell.contentView.layer.cornerRadius = nearPlaceCell.contentView.frame.width / 49.6
  nearPlaceCell.contentView.clipsToBounds = true
  
  // 그림자 효과를 위해 바깥 Cell에 Shadow 표시
  nearPlaceCell.makeShadow(color: UIColor.black, blur: 10, x: 3, y: 2)
  nearPlaceCell.clipsToBounds = false
  
  return nearPlaceCell
}
```

<br>

**2️⃣ `Alamofire` 4.8 Version만 사용하다가 `Alamofire` 5.2 Version의 사용법**

```swift
// validate을 통해서 처리하지 않는 statusCode가 날라올 경우 failure 처리를 한다.
// responseDecodable을 통해 통신에 성공한 경우 개발자가 별도의 Decoding 처리 없이 Decoding된 데이터를 받을 수 있다.
func requestSignup(_ url: String, _ headers: HTTPHeaders?, _ parameters: Parameters?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
  guard let url = try? url.asURL() else { return }
  
  AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
  	.validate(statusCode: 200...500)
  	.responseDecodable(of: APIResponseData<APICantSortableDataResult<SignupResponse>, APIError>.self) {
      response in
      switch response.result {
        case .sucess(let signupResponse):
        	guard let statusCode = response.response?.statusCode else { return }
        	completion(.success(signupResponse))
        case .failure:
        	completion(.networkFail)
      }
    }
}
```

<br>

**3️⃣ `Core Data` 사용해서 데이터 저장하기**

[Core Data 정리 블로그 작성 (1/2)](https://dongminyoon.tistory.com/3?category=419821)

[Core Data 정리 블로그 작성 (2/2)](https://dongminyoon.tistory.com/6?category=419821)

<br>

**4️⃣ `AVFoundation` 이용 Custom Camera 구현**

```swift
import AVFoundation

class CameraVC: UIViewController {
  var captureSession = AVCaptureSession()
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var cemeraDevice: AVCaptureDevice?
  var cameraOutput: AVCapturePhotoOutput?
  
  private func configureCameraDevice() {
    guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { 
      print("Failed to get the camera device")
    	return
    }
    
    cameraDevice = captureDevice
  }
  
  private func configureInputData() {
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
  
  private func configureCameraOutputData() {
    cameraOutput = AVCapturePhotoOutput()
    if let cameraOutput = self.cameraOutput {
      if captureSession.canAddOutput(cameraOutput) { captureSession.addOutput(cameraOutput) }
    }
  }
  
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
  
  private func setCameraView() {
    configureCameraDevice()
    configureInputData()
    configureCameraOutputData()
    configureCameraOutputData()
    displayPreview()
  }
}
```

<br>

**5️⃣ API 요청 GET 메소드 사용시 Query문 사용하기**

```swift
// Get Method의 경우 Query문을 작성할 수 있다.
// URLEncoding.queryString을 활용해 parameter을 Query로 디코딩 할 수 있다.
private func requestSearchPlace(_ url: String, _ headers: HTTPHeaders?, _ completion: @escaping (NetworkResult<Codable>) -> Void) {
  guard let url = try? url.asURL() else { return }
  
  let query = [
    "page": 1,
    "offset": 2
  ]
  
  AF.request(url, method: .get, parameters: query, encoding: URLEncoding.queryString, headers: headers)
  	.validate(statusCode: 200...500)
  	.responseDecodable(of: SearchPlaceResponse) {
      response in
      switch response.result {
			case .success(let placeResult):
        guard let statusCode = response.response?.statusCode else { return }
        if statusCode == 200 { completion(.success(placeResult)) }
				else { completion(.networkFail) }
     	case .failure(let error):
				print(error.localizedDescription)
        completion(.networkFail)
      }
    }
}
```

<br>

**6️⃣ ScrollView 사용시 또 다른 Pan Gesture 사용하고 싶을 때 설정하기**

```swift
// 원래의 경우엔 ScrollView의 기본 Pan Gesture이 지정되어 있기 때문에,
// 또 다른 Pan Gesture을 지정해도 작동되지 않는다.
// 이 경우에 작동하고 싶을 경우, UIGestureRecognizerDelegate을 활용해서 같이 지정할 수 있다.

// 내려서 화면을 종료하고 싶으면서, Scroll도 별도로 내려가게 하기 위해 작성했다.
extension LocationDetailVC: UIGestureRecognizerDelegate {
  func addGesture() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(somthing(_:)))
    panGesture.delegate = self
    contentScrollView.addGestureRecognizer(panGesture)
  }
  
  // 이 설정으로 동시에 두 가지의 Pan Gesture가 사용 가능하다.
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
```

<br>

**7️⃣ TableView Pagination 구현**

```swift

```

<br>

**8️⃣ 다크 모드 지원 막기**

```swift
// SceneDelegated에 구현하기
if #available(iOS 13.0, *) {
  self.window?.overrideUserInterfaceStyle = .light
}
```

<br>

**9️⃣ CollectionView Paging 구현**

> **블로그 작성 예정**

<br>

**🔟 ScrollView 당겨서 새로고침 구현**

```swift
@IBOutlet weak var contentScrollView: UIScrollView! {
  didSet {
    contentScrollView.delegate = self
  }
}

private func setRefreshView() {
  let refreshControl = UIRefreshControl()
  refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
  contentScrollView.refreshControl = refreshControl
}

@objc private func reload() {
  print("Reload 데이터 설정")
  // 설정이 끝난 후, Refresh 끝내기
  contentScrollView.refreshControl?.endRefreshing()
}
```

