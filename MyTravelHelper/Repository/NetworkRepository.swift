//
//  NetworkRepository.swift
//  MyTravelHelper
//
//  Created by Chinthan on 09/08/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation

protocol NetworkRepositoryProtocol {
    func fetchAllStations(resultHandler: @escaping (Result<Stations, ErrorMessages>) -> Void)
    func fetchTrainsFromSource( sourceCode: String,
                               resultHandler: @escaping (Result<[StationTrain], ErrorMessages>) -> Void)
    func processTrainListforDestinationCheck(code: String, date: String,
                                             resultHandler: @escaping (Result<TrainMovementsData, ErrorMessages>) -> Void)
}

class NetworkRepository {
    let networkClient: NetworkClient = NetworkClient()
    private let baseURLString = "http://api.irishrail.ie/"

    private func getBaseUrl() -> URL {
        guard let url = URL(string: baseURLString) else {
            fatalError("Invalid base URL")
        }
        return url
    }

    private func createAllStationsRequest() -> URLRequest {
        var allStation = getBaseUrl()
        allStation.addPath("/realtime/realtime.asmx/getAllStationsXML")
        return URLRequest(url: allStation)
    }

    private func createFetchTrainRequest(for sourceCode: String) -> URLRequest {
        var getStationDataByCodeXML = getBaseUrl()
        getStationDataByCodeXML.addPath("/realtime/realtime.asmx/getStationDataByCodeXML")
        getStationDataByCodeXML.appendQueryItem("StationCode", value: sourceCode)
        return URLRequest(url: getStationDataByCodeXML)
    }

    private func createFetchTrainRequest(for code: String, date: String) -> URLRequest {
        var getStationDataByCodeXML = getBaseUrl()
        getStationDataByCodeXML.addPath("/realtime/realtime.asmx/getStationDataByCodeXML")
        getStationDataByCodeXML.appendQueryItem("StationCode", value: code)
        return URLRequest(url: getStationDataByCodeXML)
    }
}

extension NetworkRepository: NetworkRepositoryProtocol {
    func fetchAllStations(resultHandler: @escaping (Result<Stations, ErrorMessages>) -> Void) {
        networkClient.perform(createAllStationsRequest(),
                                  decode: Stations.self) { (result) in
            switch result {
            case .success(let stations):
                resultHandler(.success(stations))
            case .failure(let error):
                let error = error as NSError
                switch error.code {
                case -1009:
                    resultHandler(.failure(.noInternet))
                case 400...404:
                    resultHandler(.failure(.noTrainAvailbilityFromSource))
                default: break
                }
            }
        }
    }

    func fetchTrainsFromSource( sourceCode: String,
                               resultHandler: @escaping (Result<[StationTrain], ErrorMessages>) -> Void) {
        let request = createFetchTrainRequest(for: sourceCode)
        networkClient.perform(request, decode: StationData.self) { (result) in
            switch result {
            case .failure(let error):
                let error = error as NSError
                switch error.code {
                case -1009:
                    resultHandler(.failure(.noInternet))
                case 400...404:
                    resultHandler(.failure(.noTrainsFound))
                default: break
                }
            case .success(let stationData):
                if stationData.trainsList.count > 0 {
                    resultHandler(.success(stationData.trainsList))
                } else {
                    resultHandler(.failure(.noTrainsFound))
                }
            }
        }
    }

    func processTrainListforDestinationCheck(code: String, date: String,
                                             resultHandler: @escaping (Result<TrainMovementsData, ErrorMessages>) -> Void) {
        let request = createFetchTrainRequest(for: code, date: date)
        networkClient.perform(request,
                                  decode: TrainMovementsData.self) { (result) in
            switch result {
            case .failure(let error):
                let error = error as NSError
                switch error.code {
                case -1009:
                    resultHandler(.failure(.noInternet))
                case 400...404:
                    resultHandler(.failure(.noTrainsFound))
                default: break
                }
            case .success(let trainMovements):
                resultHandler(.success(trainMovements))
            }
        }
    }
}
