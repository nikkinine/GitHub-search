//
//  SearchRequest.swift
//  GitHub Search
//
//  Created by Nikolay B on 12.11.2022.
//

import Foundation

class SearchRequest {
	let query: String
	init(query: String) {
		self.query = query
	}
}

extension SearchRequest: NetworkRequest {
	func decode(_ data: Data) -> SearchResponse? {
		let decoder = JSONDecoder()
		let res = try? decoder.decode(SearchResponse.self, from: data)
		return res
	}
	
	func execute(withCompletion completion: @escaping (SearchResponse?, Error?) -> Void) {
		var components = URLComponents(string: "https://api.github.com")!
		components.path = "/search/repositories"
		components.queryItems = [URLQueryItem(name: "q", value: query)]
		load(components.url!, withCompletion: completion)
	}
}
