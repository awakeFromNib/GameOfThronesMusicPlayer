//
//  PlayerViewController.swift
//  GameOfThronesMusicPlayer
//
//  Created by Sergei Anisimov on 12.06.2024.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

	public var position: Int = 0
	public var songs: [Song] = []

	var timer: Timer?

	var player: AVAudioPlayer?

	var finish = false

	private lazy var holder: UIView = {
		var holderView = UIView()
		holderView.backgroundColor = .systemBackground
		holderView.translatesAutoresizingMaskIntoConstraints = false
		holderView.frame = view.bounds
		return holderView
	}()

	// MARK: - User Interface elements
	private let albumImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 10
		imageView.clipsToBounds = true
		return imageView
	}()

	private let songNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0 // line wrap

		label.font = .GameOfThrones.basic.size(of: 14)


		return label
	}()

	private let artistNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0 // line wrap
		label.font = .GameOfThrones.basic.size(of: 11)
		return label
	}()

	private lazy var playPauseButton = UIButton()
	private lazy var trackSlider = UISlider()

	override func viewDidLoad() {
		super.viewDidLoad()
		player?.play()
		view.backgroundColor = .systemBackground
		view.addSubview(holder)
		addConstraints()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if holder.subviews.count == 0 {
			configure()
		}
	}

	private func addConstraints() {
		NSLayoutConstraint.activate([
			holder.topAnchor.constraint(equalTo: view.topAnchor),
			holder.leftAnchor.constraint(equalTo: view.leftAnchor),
			holder.rightAnchor.constraint(equalTo: view.rightAnchor),
			holder.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	// MARK: - Configure
	func configure() {
		// MARK: - set up player
		let song = songs[position]
		let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
		do {
			try AVAudioSession.sharedInstance().setMode(.default)
			try AVAudioSession.sharedInstance().setCategory(.playback)
			try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

			guard let urlString = urlString else {
				return
			}

			player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)

			guard let player = player else {
				return
			}
			player.play()

			player.delegate = self

			// MARK: - track timer
			if timer == nil {
				timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
				trackSlider.value = 0.0
				trackSlider.maximumValue = Float(player.duration)
				trackSlider.thumbTintColor = .systemBackground

			}
		}
		catch {
			print("Error occurred")
		}

		// MARK: - Set up user interface elements
		// album cover
		albumImageView.frame = CGRect(x: 10,
									  y: 10,
									  width: holder.frame.size.width-20,
									  height: holder.frame.size.width-20)
		albumImageView.image = UIImage(named: song.imageName)
		holder.addSubview(albumImageView)

		// MARK: - Labels: Song name, album, artist
		songNameLabel.frame = CGRect(x: 10,
									 y: albumImageView.frame.size.height + 10,
									 width: holder.frame.size.width-20,
									 height: 70)

		artistNameLabel.frame = CGRect(x: 10,
									   y: albumImageView.frame.size.height + 10 + 30,
									   width: holder.frame.size.width-20,
									   height: 80)

		songNameLabel.text = song.name
		artistNameLabel.text = song.artistName

		holder.addSubview(songNameLabel)
		holder.addSubview(artistNameLabel)

		// MARK: - Player controls
		let nextButton = UIButton()
		let backButton = UIButton()

		// MARK: - Frame
		let yPosition = artistNameLabel.frame.origin.y + 100 + 50
		let size: CGFloat = 30

		playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
									   y: yPosition,
									   width: size,
									   height: size)

		nextButton.frame = CGRect(x: holder.frame.size.width - size - 100,
								  y: yPosition,
								  width: size,
								  height: size)

		backButton.frame = CGRect(x: 100,
								  y: yPosition,
								  width: size,
								  height: size)

		// MARK: - Add actions
		playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
		nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
		backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

		// MARK: - Styling
		playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
		backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
		nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)

		playPauseButton.tintColor = .label
		backButton.tintColor = .label
		nextButton.tintColor = .label

		holder.addSubview(playPauseButton)
		holder.addSubview(nextButton)
		holder.addSubview(backButton)

		// MARK: - Volume slider
		let volumeSlider = UISlider(frame: CGRect(x: 20,
												  y: holder.frame.size.height-100,
												  width: holder.frame.size.width-40,
												  height: 50))
		let volumeSliderCurrentThumbImage: UIImage = {
			var thumbImage = UIImage()
			thumbImage = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
			return thumbImage
		}()

		volumeSlider.setThumbImage(volumeSliderCurrentThumbImage, for: .normal)
		volumeSlider.minimumValueImage = UIImage(systemName: "speaker.1.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
		volumeSlider.maximumValueImage = UIImage(systemName: "speaker.3.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
		volumeSlider.minimumTrackTintColor = .darkGray
		volumeSlider.minimumValue = 0.0
		volumeSlider.maximumValue = 1.0
		volumeSlider.value = 1.0
		volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
		holder.addSubview(volumeSlider)

		//MARK: - Track slider
		trackSlider.frame = CGRect(x: 20,
								   y: holder.frame.size.height-350,
								   width: holder.frame.size.width-40,
								   height: 140)
		let trackSliderCurrentThumbImage: UIImage = {
			var thumbImage = UIImage()
			thumbImage = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))!.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
			return thumbImage
		}()

		trackSlider.setThumbImage(trackSliderCurrentThumbImage, for: .normal)
		//        trackSlider.isContinuous = true
		trackSlider.minimumTrackTintColor = .darkGray
		trackSlider.value = 0.0
		//        trackSlider.minimumValue = 0
		trackSlider.maximumValue = Float(player!.duration)

		trackSlider.value = Float(player!.currentTime)
		trackSlider.addTarget(self, action: #selector(trackSliderAction), for: .valueChanged)
		holder.addSubview(trackSlider)
	}

	@objc
	private func updateProgress() {
		trackSlider.value = Float(player!.currentTime)

		//elapsedTimeLabel.text = getFormattedTime(timeInterval: player.currentTime)
		//let remainingTime = player.duration - player?.currentTime
		//remainingTimeLabel.text = getFormattedTime(timeInterval: remainingTime)
	}

	@objc func didTapBackButton() {
		if position > 0 {
			position = position - 1
			player?.stop()
			for subview in holder.subviews {
				subview.removeFromSuperview()
			}
			configure()
		}
	}

	@objc func didTapNextButton() {
		if position < (songs.count - 1) {
			position = position + 1
			player?.stop()
			for subview in holder.subviews {
				subview.removeFromSuperview()
			}
			configure()
		}
	}

	@objc func didTapPlayPauseButton() {
		if player?.isPlaying == true {
			// pause
			player?.stop()
			// show play button
			playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)

			// shrink image
			shrinkImage()
//			UIView.animate(withDuration: 0.2, animations: {
//				self.albumImageView.frame = CGRect(x: 30,
//												   y: 30,
//												   width: self.holder.frame.size.width-60,
//												   height: self.holder.frame.size.width-60)
//			})
		}
		else {
			// play
			player?.play()
			playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)

			// increase image size
			expandImage()
//			UIView.animate(withDuration: 0.2, animations: {
//				self.albumImageView.frame = CGRect(x: 10,
//												   y: 10,
//												   width: self.holder.frame.size.width-20,
//												   height: self.holder.frame.size.width-20)
//			})
		}
	}

	private func shrinkImage() {
		UIView.animate(withDuration: 0.2, animations: {
			self.albumImageView.frame = CGRect(x: 30,
											   y: 30,
											   width: self.holder.frame.size.width-60,
											   height: self.holder.frame.size.width-60)
		})
	}

	private func expandImage() {
		UIView.animate(withDuration: 0.2, animations: {
			self.albumImageView.frame = CGRect(x: 10,
											   y: 10,
											   width: self.holder.frame.size.width-20,
											   height: self.holder.frame.size.width-20)
		})
	}

	@objc func didSlideSlider(_ slider: UISlider) {
		let value = slider.value
		player?.volume = value
	}


	// MARK: - Song tracking
	@objc private func trackSliderAction() {
		player?.pause()
		let currentTime = Float64(trackSlider.value)
		player?.currentTime = TimeInterval(currentTime)
		player?.play()
	}



	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if let player = player {
			player.stop()
		}
	}
}

// MARK: - Delegate
extension PlayerViewController: AVAudioPlayerDelegate {

	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if flag == true {
			NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
			player.stop()
			playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
			shrinkImage()
		}
	}
}
