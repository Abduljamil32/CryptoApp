//
//  Networking.swift
//  CryptoApp
//
//  Created by Abduljamil SwiftCoder on 15/09/22.
//

import Foundation
import Combine

class Networking{
    
    static func download(url: URL) -> AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( { try handlerURLResponse(output: $0)} )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handlerURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error> ){
        switch completion{
        case.finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
