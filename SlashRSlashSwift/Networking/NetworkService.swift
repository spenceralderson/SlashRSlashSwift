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

private enum NetworkServiceError: Error {
    case notValidHTTPRespose
    case badRequest
    case unexpectedNetworkResponse
    case notAValidURL
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
    
    private func perfromNetworkRequest<T: Decodable>(_ URLString: String,
                                                         httpsMethod: HTTPSMethod,
                                                         completion: @escaping (T?, Error?) -> ())  {
        guard let url = URL(string: URLString) else {
            completion(nil, NetworkServiceError.notAValidURL)
            return
        }
        let request = URLRequest(url: url)
        self.dataTask(with: request, completion: completion)
    }
    
    private func decodeData<T: Decodable>(httpResponse: HTTPURLResponse,
                                              data: Data,
                                              completion: @escaping (T?, Error?) -> ()) {
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(T.self, from: data)
                completion((object), nil)
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' doesn't exsist:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' doesn't exsist:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        case 400:
            completion(nil, NetworkServiceError.badRequest)
        default:
            completion(nil, NetworkServiceError.unexpectedNetworkResponse)
        }
    }
    
    private func dataTask<T: Decodable>(with request: URLRequest,
                                            completion: @escaping (T?, Error?) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NetworkServiceError.notValidHTTPRespose)
                return
            }
            guard let data = data else {
                completion(nil, NetworkServiceError.badRequest)
                return
            }
            self.decodeData(httpResponse: httpResponse, data: data, completion: completion)
            }.resume()
    }
    
    func fetchArticles(completion: @escaping (Result<[Article] , Error>) -> ()) {
        self.perfromNetworkRequest("https://www.reddit.com/r/swift/.json", httpsMethod: .get) { (result: Response?, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let result = result else {
                    completion(.failure(NetworkServiceError.unexpectedNetworkResponse))
                    return
                }
                let articles = result.data.children.map{ $0.data }
                completion(.success(articles))
            }
        }
    }
}
