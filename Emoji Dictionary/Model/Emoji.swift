//
//  Emoji.swift
//  Emoji Dictionary
//
//  Created by Lore P on 14/02/2023.
//

import Foundation


struct Emoji: Codable {
    
    var symbol: String
    var name: String
    var description: String
    var usage: String
    
    static let sampleEmojis = [
        Emoji(symbol: "😙", name: "Kissing Face", description: "Little yellow face blowing a kiss", usage: "affection, love"),
        Emoji(symbol: "🤩", name: "Star Eyes Smile", description: "Smily happy place type of facer", usage: "happiness, excitement"),
        Emoji(symbol: "🥵", name: "Tired face", description: "Little red face with the tongue out from fatigue", usage: "tired, exhausted, hot"),
        Emoji(symbol: "👻", name: "Ghost", description: "Little classic sheet ghost", usage: "halloween, fear"),
        Emoji(symbol: "🤖", name: "Robot", description: "Robot face very cubic", usage: "machine, hardware"),
        Emoji(symbol: "🤌", name: "Italian WTF", description: "Little hand that suggest someone does not understand something", usage: "surprise, italian"),
        Emoji(symbol: "💂‍♀️", name: "King's guard", description: "Head of a typical English guard", usage: "guard, police, england"),
        Emoji(symbol: "💅", name: "Polishing nails", description: "A yellow hand with purple finger getting painted", usage: "nails, getting ready"),
        Emoji(symbol: "👘", name: "Kimono", description: "Orange dress of some Japanese tradition", usage: "kimono, clothes"),
        Emoji(symbol: "🦉", name: "Owl", description: "An owl posing", usage: "owl, bird, night"),
        Emoji(symbol: "🐝", name: "Bee", description: "A little pollinator", usage: "bee, pollen, wasp"),
        Emoji(symbol: "🌖", name: "Moon", description: "Descrescent moon, first quarter", usage: "moon, astronomy"),
        Emoji(symbol: "🍄", name: "Mushroom", description: "Classic depiction of a cartoonish mushroom", usage: "mushrooms, smurfs")
    ]
    
    
    
    // MARK: Saving data

    static let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("emojis_test").appendingPathExtension("plist")

    
    static func saveToFile(emojis: [Emoji]) {

        let encodedEmoji = try? PropertyListEncoder().encode(emojis)
        try? encodedEmoji?.write(to: archiveURL, options: .noFileProtection)
    }

    
    static func loadFromFile() -> [Emoji] {

        if let data         = try? Data(contentsOf: archiveURL),
           let decodedEmoji = try? PropertyListDecoder().decode(Array<Emoji>.self, from: data) {
            return decodedEmoji
        }
        
        return sampleEmojis
    }
}
