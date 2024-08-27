//
//  MusicViewController.swift
//  GameOfThronesMusicPlayer
//
//  Created by Sergei Anisimov on 12.06.2024.
//

import UIKit

class MusicViewController: UIViewController {

	private lazy var tableView: UITableView = {
		let table = UITableView()
		table.translatesAutoresizingMaskIntoConstraints = false
		table.register(MusicTableViewCell.self, forCellReuseIdentifier: MusicTableViewCell.cellIdentifier)
		return table
	}()

	var songs = [Song]()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setupNavigationBar()
		setUpTableView()
		configureSongs()
	}

	// MARK: - Setup Navigation Bar
	public func setupNavigationBar() {
		title = "Music"
		navigationController?.navigationBar.prefersLargeTitles = false
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.backgroundColor = .clear
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		let editingItem = UIBarButtonItem(title: tableView.isEditing ? "Done" : "Edit", style: .plain, target: self, action: #selector(moveRows))
		editingItem.tintColor = .label
		navigationItem.rightBarButtonItems = [editingItem]
	}

	@objc
	private func moveRows() {
		tableView.setEditing(!tableView.isEditing, animated: true)
		setupNavigationBar()
		tableView.reloadData()
	}

	private func setUpTableView() {
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	func configureSongs() {
		songs.append(Song(name: "Main Title",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones1",
						  trackName: "MainTitle"))
		songs.append(Song(name: "The Red Woman",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones6",
						  trackName: "TheRedWoman"))
		songs.append(Song(name: "Light Of The Seven",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones6",
						  trackName: "LightoftheSeven"))
		songs.append(Song(name: "Mhysa",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones3",
						  trackName: "Mhysa"))
		songs.append(Song(name: "Khaleesi",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones6",
						  trackName: "Khaleesi"))
		songs.append(Song(name: "House of Black and White",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones5",
						  trackName: "HouseofBlackandWhite"))
		songs.append(Song(name: "A Raven From Kings Landing",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones1",
						  trackName: "ARavenFromKingsLanding"))
		songs.append(Song(name: "Winter Is Here",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones7",
						  trackName: "WinterIsHere"))
		songs.append(Song(name: "Mother Of Dragons",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones2",
						  trackName: "WinterIsHere"))
		songs.append(Song(name: "FINALE",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones1",
						  trackName: "Finale"))
		songs.append(Song(name: "Blood of the Dragon",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones5",
						  trackName: "BloodOfTheDragon"))
		songs.append(Song(name: "Dance of the Dragons",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones5",
						  trackName: "DanceOfDragons"))
		songs.append(Song(name: "The Old Gods And The New",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones2",
						  trackName: "TheOldGodsAndTheNew"))
		songs.append(Song(name: "Warrior Of Light",
						  albumName: "Game Of Thrones OST",
						  artistName: "Ramin Djawadi",
						  imageName: "gameofthrones2",
						  trackName: "WarriorOfLight"))
	}
}

// MARK: - Table View
extension MusicViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return songs.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.cellIdentifier, for: indexPath)
		let song = songs[indexPath.row]
		// configure
		var content = cell.defaultContentConfiguration()
		content.text = song.name
		content.secondaryText = song.artistName
		content.imageToTextPadding = 20
		content.image = UIImage(named: song.imageName)
		content.imageProperties.cornerRadius = 8
		content.textProperties.font = .GameOfThrones.basic.size(of: 14)
		content.secondaryTextProperties.font = .GameOfThrones.basic.size(of: 10)
		cell.contentConfiguration = content
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		// MARK: - Present the player
		let position = indexPath.row
		let playerVC = PlayerViewController()
		playerVC.songs = songs
		playerVC.position = position
		playerVC.modalPresentationStyle = .popover
		present(playerVC, animated: true)
	}

	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		songs.swapAt(sourceIndexPath.row, destinationIndexPath.row)
	}
}

