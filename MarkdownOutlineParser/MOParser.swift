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
	var line: Int
	
	public var description: String {
		return "\(title) level \(level) line \(line)"
	}
	
	init() {
		title = ""
		level = 0
		line = 0
	}
	
	init(title: String, level: Int, line: Int) {
		self.title = title
		self.level = level
		self.line = line
	}
	
}

public class MOParser {
	static let sharedParser = MOParser()
	
	public func parseMarkdownOutline(text: String) -> Outline {
		let outline = Outline()
		let lines = text.componentsSeparatedByString("\n")
		for (line, str) in lines.enumerate() {
			if str.hasPrefix("#") {
				let node = parseNode(str, line: line)
				outline.appendNode(node)
			}
		}
		return outline
	}
	
	public func parseMarkdownOutline(text: String, completion: (Outline)->(Void)) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			let outline = Outline()
			let lines = text.componentsSeparatedByString("\n")
			for (line, str) in lines.enumerate() {
				if str.hasPrefix("#") {
					let node = self.parseNode(str, line: line)
					outline.appendNode(node)
				}
			}
			dispatch_async(dispatch_get_main_queue(), {
				completion(outline)
			})
		}
		
		
	}
	
	private func parseNode(text: String, line: Int) -> Node {
		let node = Node(title: text, level: 0, line: line)
		while node.title != nil && node.title!.hasPrefix("#") {
			node.level++
			node.title = node.title!.substringFromIndex(text.startIndex.advancedBy(1))
		}
		return node
	}
}