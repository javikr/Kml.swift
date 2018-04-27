//
//  PlacemarkViewController.swift
//  Kml
//
//  Created by Koki Ibukuro on 8/17/15.
//  Copyright (c) 2015 asus4. All rights reserved.
//

import UIKit
import MapKit
import Zip

// Placemark to MKAnnotation.
class PlacemarkViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Zip.addCustomFileExtension("kmz")
        
        mapView.delegate = self
        loadKMZ("Noruega")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func loadKMZ(_ fileName: String) {
        let url = Bundle.main.url(forResource: fileName, withExtension: "kmz")
        do {
            let unzipKMLDir = try Zip.quickUnzipFile(url!) // Unzip
            let fullKMLPath = unzipKMLDir.appendingPathComponent(fileName).appendingPathExtension("kml")
            loadKML(path: fullKMLPath)
        }
        catch {
            print(error.localizedDescription)
            print("Something went wrong")
        }
        
    }
    
    private func loadKML(path: URL)
    {
        KMLDocument.parse(path, callback:
            { [unowned self] (kml) in
                // Add and Zoom to annotations.
                self.mapView.showAnnotations(kml.annotations, animated: true)
            }
        )
    }
}

extension PlacemarkViewController: MKMapViewDelegate {

}
