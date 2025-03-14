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
    private var lastRequestId: String = ""
    
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
                lastRequestId = converted.requestId
                currentPage = request.pageIndex
                presenter.presentStart()
                isLoading = false
            case .failure(let error):
                presenter.presentErrorState(with: error)
                isLoading = false
            }
        }
    }
    
    func loadArticlePage(with index: Int) {
        let articleId = articles[index].id
        let articleURL = generateArticleSourceURL(
            for: articleId,
            requestId: lastRequestId
        )
        presenter.presentArticlePage(with: articleURL)
    }
    
    func loadArticleSharing(for index: Int) {
        let articleId = articles[index].id
        presenter.presentAticleSharingInfo(
            for: articles[index],
            shareURL: generateArticleSourceURL(
                for: articleId,
                requestId: lastRequestId
            )
        )
    }
    
    private func generateArticleSourceURL(
        for id: Int,
        requestId: String
    ) -> URL? {
        return URL(string: "https://news.myseldon.com/ru/news/index/\(id)?requestId=\(requestId)")
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
