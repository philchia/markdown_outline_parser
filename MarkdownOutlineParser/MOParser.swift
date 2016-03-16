//
//  MOParser.swift
//  MarkdownOutlineParser
//
//  Created by Phil Chia on 3/14/16.
//  Copyright © 2016 philchia. All rights reserved.
//

import Foundation

public class Outline{
	lazy var nodes: [Node] = [Node]()
	
	func appendNode(node: Node) {
		self.nodes.append(node)
	}
	
}

public class Node: CustomStringConvertible{
	var title: String?
	var level: Int
	var range: NSRange
	
	public var description: String {
		return "\(title) level \(level) range \(range)"
	}
	
	init() {
		title = ""
		level = 0
		range = NSMakeRange(0, 0)
	}
	
	init(title: String, level: Int, range: NSRange) {
		self.title = title
		self.level = level
		self.range = range
	}
	
}

public class MOParser {
	static let sharedParser = MOParser()
	
	public func parseMarkdownOutline(text: String) -> Outline {
		let outline = Outline()
		let lines = text.componentsSeparatedByString("\n")
		let count = lines.count
		var start = 0
		for (line, str) in lines.enumerate() {
			if str.hasPrefix("#") {
				let node = parseNode(str, range: NSMakeRange(start, str.characters.count))
				outline.appendNode(node)
			} else if line + 1 < count && lines[line].hasPrefix("===") && lines[line].stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "=")).characters.count == 0 {
				let node = Node(title: str, level: 1, range: NSMakeRange(start, str.characters.count))
				outline.appendNode(node)
			} else if line + 1 < count && lines[line].hasPrefix("---") && lines[line].stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "-")).characters.count == 0 {
				let node = Node(title: str, level: 2, range: NSMakeRange(start, str.characters.count))
				outline.appendNode(node)
			}
			start = start + str.characters.count
		}
		return outline
	}
	
	public func parseMarkdownOutline(text: String, completion: (Outline)->(Void)) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			let outline = self.parseMarkdownOutline(text)
			dispatch_async(dispatch_get_main_queue(), {
				completion(outline)
			})
		}
	}
	
	private func parseNode(text: String, range: NSRange) -> Node {
		let header = text.commonPrefixWithString("######", options: NSStringCompareOptions.LiteralSearch)
		let level = header.characters.count
		let node = Node(title: header, level: level, range: range)
		return node
	}
}