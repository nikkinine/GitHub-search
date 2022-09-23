//
//  ImageRequest.swift
//  GitHub Search
//
//  Created by Nikolay B on 12.11.2022.
//

import UIKit

class ImageRequest {
	let url: URL
	
	init(url: URL) {
		self.url = url
	}
}

extension ImageRequest: NetworkRequest {
	func decode(_ data: Data) -> UIImage? {
		return UIImage(data: data)
	}
	
	func execute(withCompletion completion: @escaping (UIImage?, Error?) -> Void) {
		load(url, withCompletion: completion)
	}
}
