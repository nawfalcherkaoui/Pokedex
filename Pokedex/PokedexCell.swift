//
//  PokedexCell.swift
//  Pokedex
//
//  Created by nawfal cherkaoui on 2/21/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit

class PokedexCell: UICollectionViewCell {

    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 0.5
    }
    
    func configurationCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        pokeImage.image = UIImage(named: "\(pokemon.pokedexId)")
        pokeName.text = pokemon.name.capitalizedString
    }
}
