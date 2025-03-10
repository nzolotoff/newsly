//
//  ViewController.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

import UIKit

final class NewsViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let title: String = "News"
    }
    
    // MARK: - Fields
    private let interactor: NewsBusinessLogic & NewsDataStore
    
    // MARK: - UI Components
    private let newsTable: UITableView = UITableView()
    
    // MARK: - Lyfecycle
    init(interactor: NewsBusinessLogic & NewsDataStore) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        interactor.loadStart()
    }
    
    // MARK: Methods
    func displayStart() {
        DispatchQueue.main.async {
            self.newsTable.reloadData()
        }
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .systemGray6
        
        configureNavigationBar()
        configureNewsTableView()
    }
    
    private func configureNavigationBar() {
        self.title = Constants.title
    }
    
    private func configureNewsTableView() {
        newsTable.backgroundColor = .clear
        newsTable.separatorStyle = .none
        
        newsTable.delegate = self
        newsTable.dataSource = interactor
        
        newsTable.register(
            ArticleCell.self,
            forCellReuseIdentifier: ArticleCell.reuseIdentifier
        )
        
        view.addSubview(newsTable)
        newsTable.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        newsTable.pinHorizontal(to: view)
        newsTable.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        400
    }
}
