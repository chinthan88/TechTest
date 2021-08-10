//
//  SearchTrainInteractorTests.swift
//  MyTravelHelperTests
//
//  Created by Chinthan on 09/08/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainInteractorTests: XCTestCase {

    var interactor: SearchTrainInteractor!
    var presenter = SearchTrainPresenterMockTest()
    
    override func setUp() {
        interactor = SearchTrainInteractor()
        interactor.localDataRepository = LocalDataRepository()
        interactor.networkRepository = NetworkRepository()
        interactor.presenter = presenter
    }

    func testFetchAllStations() {
        let fetchAllStationsSuccess = XCTestExpectation(description: "Expectation_ FetchAllStations")
        interactor.fetchallStations()
        let result = XCTWaiter.wait(for: [fetchAllStationsSuccess], timeout: 5.0)
         if result == XCTWaiter.Result.timedOut {
            XCTAssert(presenter.fetchedStationListCalled, "Not called")
         } else {
             XCTFail("Delay interrupted")
         }
    }

}

class SearchTrainPresenterMockTest: InteractorToPresenterProtocol {
    var fetchedStationListCalled = false

    func showNoInterNetAvailabilityMessage() {
    }

    func showNoTrainAvailbilityFromSource() {
    }

    func fetchedTrainsList(trainsList: [StationTrain]?) {
    }

    func stationListFetched(list: [Station]) {
        fetchedStationListCalled = true
    }
}
