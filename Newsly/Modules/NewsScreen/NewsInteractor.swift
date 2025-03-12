//
//  NewsInteractor.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

import UIKit

final class NewsInteractor: NSObject, NewsBusinessLogic & NewsDataStore {
    // MARK: - Fields
    private let presenter: NewsPresentationLogic
    private let worker: NewsWorkerLogic
    private let converter: NewsDTOConverterLogic
    
    private var isLoading: Bool = false
    private var currentPage: Int = 0
    
    var articles: [NewsModel.Article] = []
    
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
        articles.removeAll()
        refresh()
        presenter.presentStart()
    }
    
    func loadMoreNews() {
        guard isLoading != true else {
            return
        }
        
        isLoading = true
        let loadingPage = currentPage + 1
        refresh(
            NewsModel.FetchRequest(
                rubricId: 4,
                pageIndex: loadingPage,
                pageSize: 10
            )
        )
    }
    
    func refresh(
        _ request: NewsModel.FetchRequest = NewsModel.FetchRequest(
            rubricId: 4,
            pageIndex: 1,
            pageSize: 10
        )
    ) {
        worker.fetchNews(for: request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseDTO):
                let converted = self.converter.convert(from: responseDTO)
                articles += converted.news
                currentPage = request.pageIndex
                presenter.presentStart()
                isLoading = false
            case .failure(let error):
                // TODO: write and call function to switch error (presenter logic)
                //
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}

extension NewsInteractor: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return articles.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ArticleCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let articleCell = cell as? ArticleCell else {
            return cell
        }
        
        articleCell.configure(with: articles[indexPath.row])
        
        return articleCell
    }
}
