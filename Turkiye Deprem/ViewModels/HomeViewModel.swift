//
//  HomeViewModel.swift
//  Turkiye Deprem
//
//  Created by Ahmet OZBERK on 13.01.2025.
//

import Foundation
import Combine


@MainActor
class HomeViewModel: ObservableObject {
    private let turkiyeDepremRepository: TurkiyeDepremRepository
    
    @Published private(set) var turkiyeDepremState: AppState<[TurkiyeDepremModel]> = .loading
    
    private var cancellables = Set<AnyCancellable>()
    
    init(turkiyeDepremRepository: TurkiyeDepremRepository) {
        self.turkiyeDepremRepository = turkiyeDepremRepository
    }
    
    func getDepremler(isRefresh: Bool = false, onCompleted: (() -> Void)? = nil) {
        turkiyeDepremRepository.getDepremler()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if !isRefresh {
                    self?.turkiyeDepremState = result
                    onCompleted?()
                } else {
                    switch result {
                    case .success, .error:
                        self?.turkiyeDepremState = result
                        onCompleted?()
                    case .loading, .refresh:
                        onCompleted?()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

protocol TurkiyeDepremRepository {
    func getDepremler() -> AnyPublisher<AppState<[TurkiyeDepremModel]>, Never>
}

class RealTurkiyeDepremRepository: TurkiyeDepremRepository {
    private let networkService: NetworkService
    
    init() {
        self.networkService = NetworkService()
    }
    
    func getDepremler() -> AnyPublisher<AppState<[TurkiyeDepremModel]>, Never> {
        networkService.getDepremData()
            .map { result -> AppState<[TurkiyeDepremModel]> in
                switch result {
                case .success(let depremler):
                    return .success(depremler)
                case .failure(let error):
                    return .error(error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
