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
      setUp()
    } else {
      manager.requestWhenInUseAuthorization()
    }
    //    manager.requestWhenInUseAuthorization()
    //    mapView.showsUserLocation = true // наша локация
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      setUp()
    }
  }
  
  func setUp() {
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
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    mapView.deselectAnnotation(view.annotation!, animated: true)
    
    if view.annotation! is MKUserLocation {
      return
    }
    
    // если покемон в области пользователя, то его можно словить, иначе нельзя
    let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
    mapView.setRegion(region, animated: true)
    
    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in // при большом зуме проверяем действиельно ли покемон близко
      if let coord = self.manager.location?.coordinate {
        
        let pokemon = (view.annotation as! PokeAnnotation).pokemon
        
        if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
          
          pokemon.caught = true
          (UIApplication.shared.delegate as! AppDelegate).saveContext()
          mapView.removeAnnotation(view.annotation!) // удаляем аннотацию если словили покемона
          let alertVC = UIAlertController(title: "Awesome", message: "You caught a \(pokemon.name!) Poke-Master 👍🏻", preferredStyle: .alert)
         // let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
          self.performSegue(withIdentifier: "pokedexSegus", sender: nil)
          })
         // alertVC.addAction(OKAction)
          alertVC.addAction(pokedexAction)
          self.present(alertVC, animated: true, completion: nil)
          
          print("Can catch the pokemon")
        } else {
          let alertVC = UIAlertController(title: "No-no-no", message: "You too far away to catch the \(pokemon.name!) Move closer", preferredStyle: .alert)
          let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertVC.addAction(OKAction)
          self.present(alertVC, animated: true, completion: nil)
        }
        
        print("annotation tapped")
      }
    })
  }
  
  @IBAction func centerTapped(_ sender: Any) {
    if let coord = manager.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coord, 270, 270)
      mapView.setRegion(region, animated: true)
    }
  }
}

