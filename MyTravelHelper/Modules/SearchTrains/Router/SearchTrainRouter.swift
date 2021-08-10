//
//  SearchTrainRouter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
class SearchTrainRouter: PresenterToRouterProtocol {
    static func createModule() -> SearchTrainViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "searchTrain") as! SearchTrainViewController
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = SearchTrainPresenter()
        let interactor: PresenterToInteractorProtocol = SearchTrainInteractor()
        let router: PresenterToRouterProtocol = SearchTrainRouter()
        let networkRepository: NetworkRepositoryProtocol = NetworkRepository()
        let localDataRepository: LocalDataRepositoryProtocol = LocalDataRepository()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.networkRepository = networkRepository
        interactor.localDataRepository = localDataRepository
        return view
    }

    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
