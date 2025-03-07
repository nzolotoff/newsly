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
        
    }
    
    // MARK: - Fields
    private let interactor: NewsBusinessLogic
    
    // MARK: - UI Components
    
    // MARK: - Lyfecycle
    init(interactor: NewsBusinessLogic) {
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
        interactor.refresh(NewsModel.FetchRequest(rubricId: 4, pageIndex: 1, pageSize: 10))
    }
    
    // MARK: Methods
    func displayStart() {
        view.backgroundColor = .cyan
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .green
    }
}
