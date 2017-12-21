//
//  Project.swift
//  NibFilesExcercise
//
//  Created by Luis Calle on 12/21/17.
//  Copyright © 2017 Luis Calle. All rights reserved.
//

import Foundation

struct ProjectsResponse: Codable {
    let projects: [Project]
}

struct Project: Codable {
    let id: Int
    let name: String
    let covers: CoversWrapper
    let stats: StatsWrapper
}

struct CoversWrapper: Codable {
    let original: String
}

struct StatsWrapper: Codable {
    let views: Int
    let appreciations: Int
    let comments: Int
}

struct ProjectAPIClient {
    
    private init() { }
    static let manager = ProjectAPIClient()
    
    let endpointStr = "https://api.behance.net/v2/projects?"
    let clientID = "36sMSW1kBSmD8qXTTnMJ0rED1lQtid2C"
    
    func getProjects(with searchTerm: String, completionHandler: @escaping ([Project]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let fullURLStr = "\(endpointStr)q=\(searchTerm)&client_id=\(clientID)"
        guard let url = URL(string: fullURLStr) else { errorHandler(AppError.badURL(str: fullURLStr)); return }
        let urlRequest = URLRequest(url: url)
        let parseProjectsData: (Data) -> Void = { (data: Data) in
            do {
                let listOfProjects = try JSONDecoder().decode(ProjectsResponse.self, from: data)
                completionHandler(listOfProjects.projects)
            } catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: parseProjectsData, errorHandler: errorHandler)
    }
    
}
