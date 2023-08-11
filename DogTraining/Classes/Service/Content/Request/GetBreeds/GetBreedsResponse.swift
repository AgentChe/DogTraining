//
//  GetBreedsResponse.swift
//  DogTraining
//
//  Created by Андрей Чернышев on 11.08.2023.
//

final class GetBreedsResponse {
    static func map(from response: Any) -> [Breed] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let breedsArray = data["breeds"] as? [[String: Any]]
        else {
            return []
        }
        
        return breedsArray.compactMap { breedJSON -> Breed? in
            guard
                let id = breedJSON["breed_id"] as? Int,
                let name = breedJSON["name"] as? String
            else {
                return nil
            }
            
            return Breed(
                id: id,
                name: name
            )
        }
    }
}
