//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Andrei Palonski on 11.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  var manager = CLLocationManager()
  var updateCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    manager.delegate = self
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      mapView.showsUserLocation = true // наша локация
      print("Ready to go")
      manager.startUpdatingLocation()
      
      Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
        // Spawn code for Pokemons
        
        if let coord = self.manager.location?.coordinate {
          let anno = MKPointAnnotation()
          anno.coordinate = coord
          let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0 // рандомное значение широты
          let randomLong = (Double(arc4random_uniform(200)) - 100.0) / 50000.0 // рандомное значение долготы
          anno.coordinate.latitude += randomLat
          anno.coordinate.longitude += randomLong
          self.mapView.addAnnotation(anno)
        }
      })
      
    } else {
      manager.requestWhenInUseAuthorization()
    }
    //    manager.requestWhenInUseAuthorization()
    //    mapView.showsUserLocation = true // наша локация
    
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // print("We made it")
    if updateCount < 3 {
      let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 270, 270) // 1000 или 200 уровень приближения
      mapView.setRegion(region, animated: false)
      updateCount += 1
    } else {
      manager.startUpdatingLocation() // прекращаем обновлять и экономим батарею
    }
  }
  
  @IBAction func centerTapped(_ sender: Any) {
    if let coord = manager.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coord, 270, 270)
      mapView.setRegion(region, animated: true)
    }
  }
}

