//
//  ViewController.swift
//  Pokedex
//
//  Created by nawfal cherkaoui on 2/20/16.
//  Copyright © 2016 nawfal cherkaoui. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var musicplayer: AVAudioPlayer!
    
    var pokemons = [Pokemon]()
    var filtredPokemons = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        initAudioPlayer()
        parsePokemonCSV()
    }
    
    func initAudioPlayer() {
        if let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3"), let urlPath = NSURL(string: path) {
            do {
                
                musicplayer = try AVAudioPlayer(contentsOfURL: urlPath)
                musicplayer.prepareToPlay()
                musicplayer.numberOfLoops = -1
                musicplayer.play()
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
    }
    
    func parsePokemonCSV() {
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
        
            do {
               let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    if let name = row["identifier"], let _id = row["id"], let id = Int(_id)  {
                        let poke = Pokemon(name: name, pokedexId: id)
                        pokemons.append(poke)
                    }
                }
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode  == true ? filtredPokemons.count : pokemons.count
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokedexCell", forIndexPath: indexPath) as? PokedexCell {
            let pokemon: Pokemon = inSearchMode  == true ? filtredPokemons[indexPath.row] : pokemons[indexPath.row]
            cell.configurationCell(pokemon)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collectionView.reloadData()
        } else {
            inSearchMode = true
            let text = searchBar.text!.lowercaseString
            filtredPokemons = pokemons.filter({$0.name.rangeOfString(text) != nil})
            collectionView.reloadData()
        }
    }
    
    
    @IBAction func musicButtonPressed(sender: UIButton!) {
        
        if musicplayer.playing {
            musicplayer.stop()
            sender.alpha = 0.2
        } else {
            musicplayer.play()
            sender.alpha = 1.0
        }
    }
}

