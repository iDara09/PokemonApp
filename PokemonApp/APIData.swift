//
//  ReadConstants.swift
//  PokemonAlamofire
//
//  Created by Dara on 2/22/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import Foundation

class APIData {
    
    private var _baseURL: String!
    private var _versionURL: String!
    private var _pokemonURL: String!
    private var _summaryURL: String!
    
    
    init() {
        if let apiPath = Bundle.main.path(forResource: "pokeapi-data", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: apiPath) {
                if let baseURL = dict["api_base_url"] as? String, let versionURL = dict["api_version_url"] as? String, let pokemonURL = dict["api_pokemon_url"] as? String,let summaryURL = dict["api_summary_url"] as? String {
                    
                    _baseURL = baseURL
                    _versionURL = versionURL
                    _pokemonURL = pokemonURL
                    _summaryURL = summaryURL
                }
            }
        }
    }
    
    
    var baseURL: String { return _baseURL }
    var versionURL: String { return _versionURL }
    var pokemonURL: String { return _pokemonURL }
    var summaryURL: String { return self._summaryURL }
}
