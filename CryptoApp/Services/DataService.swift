//
//  DataService.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 14/09/22.
//

import Foundation
import Combine


class DataService{
    
    @Published var allCoins: [CoinModel] = []
    var cancellabes = Set<AnyCancellable>()
    
    var coinSunbscription: AnyCancellable?
    
    init(){
        getData()
        
    }
    
    func getData(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        
        coinSunbscription = Networking.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: Networking.handleCompletion, receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSunbscription?.cancel()
            })
    } 
}
