//
//  URLSession.swift
//  ImageFeed
//
//  Created by Арина Колганова on 19.11.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let resultData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(resultData))
                    } catch {
                        completion(.failure(NetworkError.urlRequestError(error)))
                    }
                } else {
                    print("TYTYTY")
                    print(data)
                    completion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
            } else {
                completion(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}
