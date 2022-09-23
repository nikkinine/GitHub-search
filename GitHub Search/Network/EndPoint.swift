//
//  EndPoint.swift
//  GitHub Search
//
//  Created by Николай Барышев on 24.09.2022.
//

import Foundation

enum EndPoint {
	case searchRepositories
	case searchUsers
	
	var baseURL: String {
		return "https://api.github.com/"
	}

	var path: String {
		switch self {
		case .searchRepositories:
			return "search/repositories"
		case .searchUsers:
			return "search/users"
		}
	}
	
	func getRequest(parameters: [String: String] = [:]) -> URLRequest? {
		guard var urlComponents = URLComponents(string: baseURL + path) else { return nil }
		let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		urlComponents.queryItems = queryItems
		guard let url = urlComponents.url else { return nil }
		return URLRequest(url: url)
	}
}
