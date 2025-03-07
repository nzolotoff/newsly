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
    
    func refresh(_ request: NewsModel.FetchRequest) {
        worker.fetchNews(
            for: NewsModel.FetchRequest(
                rubricId: request.rubricId,
                pageIndex: request.pageIndex,
                pageSize: request.pageSize
            )
        ) { [weak self] result in
            switch result {
            case .success(let responseDTO):
                let converted = self?.converter.convert(from: responseDTO)
                print(converted ?? NewsModel.NewsResponse(news: [], requestID: ""))
                // TODO: call function to process model
            case .failure(let error):
                // TODO: write and call function to switch error
                //
                print(error.localizedDescription)
                
                
            }
        }
    }
        
    
}
