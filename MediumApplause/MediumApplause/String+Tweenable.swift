//
//  String+Tweenable.swift
//  MediumApplause
//
//  Created by Ken on 29/08/2017.
//  Copyright © 2017 Ken Boucher. All rights reserved.
//

import Foundation
import TweenKit

let alphabetString = "abcdefghijklmnopqrstuvwxyz"

func convertCharacterToInt(_ character: Character) -> Int {
	
	for (index, char) in alphabetString.characters.enumerated() {
		if char == character {
			return index
		}
	}
	
	fatalError("Unable to convert character to int: \(character)")
}

func convertIntToCharacter(_ int: Int) -> Character {
	
	for (index, char) in alphabetString.characters.enumerated() {
		if index == int {
			return char
		}
	}
	
	fatalError("Unable to convert int to character: \(int)")
}

extension Int: Tweenable {
	
	public func lerp(t: Double, end: Int) -> Int {
		print("t = \(t)")
		let intT = Int(t)
		return self + ((end - self) * intT)
	}
	
	public func distanceTo(other: Int) -> Double {
		fatalError("Not implemented")
	}
	
}

extension String: Tweenable {
	
	public func lerp(t: Double, end: String) -> String {
		
		// This is a really naive implementation that doesn't handle edge (or even common) cases
		// If you want to use this in production, you should implement something more robust
		// Long strings also suffer from floating point precision issues
		
		precondition(self.characters.count == end.characters.count)
		
		// 'Snap' near the ends
		if t < 0.00001 {
			return self
		}
		if t > 1 - 0.0005 {
			return end
		}
		
		let fromNumber = self.asNumber()
		let toNumber = end.asNumber()
		
		let interpolated = Double(fromNumber).lerp(t: t, end: Double(toNumber))
		return String(number: Int(interpolated), length: self.characters.count)
	}
	
	init(number: Int, length: Int) {
		
		var characters = [Character]()
		
		for index in (0..<length) {
			
			if index == length-1 {
				let charNum = number % 26
				characters.append( convertIntToCharacter(charNum) )
			}
			else{
				
				let distanceFromEnd = length - index - 1
				var num = number
				(0..<distanceFromEnd).forEach{ _ in
					num /= 26
				}
				num -= 1
				num = num % 26
				characters.append( convertIntToCharacter(num) )
			}
		}
		
		self.init(characters)
	}
	
	func asNumber() -> Int {
		
		var cumulative = 0
		
		for (index, char) in characters.reversed().enumerated() {
			
			var num = convertCharacterToInt(char)
			
			if index == 0 {
				cumulative += num
			}
			else{
				num += 1
				(0..<index).forEach{ _ in
					num *= 26
				}
				cumulative += num
				
			}
		}
		return cumulative
	}
	
	var alphabetLength: Int {
		return alphabetString.characters.count
	}
	
	public func distanceTo(other: String) -> Double {
		fatalError("Not implemented")
	}
}
