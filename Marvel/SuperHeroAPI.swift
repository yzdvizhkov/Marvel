//
//  SuperHeroAPI.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 28.04.2023.
//

import Foundation

class SuperHeroAPI {
    
    static func getSuperHeroes() -> [SuperHero]{
        let heroes = [
            SuperHero(name: "Kelly Goodwin", description: "Designer"),
            SuperHero(name: "Mohammad Hussain", description: "SEO Specialist"),
            SuperHero(name: "John Young", description: "Interactive Designer"),
            SuperHero(name: "Tamilarasi Mohan", description: "Architect"),
            SuperHero(name: "Kim Yu", description: "Economist"),
            SuperHero(name: "Derek Fowler", description: "Web Strategist"),
            SuperHero(name: "Shreya Nithin", description: "Product Designer"),
            SuperHero(name: "Emily Adams", description: "Editor"),
            SuperHero(name: "Aabidah Amal", description: "Creative Director"),
            SuperHero(name: "Aabidah Amal", description: "Creative Director")
        ]
        return heroes
    }
}
