//
//  NewsAssembly.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

import UIKit

enum NewsAssembly {
    static func build() -> UIViewController {
        let presenter = NewsPresenter()
        let dtoConverter = NewsDTOConverter()
        let baseWorker = BaseURLWorker(baseURL: "https://news.myseldon.com/api")
        let newsWorker = NewsService(networking: baseWorker)
        
        let interactor = NewsInteractor(
            presenter: presenter,
            worker: newsWorker,
            converter: dtoConverter
        )
        let view = NewsViewController(interactor: interactor)
        
        presenter.view = view
        
        return view
    }
}
