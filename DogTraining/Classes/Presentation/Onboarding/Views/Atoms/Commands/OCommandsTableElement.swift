//
//  OCommandsTableElement.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 14.08.2023.
//

final class OCommandsTableElement {
    let command: CommandGroup
    var marked: Bool
    
    init(command: CommandGroup, marked: Bool = false) {
        self.command = command
        self.marked = marked
    }
}
