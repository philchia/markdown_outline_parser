//
//  ZGOutline.m
//  Markdown
//
//  Created by Phil Chia on 3/15/16.
//  Copyright © 2016 TouchDream. All rights reserved.
//

#import "ZGOutline.h"

@implementation ZGOutline

- (instancetype)initWithNodes:(NSArray *)nodes {
	self = [super init];
	if (self) {
		self.nodes = [NSArray arrayWithArray:nodes];
	}
	return self;
}

+ (instancetype)outlineWithNodes:(NSArray *)nodes {
	return [[[self class] alloc] initWithNodes:nodes];
}

@end