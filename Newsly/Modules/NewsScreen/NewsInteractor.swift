//
//  NewsInteractor.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//


final class NewsInteractor: NewsBusinessLogic {
    // MARK: - Fields
    private let presenter: NewsPresentationLogic
    private let worker: NewsWorkerLogic
    private let converter: NewsDTOConverterLogic
    
    
    // MARK: - Lifecycle
    init(
        presenter: NewsPresentationLogic,
        worker: NewsWorkerLogic,
        converter: NewsDTOConverterLogic
    ) {
        self.presenter = presenter
        self.worker = worker
        self.converter = converter
    }
    
    // MARK: - Methods
    func loadStart() {
        presenter.presentStart()
    }
}
