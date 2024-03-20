import SwiftUI
import CoreLocation

class SpeedViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var hapticFeedbackTriggered: Bool = false // To avoid repeated haptics

    @Published var speedKmH: Double = 0.0 {
        didSet {
            if speedKmH > Double(warningSpeed) && !hapticFeedbackTriggered {
                print("Haptic feedback would be triggered now.")
                WKInterfaceDevice.current().play(.notification)
                hapticFeedbackTriggered = true
            } else if speedKmH <= Double(warningSpeed) && hapticFeedbackTriggered {
                print("Speed below warning. Haptic feedback would stop.")
                hapticFeedbackTriggered = false
            }
        }
    }
    @Published var warningSpeed: Int = 50
    private var locationManager: CLLocationManager?
    @Published var isTracking: Bool = false

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func startTracking() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        }

        locationManager?.startUpdatingLocation()
        hapticFeedbackTriggered = false
        isTracking = true
    }
    
    func stopTracking() {
        self.locationManager?.stopUpdatingLocation()
        self.speedKmH = 0.0
        hapticFeedbackTriggered = false
        self.isTracking = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let speed = locations.last?.speed, speed > 0 {
            self.speedKmH = speed * 3.6
        } else {
            self.speedKmH = 0.0
        }
    }
}

@main
struct SpeederApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
