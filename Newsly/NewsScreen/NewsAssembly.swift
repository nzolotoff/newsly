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
        let interactor = NewsInteractor(presenter: presenter)
        let view = NewsViewController(interactor: interactor)
        
        presenter.view = view
        
        return view
    }
}
