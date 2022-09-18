//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 15/09/22.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let coin: CoinModel
    private let imageService: CoinImageService
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageService = CoinImageService(coin: coin)
        addSubcribers()
        isLoading = true
    }
    
    private func addSubcribers(){
        imageService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
