//
//  ViewController.swift
//  GitHub Search
//
//  Created by Nikolay B on 23.09.2022.
//

import UIKit

class ViewController: UIViewController {
	fileprivate var repositories: [Repository] = [] {
		didSet {
			self.repoTableView.reloadData()
		}
	}
	var timer: Timer?
	private var request: SearchRequest?

	// - User Interface
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet var repoTableView: UITableView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var tableView: UITableView!
	
	@IBAction func searchButtonTapped(_ sender: Any) {
		search()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.searchBar.delegate = self
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.activityIndicator.hidesWhenStopped = true
		self.activityIndicator.isHidden = true
	}
}

extension ViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.repositories.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as! RepoCell
		let repo = repositories[indexPath.row]
		cell.nameLabel.text = repo.name
		cell.descriptionLabel.text = repo.description
		cell.avatarUrl = repo.avatarURL
		
		ImageCache.shared.image(url: repo.avatarURL) { [weak cell] image in
			if let cell = cell, cell.avatarUrl == repo.avatarURL {
				cell.avatarImageView.image = image
			}
		}
		return cell
	}
}

extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let sb = self.storyboard else { return }
		let vc = sb.instantiateViewController(withIdentifier: "RepoViewController") as! RepoViewController
		vc.repository = repositories[indexPath.row]
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

extension ViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.search), userInfo: nil, repeats: false)
	}

	@objc func search() {
		self.repositories.removeAll()
		guard let query = self.searchBar.text else { return }
		if query == "" { return }
		self.activityIndicator.startAnimating()
		
		let request = SearchRequest(query: query)
		self.request = request
		request.execute { [weak self] (searchResponse, error) in
			self?.repositories = searchResponse?.items ?? []
			self?.activityIndicator.stopAnimating()
		}
	}
}
