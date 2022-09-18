//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 17/09/22.
//
import Combine
import Foundation

class MarketDataService{
    
    @Published var marketData: MarketDataModel? = nil
    
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    
    func getData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        
        marketDataSubscription = Networking.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: Networking.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data 
                self?.marketDataSubscription?.cancel()
            })
    }
    
    
}
