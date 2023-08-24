//
//  WhistlesCollectionElement.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 23.08.2023.
//

final class WhistlesCollectionElement {
    var selected: Bool
    let name: String
    let shortSoundName: String
    let longSoundName: String
    
    init(selected: Bool, number: Int) {
        self.selected = selected
        self.name = String(format: "Clicker.SoundName".localized, number)
        self.shortSoundName = "Sound.Whistle.\(number)"
        self.longSoundName = "Sound.Whistle.Long.\(number)"
    }
}
