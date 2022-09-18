//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 17/09/22.
//

import Foundation
import CoreData


class PortfolioDataService{
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading from Core Data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    func update(coin: CoinModel, amount: Double){
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            
            if amount > 0 {
                uptadePortfolio(entity: entity, amount: amount)
            } else{
                deletePortfolio(entity: entity)
            }
            
        }else{
            addPortfolio(coin: coin, amount: amount)
        }
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching at Portfolio Entities. \(error)")
        }
    }
    
    private func addPortfolio(coin: CoinModel, amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func uptadePortfolio(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func deletePortfolio(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func savePoertfolio(){
        do {
            try container.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func applyChanges(){
        savePoertfolio()
        getPortfolio()
    }
    
}
