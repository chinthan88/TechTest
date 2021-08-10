//
//  SearchTrainInteractor.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation
import XMLParsing
import Alamofire

class SearchTrainInteractor: PresenterToInteractorProtocol {
    var _sourceStationCode = String()
    var _destinationStationCode = String()
    weak var presenter: InteractorToPresenterProtocol?
    var networkRepository: NetworkRepositoryProtocol?
    var localDataRepository: LocalDataRepositoryProtocol?

    func fetchallStations() {
        networkRepository?.fetchAllStations(resultHandler: { [weak self] (result) in
            switch result {
            case .success(let station):
                self?.presenter?.stationListFetched(list: station.stationsList)
                break
            case .failure(let error):
                self?.presenter?.showErrorMessage(for: error)
                break
            }
        })
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        _sourceStationCode = sourceCode
        _destinationStationCode = destinationCode
        networkRepository?.fetchTrainsFromSource(sourceCode: sourceCode, resultHandler: { [weak self] (result) in
            switch result {
            case .success(let trainsList):
                self?.proceesTrainListforDestinationCheck(trainsList: trainsList)
                break
            case .failure(let error):
                self?.presenter?.showErrorMessage(for: error)
                break
            }
        })
    }
    
    private func proceesTrainListforDestinationCheck(trainsList: [StationTrain]) {
        var _trainsList = trainsList
        DispatchQueue.global(qos: .background).async {
            let group = DispatchGroup()
            for index  in 0...trainsList.count-1 {
                guard let code = trainsList[index].trainCode else {
                    continue
                }
                group.enter()
                self.networkRepository?.processTrainListforDestinationCheck(code: code, date: Date.TrainDate, resultHandler: { (result) in
                    group.leave()
                    switch result {
                    case .success(let trainMovements):
                        if let firstStationMoment = self.destinationTrains(for: trainMovements)  {
                            _trainsList[index].destinationDetails = firstStationMoment
                        }
                        break
                    case .failure(let error):
                        self.presenter?.showErrorMessage(for: error)
                        break
                    }
                })
                group.wait()
            }
            group.notify(queue: DispatchQueue.main) {
                let sourceToDestinationTrains = _trainsList.filter{$0.destinationDetails != nil}
                self.presenter?.fetchedTrainsList(trainsList: sourceToDestinationTrains)
                if sourceToDestinationTrains.count == 0 {
                    self.presenter?.showErrorMessage(for: .noTrainAvailbilityFromSource)
                }
            }
        }
    }
    //MARK: Favourite Logic
    func saveStationToFav(_ station: StationTrain) {
        localDataRepository?.saveStationAsFavourite(station)
    }
    func getFavouriteStation() -> StationTrain? {
        return localDataRepository?.getFavouriteStation()
    }
}

//MARK: Validation & Destination Logic
extension SearchTrainInteractor {
    private func destinationTrains(for trainMovements: TrainMovementsData) -> TrainMovement? {
        let _movements = trainMovements.trainMovements
        let sourceIndex = _movements.firstIndex(where: {$0.locationCode?.caseInsensitiveCompare(self._sourceStationCode) == .orderedSame})
        let destinationIndex = _movements.firstIndex(where: {$0.locationCode?.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame})
        let desiredStationMoment = _movements.filter{$0.locationCode?.caseInsensitiveCompare(self._destinationStationCode) == .orderedSame}
        let isDestinationAvailable = desiredStationMoment.count == 1
        
        if isDestinationAvailable  && sourceIndex! < destinationIndex! {
            return desiredStationMoment.first
        }
        return nil
    }

    private func validSourceAndDestination(_ sourceCode: String, _ destinationCode: String) -> Bool {
        guard sourceCode != destinationCode,
              !sourceCode.isEmpty,
              !destinationCode.isEmpty else {
            return false
        }
        return true
    }
}
