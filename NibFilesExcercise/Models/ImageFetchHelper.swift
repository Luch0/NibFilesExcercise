//
//  ImageFetchHelper.swift
//  NibFilesExcercise
//
//  Created by Luis Calle on 12/21/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import UIKit

struct ImageFetchHelper {
    private init() {}
    static let manager = ImageFetchHelper()
    
    func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else { errorHandler(AppError.badURL(str: urlStr)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { (data: Data) in
            guard let onlineImage = UIImage(data: data) else { errorHandler(AppError.notAnImage); return }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
