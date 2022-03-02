    //
    //  Network.swift
    //  ShoppingApp
    //
    //  Created by Morteza on 2/27/22.
    //

import Foundation
import Combine

protocol NetworkClient {
    var session: URLSession { get }
    func request<T: Requestable>(req: T) -> AnyPublisher<T.ResponseType, Error>
}

class Network: NetworkClient {
    
    var session: URLSession
    var observers = Set<AnyCancellable>()
    var baseURL = "https://api.codebazan.ir/"
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func request<T>(req: T) -> AnyPublisher<T.ResponseType, Error> where T : Requestable {
        let request = prepareRequest(req)
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .retry(2)
            .decode(type: T.ResponseType.self, decoder: JSONDecoder())

            .eraseToAnyPublisher()
    }
    
}

extension Network {
    private func prepareRequest<T: Requestable>(_ req: T) -> URLRequest {
        
        let url = URL(string: baseURL + req.path)!
        var request = URLRequest(url: url)
        request.httpMethod = req.method.rawValue
        
        if req.method == .post {
            let jsonData = try? JSONSerialization.data(withJSONObject: req.parameters, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        return request
    }
}

