//
//  PokemonInfoVC.swift
//  PokemonApp
//
//  Created by Dara on 2/23/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit
import AVFoundation

class PokemonInfoVC: UIViewController {
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var evolutionImg01: UIImageView!
    @IBOutlet weak var evolutionImg02: UIImageView!
    @IBOutlet weak var evolutionImg03: UIImageView!
    @IBOutlet weak var evolutionArrow01: UIImageView!
    @IBOutlet weak var evolutionArrow02: UIImageView!
    
    @IBOutlet weak var evolutionLblFocus01: UILabel!
    @IBOutlet weak var evolutionLblFocus02: UILabel!
    @IBOutlet weak var evolutionLblFocus03: UILabel!
    
    @IBOutlet weak var pokemonPokedexIdLbl: UILabel!
    @IBOutlet weak var pokemonTypeLbl01: UILabel!
    @IBOutlet weak var pokemonTypeLbl02: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var pokemonSummaryTxtView: UITextView!
    
    @IBOutlet weak var pokemonHpLbl: UILabel!
    @IBOutlet weak var pokemonSpdLbl: UILabel!
    @IBOutlet weak var pokemonAttlbl: UILabel!
    @IBOutlet weak var pokemonSpAttLbl: UILabel!
    @IBOutlet weak var pokemonDefLbl: UILabel!
    @IBOutlet weak var pokemonSpDefLbl: UILabel!
    
    @IBOutlet weak var pokemonAbilLbl01: UILabel!
    @IBOutlet weak var pokemonAbilLbl02: UILabel!
    @IBOutlet weak var pokemonHiddenAbilLbl: UILabel!
    
    @IBOutlet weak var pokemonHpPV: UIProgressView!
    @IBOutlet weak var pokemonSpdPV: UIProgressView!
    @IBOutlet weak var pokemonAttPV: UIProgressView!
    @IBOutlet weak var pokemonSpAttPV: UIProgressView!
    @IBOutlet weak var pokemonDefPV: UIProgressView!
    @IBOutlet weak var pokemonSpDefPV: UIProgressView!
    
    
    var evolutionUILblCollection: [UILabel]!
    var evoulutionUIImgViewCollection: [UIImageView]!
    
    var pokemon: Pokemon! //passed in by segue, identifier "PokemonInfoVC"
    var allPokemon: [Pokemon]! //passed in by segue, identifier "PokemonInfoVC"
    var pokemonEvolution: [Pokemon]!
    var indexOfTappedEvolutionImg: Int!
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayerIsReadToPlay = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexOfTappedEvolutionImg = -999
        
        evolutionUILblCollection = [evolutionLblFocus01, evolutionLblFocus02, evolutionLblFocus03]
        evoulutionUIImgViewCollection = [evolutionImg01, evolutionImg02, evolutionImg03]
        
        pokemonEvolution = allPokemon.evolution(of: pokemon)
        
