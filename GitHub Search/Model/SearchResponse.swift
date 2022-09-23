//
//  SearchResponse.swift
//  GitHub Search
//
//  Created by Nikolay B on 24.09.2022.
//

struct SearchResponse: Decodable {
	let totalCount: Int
	let incompleteResults: Bool
	let items: [Repository]
	
	enum CodingKeys: String, CodingKey {
		case totalCount = "total_count"
		case incompleteResults = "incomplete_results"
		case items = "items"
	}
}
