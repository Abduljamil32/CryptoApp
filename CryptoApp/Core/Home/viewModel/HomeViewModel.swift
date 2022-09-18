//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 14/09/22.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: ObservableObject{
    
    @Published var statistics: [StatisticsModel] = [
        StatisticsModel(title: "Title", value: "value", percentageChange: 1),
        StatisticsModel(title: "title", value: "value"),
        StatisticsModel(title: "title", value: "Value"),
        StatisticsModel(title: "title", value: "value", percentageChange: -6)
        ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = DataService()
    private let marketDataSevice = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    enum SortOption{
        case rank, rankDown, holdings, holdingsDown, price, priceDown
    }
    
    func addSubscribers(){
        
       
        coinDataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        //updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(sortAndFilterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [CoinModel] in
                  coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoins(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataSevice.$marketData
            .combineLatest($portfolioCoins)
            .map{ (marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] in
                var stats: [StatisticsModel] = []
                
                guard let data = marketDataModel else { return stats }
                
                let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                let volume = StatisticsModel(title: "24h Volume", value: data.volume)
                let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolioValue = portfolioCoins
                    .map({ $0.currentHoldingsValue  })
                    .reduce(0, +)
                
                let perviousValue = portfolioCoins
                    .map { (coin) -> Double in
                        let currentValue = coin.currentHoldingsValue
                        let percentageChange = coin.priceChangePercentage24H ?? 0/100
                        let previousValue = currentValue / (1 + percentageChange)
                        return previousValue
                    }
                    .reduce(0, +)
                
                let percentageChange = ((portfolioValue - perviousValue) / perviousValue) * 100
                
                let portfolio = StatisticsModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
                
                stats.append(contentsOf: [
                    marketCap, volume, btcDominance, portfolio
                ])
                return stats
            }
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    
    }
    
    
    private func sortAndFilterCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel]{
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoins)
//        sort
        
        return filteredCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins 
        }
        
        let lowercaseText = text.lowercased()
        
        return coins.filter{ (coin) -> Bool in
            return coin.name.lowercased().contains(lowercaseText) ||
            coin.symbol.lowercased().contains(lowercaseText) ||
            coin.id.lowercased().contains(lowercaseText)
        }
    }
 
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank})
        case .rankDown, .holdingsDown:
            coins.sort(by: { $0.rank > $1.rank})
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice})
        case .priceDown:
            coins.sort(by: { $0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoins(coins: [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsDown:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    
    func uptadePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.update(coin: coin, amount: amount)
    }
    
    
    func reloadData(){
        isLoading = true
        coinDataService.getData()
        marketDataSevice.getData()
    }
    
    
    
}
