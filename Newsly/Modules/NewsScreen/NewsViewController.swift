//
//  ViewController.swift
//  Newsly
//
//  Created by Nikita Zolotov on 01.03.2025.
//

import UIKit
import SafariServices

final class NewsViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let title: String = "News"
        enum Spacing {
            static let s: CGFloat = 8
            static let m: CGFloat = 12
            static let l: CGFloat = 16
        }
        
        enum Size {
            static let estimatedRowHeight: CGFloat = 400
        }
        
        enum Settings {
            static let newsBeforeThePageEnds: Int = 3
            static let animationDuration: Double = 0.5
        }
        
        enum Menu {
            static let title: String = "Share"
            static let image: UIImage? = UIImage(
                systemName: "square.and.arrow.up"
            )
        }
    }
    
    // MARK: - Fields
    private let interactor: NewsBusinessLogic & NewsDataStore
    
    // MARK: - UI Components
    private let newsTable: UITableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var errorView: NewsErrorView?
    private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
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
    
    // MARK: Display logic
    func displayStart() {
        DispatchQueue.main.async { [weak self] in
            self?.newsTable.reloadData()
            self?.errorView?.isHidden = true
            self?.newsTable.isHidden = false
            self?.activityIndicator.stopAnimating()
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Constants.Settings.animationDuration
            ) { [weak self] in
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    func displayArticlePage(_ url: URL) {
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true)
    }
    
    func displaySharingInfo(with content: String) {
        let activityVC = UIActivityViewController(
            activityItems: [content],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }
    
    func displayErrorView(with description: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Constants.Settings.animationDuration
            ) { [weak self] in
                guard let self else { return }
                self.activityIndicator.stopAnimating()
            }
            
            if let existingErrorView = self.errorView {
                existingErrorView.updateDescription(with: description)
                existingErrorView.isHidden = false
                self.newsTable.isHidden = true
                return
            }
            
            let errorView = NewsErrorView(title: description)
            self.errorView = errorView
            
            errorView.buttonAction = { [weak self] in
                self?.activityIndicator.startAnimating()
                self?.interactor.loadStart()
            }
            
            UIView.animate(
                withDuration: Constants.Settings.animationDuration
            ) {
                self.newsTable.isHidden = true
                errorView.isHidden = false
            }
            
            view.addSubview(errorView)
            errorView.pin(to: newsTable)
        }
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .systemGray6
        
        configureNavigationBar()
        configureNewsTableView()
        configureActivityIndicator()
    }
    
    private func configureNavigationBar() {
        self.title = Constants.title
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        activityIndicator.color = .gray
        activityIndicator.pinTop(
            to: view.safeAreaLayoutGuide.topAnchor,
            Constants.Spacing.m
        )
        activityIndicator.pinCenterX(to: view)
    }
    
    private func configureNewsTableView() {
        newsTable.backgroundColor = .clear
        newsTable.separatorStyle = .none
        
        newsTable.delegate = self
        newsTable.dataSource = interactor
        
        newsTable.refreshControl = refreshControl
        refreshControl.addTarget(
            self,
            action: #selector(refreshControlTriggered),
            for: .valueChanged
        )
        newsTable.register(
            ArticleCell.self,
            forCellReuseIdentifier: ArticleCell.reuseIdentifier
        )
        
        view.addSubview(newsTable)
        newsTable.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        newsTable.pinHorizontal(to: view)
        newsTable.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    // MARK: - Actions
    @objc private func refreshControlTriggered() {
        interactor.loadStart()
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        Constants.Size.estimatedRowHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row ==
            (tableView.numberOfRows(inSection: indexPath.section))
            - Constants.Settings.newsBeforeThePageEnds {
            interactor.loadMoreNews()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        interactor.loadArticlePage(with: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let menu = UIContextMenuConfiguration(
                    identifier: nil,
                    previewProvider: nil
                ) { _ in
                    let shareAction = UIAction(
                        title: Constants.Menu.title,
                        image: Constants.Menu.image
                    ) { [weak self] _ in
                        self?.interactor.loadArticleSharing(for: indexPath.row)
                    }
                    
                    return UIMenu(children: [shareAction])
                }
                
                return menu
    }
}
