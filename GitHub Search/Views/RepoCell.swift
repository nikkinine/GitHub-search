//
//  RepoCell.swift
//  GitHub Search
//
//  Created by Nikolay B on 24.09.2022.
//

import UIKit

class RepoCell: UITableViewCell {
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var avatarImageView: UIImageView!
	var avatarUrl: URL?
	
//	var onReuse: () -> Void = {}
	override func prepareForReuse() {
		super.prepareForReuse()
//		onReuse()
		avatarImageView.image = nil
	}
}
