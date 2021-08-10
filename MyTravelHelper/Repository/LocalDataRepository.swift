//
//  LocalRepository.swift
//  MyTravelHelper
//
//  Created by apple on 09/08/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

protocol LocalDataRepositoryProtocol {
    func saveStationAsFavourite(_ station: StationTrain)
    func getFavouriteStation() -> StationTrain?
}

class LocalDataRepository: LocalDataRepositoryProtocol {
    func saveStationAsFavourite(_ station: StationTrain) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(station), forKey:"FavouriteStationTrain")
    }

    func getFavouriteStation() -> StationTrain? {
        if let data = UserDefaults.standard.value(forKey:"FavouriteStationTrain") as? Data {
            let station = try? PropertyListDecoder().decode(StationTrain.self, from: data)
            return station
        }
        return nil
    }
}