        configureImageTapGesture()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*-- Functions --*/
    func configureImageTapGesture() {
        
        let evolutionImg01TapGesture = UITapGestureRecognizer(target: self, action: #selector(evolutionImg01Tapped))
        let evolutionImg02TapGesture = UITapGestureRecognizer(target: self, action: #selector(evolutionImg02Tapped))
        let evolutionImg03TapGesture = UITapGestureRecognizer(target: self, action: #selector(evolutionImg03Tapped))
        
        evolutionImg01.addGestureRecognizer(evolutionImg01TapGesture)
        evolutionImg01.isUserInteractionEnabled = true
        evolutionImg02.addGestureRecognizer(evolutionImg02TapGesture)
        evolutionImg02.isUserInteractionEnabled = true
        evolutionImg03.addGestureRecognizer(evolutionImg03TapGesture)
        evolutionImg03.isUserInteractionEnabled = true
    }
    
    func updateUI() {
        
        pokemonEvolution = allPokemon.evolution(of: pokemon)
        
        setItemDefaultSetting()
        updateUIWithLocalData()
        updateUIWithRmoteData()
        initAudioPlayer()
    }
    
    func updateUIWithLocalData() {
        
        self.navigationItem.title = pokemon.name
        pokemonImg.image = UIImage(named: "\(pokemon.pokedexID)")
        pokemonPokedexIdLbl.text = pokemon.pokedexID.toIDOutputFormat()
        pokemonHeight.text = pokemon.height.toMeterOutputFormat()
        pokemonWeight.text = pokemon.weight.toKiloOutputForat()
        
        if pokemonEvolution.count < 4 {
            for i in 0 ..< pokemonEvolution.count {
                //set evolution images
                evoulutionUIImgViewCollection[i].isHidden = false
                evoulutionUIImgViewCollection[i].image = UIImage(named: "\(pokemonEvolution[i].pokedexID)")
                
                //set focus label
                if pokemonEvolution[i].pokedexID == pokemon.pokedexID {
                    evolutionUILblCollection[i].isHidden = false
                } else {
                    evolutionUILblCollection[i].isHidden = true
                }
                
                //set evolution arrow
                switch pokemonEvolution.count {
                case 1:
                    print("No Evolution")
                case 2:
                    evolutionArrow01.isHidden = false
                case 3:
                    evolutionArrow01.isHidden = false
                    evolutionArrow02.isHidden = false
                default:
                    print("Cannot have more than 2 evolution arrows")
                }
            }
        } else {
            print("Special evolution condition")
        }
    }
    
    func updateUIWithRmoteData() {
        
        self.pokemon.requestPokemonData {
            DispatchQueue.main.sync {
                self.updateIBOutlets()
            }
        }
    }
    
    func updateIBOutlets() { // must use 'self' because this func is used by an async func, updateUIWithLocalData()
        
        if self.pokemon.hp != 0 { //does not have to be 'hp', if any property is 0, skip
            self.pokemonHpLbl.text = "\(self.pokemon.hp)"
            self.pokemonSpdLbl.text = "\(self.pokemon.speed)"
            self.pokemonAttlbl.text = "\(self.pokemon.attack)"
            self.pokemonSpAttLbl.text = "\(self.pokemon.spAttack)"
            self.pokemonDefLbl.text = "\(self.pokemon.defend)"
            self.pokemonSpDefLbl.text = "\(self.pokemon.spDefend)"
            
            
            self.pokemonHpPV.setProgress(self.pokemon.hp.toProgress(), animated: true)
            self.pokemonSpdPV.setProgress(self.pokemon.speed.toProgress(), animated: true)
            self.pokemonAttPV.setProgress(self.pokemon.attack.toProgress(), animated: true)
            self.pokemonSpAttPV.setProgress(self.pokemon.spAttack.toProgress(), animated: true)
            self.pokemonDefPV.setProgress(self.pokemon.defend.toProgress(), animated: true)
            self.pokemonSpDefPV.setProgress(self.pokemon.spDefend.toProgress(), animated: true)
        }
        
        
        self.pokemonSummaryTxtView.text = self.pokemon.summary
        self.pokemonSummaryTxtView.isHidden = false
        
        if self.pokemon.hasPrimaryType {
            self.pokemonTypeLbl01.text = self.pokemon.types.primary
            self.pokemonTypeLbl01.isHidden = false
            self.pokemonTypeLbl01.backgroundColor = self.pokemon.types.primary.toUIColor()
        }
        if self.pokemon.hasSecondType {
            self.pokemonTypeLbl02.text = self.pokemon.types.secondary
            self.pokemonTypeLbl02.isHidden = false
            self.pokemonTypeLbl02.backgroundColor = self.pokemon.types.secondary.toUIColor()
        }
        
        if self.pokemon.hasFirstAbility {
            self.pokemonAbilLbl01.text = self.pokemon.abilities.firstAbility
            self.pokemonAbilLbl01.isHidden = false
        }
        if self.pokemon.hasSecondAbility {
            self.pokemonAbilLbl02.text = self.pokemon.abilities.secondAbility
            self.pokemonAbilLbl02.isHidden = false
        }
        if self.pokemon.hasHiddenAbility {
            self.pokemonHiddenAbilLbl.text = "\(self.pokemon.abilities.hiddenAbility) (H)"
            self.pokemonHiddenAbilLbl.isHidden = false
        }
    }
    
    func setItemDefaultSetting() {
        
        pokemonTypeLbl01.isHidden = true
        pokemonTypeLbl02.isHidden = true
        pokemonAbilLbl01.isHidden = true
        pokemonAbilLbl02.isHidden = true
        pokemonHiddenAbilLbl.isHidden = true
        pokemonSummaryTxtView.isHidden = true
        
        pokemonHpLbl.text = "0"
        pokemonAttlbl.text = "0"
        pokemonDefLbl.text = "0"
        pokemonSpAttLbl.text = "0"
        pokemonSpDefLbl.text = "0"
        pokemonSpdLbl.text = "0"
        
        pokemonHpPV.setProgress(DEFAULT_PROGRESS_VALUE, animated: true)
        pokemonAttPV.setProgress(DEFAULT_PROGRESS_VALUE, animated: true)
        pokemonDefPV.setProgress(DEFAULT_PROGRESS_VALUE, animated: true)
        pokemonSpAttPV.setProgress(DEFAULT_PROGRESS_VALUE, animated: true)
        pokemonSpDefPV.setProgress(DEFAULT_PROGRESS_VALUE, animated: true)
        pokemonSpdPV.setProgress(DEFAULT_PROGRESS_VALUE, animated: true)
    }
    
    func initAudioPlayer() {
        
        if let path = Bundle.main.path(forResource: "\(pokemon.pokedexID)", ofType: "m4a"), let url = URL(string: path) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayerIsReadToPlay = true
            } catch let error as NSError {
                print(error.debugDescription)
            }
        } else {
            audioPlayerIsReadToPlay = false
        }
    }
    
    
    /*-- Tap Gestures --*/
    func evolutionImg01Tapped() {
        
        if pokemon.pokedexID != pokemonEvolution[0].pokedexID {
            pokemon = pokemonEvolution[0]
            updateUI()
        }
    }
    
    func evolutionImg02Tapped() {
        
        if pokemon.pokedexID != pokemonEvolution[1].pokedexID {
            pokemon = pokemonEvolution[1]
            updateUI()
        }
    }
    
    func evolutionImg03Tapped() {
        
        if pokemon.pokedexID != pokemonEvolution[2].pokedexID {
            pokemon = pokemonEvolution[2]
            updateUI()
        }
    }
    
    
    /*-- Buttons --*/
    @IBAction func pokeCryBtnClicked(_ sender: Any) {
        
        if audioPlayerIsReadToPlay {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
}
