
import Foundation
import CoreLocation
import React

@objc(BackgroundLocationManager)
class BackgroundLocationManager: RCTEventEmitter, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var hasListeners: Bool = false // Track if listeners are registered

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.pausesLocationUpdatesAutomatically = false
    }

    @objc
    func startLocationUpdates() {
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }

    @objc
    func stopLocationUpdates() {
        self.locationManager?.stopMonitoringSignificantLocationChanges()
    }

    // Called whenever there is a significant location change or standard location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": location.timestamp.timeIntervalSince1970
        ]

        // Emit event only if there are listeners registered
        if hasListeners {
            sendEvent(withName: "locationUpdated", body: locationData)
        }
    }

    override func startObserving() {
        hasListeners = true // Listener has been registered
    }

    override func stopObserving() {
        hasListeners = false // Listener has been removed
    }

    override func supportedEvents() -> [String]! {
        return ["locationUpdated"]
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
