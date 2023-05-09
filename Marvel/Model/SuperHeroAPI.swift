//
//  SuperHeroAPI.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 28.04.2023.
//
// alamofire
import Foundation

class SuperHeroAPI {
    static func getSuperHeroes() -> [SuperHero] {
        let heroes = [
            SuperHero(name: "Iron-Man", description: "Genius. Billionaire. Playboy. Philanthropist"),
            SuperHero(name: "Aquaman", description: "Defender of the underwater kingdom of Atlantis"),
            SuperHero(name: "The Atom", description: "His main ability is to shrink in size"),
            SuperHero(name: "Batgirl", description: "Member of the Batman Family"),
            SuperHero(name: "Batman", description: "Superhero protector of Gotham City"),
            SuperHero(name: "Captain America", description: "Fights for American ideals"),
            SuperHero(name: "Catwoman", description: "Dangerous, clever and resourceful fighter,"),
            SuperHero(name: "Superman", description: "Fights evil with the aid of extraordinary abilities"),
            SuperHero(name: "Doctor Strange", description: "the mightiest magician in the cosmos"),
            SuperHero(name: "Hellboy", description: "large, muscular, red-skinned demon"),
        ]
        return heroes
    }
}
