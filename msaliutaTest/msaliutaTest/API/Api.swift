//
//  Api.swift
//  msaliutaTest
//
//  Created by Maksym Saliuta on 29.07.2020.
//  Copyright © 2020 Maksym Saliuta. All rights reserved.
//

import Foundation
import UIKit

class Api {
    func autorizationRequest(urlString:String, parameters:[String:String], completion: @escaping (Result<ApiResponce,Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let parameters = parameters
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let dataResponse = data else { return }
                do {
                    let project = try JSONDecoder().decode(ApiResponce.self, from: dataResponse)
                    completion(.success(project))
                } catch  let jsonError {
                    print("Failed to decoded JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func projectRequest(urlString:String, parameters:[String:String], completion: @escaping (Result<AppsResponse,Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let parameters = parameters
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let dataResponse = data else { return }
                do {
                    let project = try JSONDecoder().decode(AppsResponse.self, from: dataResponse)
                    completion(.success(project))
                } catch  let jsonError {
                    print("Failed to decoded JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
