//
//  MainViewController.swift
//  SeSACStudy
//
//  Created by SC on 2022/11/25.
//

import UIKit
import CoreLocation
import NMapsMap

final class HomeViewController: BaseViewController {
    // MARK: - Properties
    let homeView = HomeView()
//    let locationManager = CLLocationManager()
    var locationManager: CLLocationManager!
    
    // MARK: - Life Cycle
    override func loadView() {
        view = homeView
        locationManager = CLLocationManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    // initializer 지점 ....
//        locationManager = CLLocationManager()
        locationManager.delegate = self
//        locationManager = CLLocationManager()
//        locationManagerDidChangeAuthorization(locationManager)

//        print("🪙 \(UserDefaults.idToken)")
        print("🗺 locationManager: \(locationManager)")
        
        hideNavigationBar()
//        refreshIDToken()
//        checkUserDeviceLocationServiceAuthorization()
        
        setActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        showToast(message: "Main")
        
//        hideNavigationBar()
        
//        let repository = ChatRepository()
//        repository.deleteAll()
    }

    // MARK: - Setting Methods
    private func hideNavigationBar() {
//        let backButtonAppearance = UIBarButtonItemAppearance()
//        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
//
//        let appearance = UINavigationBarAppearance()
//
////        appearance.backgroundColor = .systemPink
//        appearance.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//        appearance.backButtonAppearance = backButtonAppearance
//        appearance.setBackIndicatorImage(Asset.NavigationBar.arrow.image,
//                                         transitionMaskImage: Asset.NavigationBar.arrow.image)
//
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
//        navigationController?.isNavigationBarHidden = true
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationController?.navigationBar.isHidden = true
//        print("NC: \(navigationController)")
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.scrollEdgeAppearance = nil
        navigationController?.navigationBar.compactAppearance = nil
    }
    
    private func setRegion(center: NMFCameraPosition? = nil) {
//        let cameraUpdate = NMFCameraUpdate(position: center)
        
        let campusCoordinate = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        let campusPosition = transformCoordinateToNMFCameraPosition(coordinate: campusCoordinate)
        let cameraUpdate = NMFCameraUpdate(position: campusPosition)
        homeView.naverMapView.mapView.moveCamera(cameraUpdate)
        homeView.markerImageView.isHidden = false
        
        fetchQueueState()
        fetchNearbyUsers()
    }
    
