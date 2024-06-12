//
//  UIFont+Extension.swift
//  GameOfThronesMusicPlayer
//
//  Created by Sergei Anisimov on 12.06.2024.
//

import UIKit

extension UIFont {
	enum GameOfThrones {
		enum basic {
			static func size(of size: CGFloat) -> UIFont {
				return UIFont(name: Constants.GameOfThrones.basic, size: size)!
			}
		}
	}
}

private extension UIFont {
	enum Constants {
		enum GameOfThrones {
			static let basic = "Game of Thrones"
		}
	}
}
