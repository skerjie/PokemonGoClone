//
//  CoreDataHelp.swift
//  PokemonGoClone
//
//  Created by Andrei Palonski on 11.11.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
  
  createPokemon(name: "Mew", imageName: "mew")
  createPokemon(name: "Meowth", imageName: "meowth")
  createPokemon(name: "Abra", imageName: "abra")
  createPokemon(name: "Bellsprout", imageName: "bellsprout")
  createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
  createPokemon(name: "Caterpie", imageName: "caterpie")
  createPokemon(name: "Charmander", imageName: "charmander")
  createPokemon(name: "Dratini", imageName: "dratini")
  createPokemon(name: "Eevee", imageName: "eevee")
  createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
  createPokemon(name: "Mankey", imageName: "mankey")
  createPokemon(name: "Mystic", imageName: "mystic")
  createPokemon(name: "Pidgey", imageName: "pidgey")
  createPokemon(name: "Pikachu", imageName: "pikachu-2")
  createPokemon(name: "Psyduck", imageName: "psyduck")
  createPokemon(name: "Rattata", imageName: "rattata")
  createPokemon(name: "Snorlax", imageName: "snorlax")
  createPokemon(name: "Squirtle", imageName: "squirtle")
  createPokemon(name: "Venonat", imageName: "venonat")
  createPokemon(name: "Weedle", imageName: "weedle")
  createPokemon(name: "Zubat", imageName: "zubat")
  
  (UIApplication.shared.delegate as! AppDelegate).saveContext()
  
  
}

func getAllPokemons() -> [Pokemon] {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  do {
    let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
    if pokemons.count == 0 {
      addAllPokemon()
      return getAllPokemons()
    }
    return pokemons
  } catch {
    
  }
  
  return []
  
}

func createPokemon(name: String, imageName: String) {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let pokemon = Pokemon(context: context)
  pokemon.name = name
  pokemon.imageName = imageName
}

func getAllCaughtPokemons() -> [Pokemon] {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
  fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
  do {
    let pokemons = try context.fetch(fetchRequest) as [Pokemon]
    return pokemons
  } catch {
    
  }
  return []
  
}

func getAllUnCaughtPokemons() -> [Pokemon] {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
  fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
  do {
    let pokemons = try context.fetch(fetchRequest) as [Pokemon]
    return pokemons
  } catch {
    
  }
  return []
}
