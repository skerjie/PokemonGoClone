//
//  PokeAnnotation.swift
//  PokemonGoClone
//
//  Created by Andrei Palonski on 12.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
  var pokemon : Pokemon
  var coordinate: CLLocationCoordinate2D
  
  init(coord: CLLocationCoordinate2D, pokemon : Pokemon) {
    self.coordinate = coord
    self.pokemon = pokemon
  }
  
  
}
