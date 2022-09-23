//
//  NetworkRequest.swift
//  GitHub Search
//
//  Created by Nikolay B on 25.09.2022.
//

import Foundation

// MARK: - NetworkRequest
protocol NetworkRequest: AnyObject {
	associatedtype ModelType
	func decode(_ data: Data) -> ModelType?
	func execute(withCompletion completion: @escaping (ModelType?, Error?) -> Void)
}

extension NetworkRequest {
	func load(_ url: URL, withCompletion completion: @escaping (ModelType?, Error?) -> Void) {
		let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _ , error) -> Void in
			guard let data = data, let value = self?.decode(data) else {
				DispatchQueue.main.async { completion(nil, error) }
				return
			}
			DispatchQueue.main.async { completion(value, nil) }
		}
		task.resume()
	}
}
