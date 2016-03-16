//
//  ZGOutlineParser.m
//  Markdown
//
//  Created by Phil Chia on 3/15/16.
//  Copyright © 2016 TouchDream. All rights reserved.
//

#import "ZGOutlineParser.h"
#import <AppKit/AppKit.h>

@implementation ZGOutlineParser {
	NSTimer *parseOutlineDelayTimer;
}

+ (instancetype)sharedParser {
	static ZGOutlineParser *parser = nil;
	if (!parser) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			parser = [[ZGOutlineParser alloc] init];
		});
	}
	return parser;
}

- (void)parseTextView:(NSTextView *)textView withDelay:(NSTimeInterval)delay withCompletionHandler:(void (^)(ZGOutline*))completionHandler {
	[parseOutlineDelayTimer invalidate];
	parseOutlineDelayTimer = nil;
	parseOutlineDelayTimer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(parseText:) userInfo:@{@"next": completionHandler, @"textView": textView} repeats:NO];
}

- (void)parseText:(NSTimer *)timer {
	void(^nextAction)(ZGOutline* outline) = nil;
	NSTextView *textView = nil;
	if (parseOutlineDelayTimer.isValid) {
		nextAction = parseOutlineDelayTimer.userInfo[@"next"];
		textView =  parseOutlineDelayTimer.userInfo[@"textView"];
		[parseOutlineDelayTimer invalidate];
		} else {
			return;
	}
	NSString *string = textView.textStorage.string;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSArray *lines = [string componentsSeparatedByString:@"\n"];
		NSUInteger count = lines.count;
		NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:count];
		NSUInteger start = 0;
		for (NSInteger i = 0; i < lines.count; i ++) {
			NSString *line = lines[i];
			
			if ([line hasPrefix:@"#"]) {
				ZGNode *node = [self parseNode:line ofRange:NSMakeRange(start, line.length)];
				[nodes addObject:node];
			} else if (i + 1 < count && [lines[i + 1] hasPrefix:@"==="] && [lines[i + 1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]].length == 0) {
				ZGNode *node = [[ZGNode alloc] initWithTitle:line level:1 range:NSMakeRange(start, line.length)];
				[nodes addObject:node];
			} else if (i + 1 < count && [lines[i + 1] hasPrefix:@"---"] && [lines[i + 1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]].length == 0) {
				ZGNode *node = [[ZGNode alloc] initWithTitle:line level:2 range:NSMakeRange(start, line.length)];
				[nodes addObject:node];
			}
			start += line.length;
		}
		
		ZGOutline *outline = [ZGOutline outlineWithNodes:nodes];
		dispatch_async(dispatch_get_main_queue(), ^{
			nextAction(outline);
		});
	});
}

- (ZGNode *)parseNode:(NSString *)string ofRange:(NSRange)range {
	NSString *header = [string commonPrefixWithString:@"######" options:NSLiteralSearch];
	NSUInteger level = header.length;
	NSString *title = [string substringFromIndex:level];
	ZGNode *node = [[ZGNode alloc] initWithTitle:title level:level range:range];
	return node;
}

@end
