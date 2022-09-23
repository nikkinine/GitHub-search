//
//  LanguagesRequest.swift
//  GitHub Search
//
//  Created by Nikolay B on 12.11.2022.
//

import Foundation

typealias LanguagesResponse = [String: Int]

class LanguagesRequest {
	let owner: String
	let repo: String
	
	init(owner: String, repo: String) {
		self.owner = owner
		self.repo = repo
	}
}

extension LanguagesRequest: NetworkRequest {
	func decode(_ data: Data) -> LanguagesResponse? {
		do {
			if let res = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? LanguagesResponse {
				return res
			}
		} catch {
			print("Something went wrong")
		}
		return nil
	}
	
	func execute(withCompletion completion: @escaping (LanguagesResponse?, Error?) -> Void) {
		var components = URLComponents(string: "https://api.github.com")!
		components.path = "/repos/" + owner + "/" + repo + "/languages"
		load(components.url!, withCompletion: completion)
	}
}