    private func setActions() {
        homeView.statusButton.addTarget(self, action: #selector(statusButtonClicked), for: .touchUpInside)
    }
    
    // MARK: - Action Methods
    @objc private func statusButtonClicked() {
//        findSesac()
//        requestStudy()
        transition(to: ChatsViewController())
    }
    
    // MARK: - Networking Methods
    private func requestStudy() {
        QueueAPIManager.requestStudy(otheruid: "eT7g1xuSfDPfGl83Id23NkvgJvx1") { [weak self] result in
            switch result {
                case .success(_):
                    print("🐣 스터디 요청 성공!")
                    self?.fetchQueueState()
                case .failure(let error):
                    if let definedError = error as? QueueAPIError {
                        print("🐥 QueueAPIError: \(definedError)")
                        if definedError == .firebaseTokenError {
                            self?.refreshIDToken {
                                self?.requestStudy()
                            }
                        }
                        return
                    }
                    
                    if let definedError = error as? QueueAPIError.RequestStudy {
                        print("🐥 QueueAPIError.Find: \(definedError)")
                    }
            }
        }
    }
    
    private func findSesac() {
        QueueAPIManager.find(latitude: 37.518607, longitude: 126.887520,
                             studyList: ["anything", "Swift"]) { [weak self] result in
            switch result {
                case .success(_):
                    print("🐣 스터디 함께할 친구 찾기 요청 성공!")
                    self?.fetchQueueState()
                case .failure(let error):
                    if let definedError = error as? QueueAPIError {
                        print("🐥 QueueAPIError: \(definedError)")
                        if definedError == .firebaseTokenError {
                            self?.refreshIDToken {
                                self?.findSesac()
                            }
                        }
                        return
                    }
                    
                    if let definedError = error as? QueueAPIError.Find {
                        print("🐥 QueueAPIError.Find: \(definedError)")
                    }
            }
        }
    }
    
    private func fetchQueueState() {
        print(#function)
        QueueAPIManager.myQueueState { [weak self] result in
            switch result {
                case .success(let myQueueState):
                    print("⭐️ \(myQueueState)")
                    // myQueueState.matched이 0이면 대기중, 1이면 매칭된 상태
                    // UserDefaults에 저장할 필요가..없..나..? 👻
                    UserDefaults.status = myQueueState.matched
                    guard let status = Status(rawValue: myQueueState.matched) else {
                        print("🐚 MyQueueState 응답값 받기 성공했으나 상태 알아내기 실패")
                        return
                    }
                    self?.homeView.setStatusButtonImage(as: status)
                case .failure(let error):
                    print(error)
                    // 에러를 커스텀 에러로 바꾼 후 처리하기
                    if let definedError = error as? QueueAPIError {
                        print("🧸 QueueAPIError: \(definedError)")
                        if definedError == .firebaseTokenError {
                            self?.refreshIDToken {
                                self?.fetchQueueState()
                            }
                        }
                        return
                    }
                    
                    if let definedError = error as? QueueAPIError.MyQueueState {
                        print("🧸 QueueAPIError.MyQueueState: \(definedError)")
                        // UserDefaults에 저장할 필요가..없..나..? 👻
                        UserDefaults.status = Status.defaultStatus.rawValue
                        print("🐚 MyQueueState 201")
                        self?.homeView.setStatusButtonImage(as: .defaultStatus)
                    }
            }
        }
    }
    
    private func fetchNearbyUsers() {
        QueueAPIManager.fetchNearbyUsers(latitude: 37.517819364682694, longitude: 126.88647317074734) { [weak self] result in
            switch result {
                case .success(let queueDB):
//                    print("🌲 \(queueDB)")
                    print("🌲")
                    dump(queueDB)
                    self?.showNearbyUsers(of: queueDB)
                case .failure(let error):
                    print(error)
                    if let definedError = error as? QueueAPIError {
                        print("🌲 QueueAPIError: \(definedError)")
                        if definedError == .firebaseTokenError {
                            self?.refreshIDToken {
                                self?.fetchNearbyUsers()
                            }
                        }
                        return
                    }
            }
        }
    }
    
    
    
    // MARK: - Map Methods
    private func showNearbyUsers(of queueDB: QueueDB) {
        let queueDBNearbyUsers = queueDB.fromQueueDB
        queueDBNearbyUsers.forEach { nearbyUser in
            let marker = NMFMarker()
            let overlayImage = NMFOverlayImage(name: "sesac_face_\(nearbyUser.sesac)")
            marker.width = 80
            marker.height = 80
            marker.iconImage = overlayImage
            marker.position = NMGLatLng(lat: nearbyUser.lat, lng: nearbyUser.long)
            marker.mapView = homeView.naverMapView.mapView
        }
    }
}

// MARK: - Location
extension HomeViewController {
    // MARK: - Location Methods
    /// 사용자 디바이스에 위치 서비스가 켜져 있는지 확인
    private func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus  // 위치에 대한 권한
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크: locationServicesEnabled()
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                // 위치 권한 확인 및 요청
                self?.checkUserCurrentLocationAuthorization(authorizationStatus)
            } else {
                self?.showToast(message: "아이폰 설정에서 위치 서비스를 켜 주세요.")
            }
        }
    }
    
    private func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            case .notDetermined:
                print("Not Determined")
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest  // iOS 14부터 나온 정확한 위치와는 다름
                locationManager.requestWhenInUseAuthorization()  // 앱을 사용하는 동안에 대한 위치 권한 요청
                // plist에 WhenInUse가 등록되어 있어야 request 메서드를 사용할 수 있다
            case .restricted, .denied:
                print("DENIED")
                DispatchQueue.main.sync {
                    setRegion()
                }
                // 아이폰 설정으로 유도
            case .authorizedWhenInUse:
                print("When In Use")
                // 사용자가 위치 권한을 허용해 둔 상태라면, startUpdatingLocation()을 통해 didUpdateLocations 메서드가 실행
                locationManager.startUpdatingLocation()
//            case .authorizedAlways: // '항상 허용'했다면 거의 호출되지 않을 것
//                <#code#>
//            case .authorized: // deprecated
//                <#code#>
            default: print("DEFAULT")
        }
    }
    
    private func transformCoordinateToNMFCameraPosition(coordinate: CLLocationCoordinate2D) -> NMFCameraPosition {
        return NMFCameraPosition(NMGLatLng(from: coordinate), zoom: 14)
    }
}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    // 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            let cameraPosition = transformCoordinateToNMFCameraPosition(coordinate: coordinate)
            setRegion(center: cameraPosition)
        }
        
        // 위치 업데이트 멈추기
        locationManager.stopUpdatingLocation()  // 계속 보여 주고 싶더라도 계속 쌓이지 않도록 특정 시점에는 구현 필요
    }
    
    // 사용자의 위치를 성공적으로 가져오는 데 실패한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // 사용자의 권한 상태가 바뀔 때
    // 거부했다가 설정에서 변경했거나, notDetermined에서 허용을 눌렀거나 등
    // 허용했어서 위치를 가지고 오는 중에, 설정에서 거부하고 돌아온다면??
    // iOS 14 이상: 사용자의 권한 상태가 변경될 때, 위치 관리자(locationManager)가 생성될 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
