//
//  RepoViewController.swift
//  GitHub Search
//
//  Created by Nikolay B on 12.11.2022.
//

import UIKit

class RepoViewController: UIViewController {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var tagsLabel: UILabel!
	@IBOutlet var avatarImageView: UIImageView!
	
	var repository: Repository! = nil
	
	private var request: LanguagesRequest?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let repository = repository {
			self.nameLabel.text = repository.name
			self.descriptionLabel.text = repository.description
			ImageCache.shared.image(url: repository.avatarURL) { [weak self] image in
				self?.avatarImageView.image = image
			}
			let request = LanguagesRequest(owner: repository.owner_login, repo: repository.name)
			self.request = request
			request.execute { [weak self] (languagesResponse, error) in
				guard let self = self else { return }
				let languages = languagesResponse ?? [:]
				let sumBytes = languages.reduce(0) { $0 + $1.value }
				let myString = NSMutableAttributedString(string: "")
				for item in languages {
					let delta = CGFloat(item.value) / CGFloat(sumBytes) * 5
					let myAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16 + delta)]
					myString.append(NSAttributedString(string: item.key + " ", attributes: myAttribute))
					myString.append(NSAttributedString(string: item.key + " ", attributes: myAttribute))
					myString.append(NSAttributedString(string: item.key + " ", attributes: myAttribute))
				}
				self.tagsLabel.attributedText = myString
			}
		}
    }

}
