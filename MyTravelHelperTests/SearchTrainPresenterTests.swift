//
//  SearchTrainPresenterTests.swift
//  MyTravelHelperTests
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainPresenterTests: XCTestCase {
    var presenter: SearchTrainPresenter!
    var view = SearchTrainMockView()
    var interactor = SearchTrainInteractorMock()
    
    override func setUp() {
      presenter = SearchTrainPresenter()
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
    }

    func testfetchallStations() {
        presenter.fetchallStations()
        XCTAssertTrue(view.isSaveFetchedStatinsCalled)
    }

    override func tearDown() {
        presenter = nil
    }
}


class SearchTrainMockView: PresenterToViewProtocol {
    var isSaveFetchedStatinsCalled = false

    func saveFetchedStations(stations: [Station]?) {
        isSaveFetchedStatinsCalled = true
    }

    func showInvalidSourceOrDestinationAlert() {

    }
    
    func updateLatestTrainList(trainsList: [StationTrain]) {

    }
    
    func showNoTrainsFoundAlert() {

    }
    
    func showNoTrainAvailbilityFromSource() {

    }
    
    func showNoInterNetAvailabilityMessage() {

    }
}

class SearchTrainInteractorMock: PresenterToInteractorProtocol {
    var networkRepository: NetworkRepositoryProtocol?
    
    var localDataRepository: LocalDataRepositoryProtocol?
    
    var presenter: InteractorToPresenterProtocol?

    func fetchallStations() {
        let station = Station(desc: "Belfast Central", latitude: 54.6123, longitude: -5.91744, code: "BFSTC", stationId: 228)
        presenter?.stationListFetched(list: [station])
    }

    func fetchTrainsFromSource(sourceCode: String, destinationCode: String) {
        let stationTrain: StationTrain = StationTrain.init(trainCode: "A123", fullName: sourceCode, stationCode: "456", trainDate: "5/01/2021", dueIn: 2, lateBy: 3, expArrival: "16:00", expDeparture: "18:00", destinationDetails: TrainMovement.init(trainCode: "A345", locationCode: "798", locationFullName: destinationCode, expDeparture: "20:00"))

        presenter?.fetchedTrainsList(trainsList: [stationTrain])
    }
    
    var favStation: StationTrain?
    func saveStationToFav(_ station: StationTrain) {
        self.favStation = station
    }
    func getFavouriteStation() -> StationTrain? {
        return favStation
    }
}
