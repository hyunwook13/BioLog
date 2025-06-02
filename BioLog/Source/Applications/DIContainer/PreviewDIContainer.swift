//
//  PreviewDIContainer.swift
//  BioLog
//
//  Created by 이현욱 on 4/14/25.
//

import UIKit

final class PreviewDIContainer {
    
    // MARK: - Properties
    private let book: CompleteBook
    private let bookUseCase: BookUseCase
    
    init(book: CompleteBook, bookUseCase: BookUseCase) {
        self.bookUseCase = bookUseCase
        self.book = book
    }
    
    func makePreviewCoordinator(nav: UINavigationController) -> PreviewCoordinator {
        return PreviewCoordinator(nav: nav, container: self)
    }
    
    func makePreviewViewModel() -> PreviewViewModel {
        return PreviewViewModel(book: book, bookUseCase: bookUseCase)
    }
    
    func makePreviewViewController() -> PreviewViewController {
        let viewModel = makePreviewViewModel()
        return PreviewViewController(viewModel: viewModel)
    }
}
