//
//  NetworkService.swift
//  SlashRSlashSwift
//
//  Created by Spencer Alderson on 2019-08-08.
//  Copyright © 2019 Spencer Alderson. All rights reserved.
//

import Foundation

enum HTTPSMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkServiceError: Error {
    case notValidHTTPRespose
    case badRequest
    case unexpectedNetworkResponse
    case decodingError
    case notAValidURL
   
    public var errorDescription: String? {
        switch self {
        case .notValidHTTPRespose:
            return NSLocalizedString("Something went wrong, make sure you're connected to the internet and try again.", comment: "")
        default:
            return "Sorry, something went wrong."
        }
    }
}

//Any object that needs to interact with the networking layer should adhere to this protocol and not access the NetworkManger directly
protocol NetworkServiceInjectable {
    var networkService: NetworkManagerProtocol { get }
}

extension NetworkServiceInjectable {
    var networkService: NetworkManagerProtocol {
        return NetworkService()
    }
}

protocol NetworkManagerProtocol {
    func fetchArticles(completion: @escaping (Result<[Article] , Error>) -> ())
}

fileprivate struct NetworkService: NetworkManagerProtocol {
    
    private let baseUrlString = "https://www.reddit.com/r/"
    
    private func perfromNetworkRequest<T: Decodable>(_ URLString: String,
                                                         httpsMethod: HTTPSMethod,
                                                         completion: @escaping (Result<T, Error>) -> ())  {
        guard let url = URL(string: URLString) else {
            completion(.failure(NetworkServiceError.notAValidURL))
            return
        }
        let request = URLRequest(url: url)
        self.dataTask(with: request, completion: completion)
    }
    
    private func dataTask<T: Decodable>(with request: URLRequest,
                                            completion: @escaping (Result<T, Error>) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkServiceError.notValidHTTPRespose))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkServiceError.badRequest))
                return
            }

            self.decodeData(response: response, data: data, completion: completion)
            }.resume()
    }
    
    private func decodeData<T: Decodable>(response: HTTPURLResponse,
                                          data: Data,
                                          completion: @escaping (Result<T, Error>) -> ()) {
        switch response.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let object = try decoder.decode(T.self, from: data)
                completion(.success(object))
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
                completion(.failure(NetworkServiceError.decodingError))
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' doesn't exsist:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(NetworkServiceError.decodingError))
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' doesn't exsist:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(NetworkServiceError.decodingError))
            } catch DecodingError.typeMismatch(let type, let context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(.failure(NetworkServiceError.decodingError))
            } catch {
                print("error: ", error)
                completion(.failure(NetworkServiceError.decodingError))
            }
        case 400:
            completion(.failure(NetworkServiceError.badRequest))
        default:
            completion(.failure(NetworkServiceError.unexpectedNetworkResponse))
        }
    }
    
    func fetchArticles(completion: @escaping (Result<[Article] , Error>) -> ()) {
        self.perfromNetworkRequest(baseUrlString + "swift/.json", httpsMethod: .get) { (result: Result<Response, Error>) in
            switch result {
            case .success(let response):
                let articles = result.data.children.map{ $0.data }
                completion(.success(articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
