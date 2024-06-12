//
//  Extensions.swift
//  GameOfThronesMusicPlayer
//
//  Created by Sergei Anisimov on 12.06.2024.
//

import UIKit

extension UIView {
	func addSubviews(_ views: UIView...) {
		views.forEach({
			addSubview($0)
		})
	}
}
