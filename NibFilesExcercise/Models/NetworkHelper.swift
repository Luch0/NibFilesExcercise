//
//  NetworkHelper.swift
//  NibFilesExcercise
//
//  Created by Luis Calle on 12/21/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import Foundation

enum AppError: Error {
    case noData
    case noInternet
    case notAnImage
    case couldNotParseJSON(rawError: Error)
    case badURL(str: String)
    case urlError(rawError: URLError)
    case otherError(rawError: Error)
}

struct NetworkHelper {
    
    private init() { }
    static let manager = NetworkHelper()
    
    let session = URLSession(configuration: .default)
    func performDataTask(with request: URLRequest, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        let myDataTask = session.dataTask(with: request){(data, responcse, error) in
            DispatchQueue.main.async {
                guard let data = data else { errorHandler(AppError.noData); return }
                if let error = error as? URLError {
                    switch error {
                    case URLError.notConnectedToInternet:
                        errorHandler(AppError.noInternet)
                        return
                    default:
                        errorHandler(AppError.urlError(rawError: error))
                    }
                } else {
                    if let error = error {
                        errorHandler(AppError.otherError(rawError: error))
                    }
                }
                completionHandler(data)
            }
        }
        myDataTask.resume()
    }
    
}
