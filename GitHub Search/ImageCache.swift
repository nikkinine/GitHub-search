//
//  ImageCache.swift
//  GitHub Search
//
//  Created by Nikolay B on 26.09.2022.
//

import UIKit

public class ImageCache {
	static let shared = ImageCache()
	private let cachedImages = NSCache<NSString, UIImage>()
	private var responses = [URL: [(UIImage?) -> Swift.Void]]()
	private var requests = [URL: ImageRequest]()
	
	func image(url: URL) -> UIImage? {
		return cachedImages.object(forKey: NSString(string: url.absoluteString))
	}
	
	func image(url: URL, completion: @escaping (UIImage?) -> Swift.Void) {
		if let cachedImage = image(url: url) {
			completion(cachedImage)
			return
		}
		
		if responses[url] != nil {
			responses[url]?.append(completion)
			return
		} else {
			responses[url] = [completion]
		}
		let request = ImageRequest(url: url)
		requests[url] = request
		request.execute { [weak self] (image, error) in
			defer {
				self?.requests.removeValue(forKey: url)
				self?.responses.removeValue(forKey: url)
			}
			guard let image = image, let blocks = self?.responses[url], error == nil else {
				return
			}
			self?.cachedImages.setObject(image, forKey: NSString(string: url.absoluteString))
			for block in blocks {
				DispatchQueue.main.async {
					block(image)
				}
			}
		}
	}
}
