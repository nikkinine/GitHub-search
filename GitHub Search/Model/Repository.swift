//
//  Repository.swift
//  GitHub Search
//
//  Created by Nikolay B on 24.09.2022.
//

import Foundation

struct Repository: Decodable {
	let id: Int
	let name: String
	let description: String?
	let owner_login: String
	let avatarURL: URL
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case owner
	}

	enum OwnerCodingKeys: String, CodingKey {
		case login
		case avatarURL = "avatar_url"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.id = try container.decode(Int.self, forKey: .id)
		self.name = try! container.decode(String.self, forKey: .name)
		self.description = try? container.decode(String.self, forKey: .description)

		let ownerContainer = try container.nestedContainer(keyedBy: OwnerCodingKeys.self, forKey: .owner)
		self.owner_login = try ownerContainer.decode(String.self, forKey: .login)
		self.avatarURL = try ownerContainer.decode(URL.self, forKey: .avatarURL)
	}
}
