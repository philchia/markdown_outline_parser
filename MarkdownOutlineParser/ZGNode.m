//
//  ZGNode.m
//  Markdown
//
//  Created by Phil Chia on 3/15/16.
//  Copyright © 2016 TouchDream. All rights reserved.
//

#import "ZGNode.h"

@implementation ZGNode

- (instancetype)initWithTitle:(NSString *)title level:(NSInteger)level range:(NSRange)range {
	self = [super init];
	if (self) {
		self.title = title;
		self.level = level;
		self.range = range;
	}
	return self;
}

+ (instancetype)nodeWithTitle:(NSString *)title level:(NSInteger)level range:(NSRange)range {
	return [[[self class] alloc] initWithTitle:title level:level range:range];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"\n======\nTitle \n%@\nLevel %ld\n======",self.title, (long)self.level];
}

@end