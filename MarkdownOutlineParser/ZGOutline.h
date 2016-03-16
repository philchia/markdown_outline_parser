//
//  ZGOutline.h
//  Markdown
//
//  Created by Phil Chia on 3/15/16.
//  Copyright © 2016 TouchDream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGOutline : NSObject
@property (nonatomic, copy) NSArray *nodes;

- (instancetype)initWithNodes:(NSArray *)nodes;
+ (instancetype)outlineWithNodes:(NSArray *)nodes;
@end

