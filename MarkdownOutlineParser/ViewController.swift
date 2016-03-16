//
//  ViewController.swift
//  MarkdownOutlineParser
//
//  Created by Phil Chia on 3/14/16.
//  Copyright © 2016 philchia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {

	@IBOutlet var textView: NSTextView?
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

}

extension ViewController {
	func textDidChange(notification: NSNotification) {
		print("text did change")
		MOParser.sharedParser.parseMarkdownOutline((self.textView?.textStorage?.string)!) { outline in
			for node in outline.nodes {
				print(node)
			}
		}
	}
}


