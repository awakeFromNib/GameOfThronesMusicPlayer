//
//  MusicTableViewCell.swift
//  GameOfThronesMusicPlayer
//
//  Created by Sergei Anisimov on 12.06.2024.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {

	static let cellIdentifier = "MusicTableViewCell"

	private let coverImage: UIImageView = {
		let cover = UIImageView()
		cover.clipsToBounds = true
		cover.contentMode = .scaleAspectFill
		cover.translatesAutoresizingMaskIntoConstraints = false
		return cover
	}()

	private let songLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 15, weight: .regular)
		label.textColor = .secondaryLabel
		return label
	}()

	private let artistLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 15, weight: .light)
		label.textColor = .secondaryLabel
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .orange
		contentView.addSubviews(coverImage, songLabel, artistLabel)
		addConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func addConstraints() {
		NSLayoutConstraint.activate([
			coverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			coverImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
			coverImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),

			songLabel.leftAnchor.constraint(equalTo: coverImage.leftAnchor, constant: 10),
			songLabel.rightAnchor.constraint(equalTo: coverImage.rightAnchor, constant: -10),
			songLabel.topAnchor.constraint(equalTo: coverImage.topAnchor, constant: 10),

			artistLabel.leftAnchor.constraint(equalTo: coverImage.leftAnchor, constant: 10),
			artistLabel.rightAnchor.constraint(equalTo: coverImage.rightAnchor, constant: -10),
			artistLabel.topAnchor.constraint(equalTo: coverImage.topAnchor, constant: 10)
		])
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		coverImage.image = nil
		songLabel.text = nil
		artistLabel.text = nil
	}

//	override func layoutSubviews() {
//		super.layoutSubviews()
//	}
}
