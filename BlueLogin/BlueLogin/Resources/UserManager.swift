//
//  UserManager.swift
//  BlueLogin
//
//  Created by Andres Guevara Caprio on 8/17/20.
//  Copyright © 2020 Andres Guevara Caprio. All rights reserved.
//

import Foundation

class UserManager {
    enum UserManagerError : Error {
        case errorRequestingData
        case badRequest
        case errorProcessingData
    }
    static let shared = UserManager()
    let getURL : URL
    private init(){
        guard let getURL = URL(string: "https://randomuser.me/api/") else {
            print("Error creating URL")
            fatalError()
        }
        self.getURL = getURL
    }
    
    func getNewUser(completion: @escaping(Result<[UserInfo], UserManagerError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: getURL) {data, response, error in
            
            if let _ = error {
                completion(.failure(.errorRequestingData))
                return
            } else if
                let jsonData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let userResult = try decoder.decode(UserResult.self, from: jsonData)
                    let newUser = userResult.results
                    completion(.success(newUser))

                } catch {
                    completion(.failure(.errorProcessingData))
                }
            }
        }
        dataTask.resume()
    }
    
}
