//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Andrei Palonski on 11.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  var manager = CLLocationManager()
  var updateCount = 0
  var pokemonsArray : [Pokemon] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    pokemonsArray = getAllPokemons()
    manager.delegate = self
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      mapView.showsUserLocation = true // наша локация
      mapView.delegate = self
      manager.startUpdatingLocation()
      
      Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
        // Spawn code for Pokemons
        
        if let coord = self.manager.location?.coordinate {
          
          let pokemon = self.pokemonsArray[Int(arc4random_uniform(UInt32(self.pokemonsArray.count)))]
          
          let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
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
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
      annoView.image = UIImage(named: "player")
      var frame = annoView.frame
      frame.size.height = 33
      frame.size.width = 33
      annoView.frame = frame
      
      return annoView
    }
    
    let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
    let pokemon = (annotation as! PokeAnnotation).pokemon
    annoView.image = UIImage(named: pokemon.imageName!)
    var frame = annoView.frame
    frame.size.height = 35
    frame.size.width = 35
    annoView.frame = frame
    
    return annoView
    
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

