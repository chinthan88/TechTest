//
//  SearchTrainProtocols.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

enum ErrorMessages: Error {
    case noInternet
    case noTrainsFound
    case noTrainAvailbilityFromSource
    case invalidSourceAndDestination
}

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func fetchallStations()
    func searchTapped(source: String, destination: String)
}

protocol PresenterToViewProtocol: AnyObject {
    func saveFetchedStations(stations: [Station]?)
    func showInvalidSourceOrDestinationAlert()
    func updateLatestTrainList(trainsList: [StationTrain])
    func showErrorMessage(for Error: ErrorMessages)
}

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> SearchTrainViewController
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? {get set}
    var networkRepository: NetworkRepositoryProtocol? {get set}
    var localDataRepository: LocalDataRepositoryProtocol? {get set}
    func fetchallStations()
    func fetchTrainsFromSource(sourceCode: String, destinationCode: String)
}

protocol InteractorToPresenterProtocol: AnyObject {
    func stationListFetched(list: [Station])
    func fetchedTrainsList(trainsList: [StationTrain]?)
    func showErrorMessage(for Error: ErrorMessages)
}
