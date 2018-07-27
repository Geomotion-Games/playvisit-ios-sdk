//
//  PVWebView.swift
//  PlayVisit-iOS
//
//  Created by Oriol Janés on 03/07/2018.
//  Copyright © 2018 playvisit. All rights reserved.
//

import WebKit
import CoreLocation

open class PVWebView: WKWebView, CLLocationManagerDelegate, WKScriptMessageHandler {

    public var locationManager: CLLocationManager!
    public var userContentController: WKUserContentController!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

    // Initializer
    public convenience init(token: String) {

        //TODO look preferences
        let prefs = WKPreferences()
        prefs.javaScriptCanOpenWindowsAutomatically = true

        let config = WKWebViewConfiguration()
        config.preferences = prefs
        config.suppressesIncrementalRendering = false
        config.userContentController = WKUserContentController() // TODO probar de treure-ho com a variable de classe

        self.init(frame: CGRect.zero, configuration: config)

        self.userContentController = self.configuration.userContentController
        userContentController.add(self, name: "pvconnection")

        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {

            print("location services enabled")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        addContent(token: token)
    }

    public func addContent(token: String) {
        let urlString = "http://studio.geomotiongames.com/app-ios/" + token
        guard let url = URL(string: urlString) else { return }

        let request = URLRequest(url: url)

        print("PV: Loading experience with token: " + token)
        print(request)
        self.load(request)
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let dict = message.body as! [String:AnyObject]
        if dict["close"] != nil {
            if let vc = self.parentViewController {
                vc.dismiss(animated: true, completion: nil)
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.evaluateJavaScript("setLocation( \(loc.latitude), \(loc.longitude) )")
    }

}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

