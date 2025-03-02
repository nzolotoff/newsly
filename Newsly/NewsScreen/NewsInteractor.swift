//
//  NewsInteractor.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//


final class NewsInteractor: NewsBusinessLogic {
    // MARK: - Fields
    private let presenter: NewsPresentationLogic
    
    // MARK: - Lifecycle
    init(presenter: NewsPresentationLogic) {
        self.presenter = presenter
    }
    
    // MARK: - Methods
    func loadStart() {
        presenter.presentStart()
    }
}
