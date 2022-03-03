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
    func request<T: Requestable>(req: T) -> AnyPublisher<T.ResponseType, NetworkError>
}

class Network: NetworkClient {
    
    var session: URLSession
    var anyCancellable = Set<AnyCancellable>()
    var baseURL = "https://api.codebazan.ir/"
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func request<T>(req: T) -> AnyPublisher<T.ResponseType, NetworkError> where T : Requestable {
        let request = prepareRequest(req)
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .retry(2)
            .subscribe(on: DispatchQueue(label: "NetworkRequest", qos: .background))
            .mapError(NetworkError.mappedFromRawError)
            .decode(type: T.ResponseType.self, decoder: JSONDecoder())
            .mapError(NetworkError.jsonDecoderError)
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

enum NetworkError: Error {
    case invalidRequestURL
    case invalidResponse
    case invalidData
    case invalidMetadata
    case unableToRetriveImageLocation
    case unableToMapRequestURL
    case mappedFromRawError(Error)
    case jsonDecoderError(Error)
}

extension NetworkError {
    var message: String {
        switch self {
            case .invalidMetadata:
                return "Invalid metadata"
            case .invalidRequestURL:
                return "Invalid request URL"
            case .invalidData:
                return "Invalid data"
            case .unableToMapRequestURL:
                return "Unable to map request URL"
            case .invalidResponse:
                return "Invalid response"
            case .unableToRetriveImageLocation:
                return "Unable to retrive image location"
            case .mappedFromRawError(let error),
                    .jsonDecoderError(let error):
                return error.localizedDescription
        }
    }
}

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        return "[ERROR] \(self.message)"
    }
}
