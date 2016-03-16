//
//  ZGNode.h
//  Markdown
//
//  Created by Phil Chia on 3/15/16.
//  Copyright © 2016 TouchDream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZGNode : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSRange range;

- (instancetype)initWithTitle:(NSString *)title level:(NSInteger)level range:(NSRange)range;
+ (instancetype)nodeWithTitle:(NSString *)title level:(NSInteger)level range:(NSRange)range;
@end
