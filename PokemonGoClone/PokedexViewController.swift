//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by Andrei Palonski on 11.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  var caughtPokemons : [Pokemon] = []
  var unCaughtpokemons : [Pokemon] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

      caughtPokemons = getAllCaughtPokemons() // пойманные покемоны
      unCaughtpokemons = getAllUnCaughtPokemons() // непойманные покемоны
      
        tableView.dataSource = self
      tableView.delegate = self
    }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2 // 2 секции пойманные и не пойманные
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "CAUGHT"
    } else {
      return "UNCAUGHT"
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return caughtPokemons.count
    } else {
      return unCaughtpokemons.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let pokemon : Pokemon
    if indexPath.section == 0 {
      pokemon = caughtPokemons[indexPath.row]
    } else {
      pokemon = unCaughtpokemons[indexPath.row]
    }
    
    let cell = UITableViewCell()
    cell.textLabel?.text = pokemon.name
    cell.imageView?.image = UIImage(named: pokemon.imageName!)
    return cell
  }

  @IBAction func mapTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil) // отпускаем контроллер на предыдущий viewController
  }
  
}
