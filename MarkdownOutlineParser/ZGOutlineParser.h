//
//  ZGOutlineParser.h
//  Markdown
//
//  Created by Phil Chia on 3/15/16.
//  Copyright © 2016 TouchDream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZGNode.h"
#import "ZGOutline.h"

@class NSTextView;
@interface ZGOutlineParser : NSObject

- (void)parseTextView:(NSTextView *)textView withDelay:(NSTimeInterval)delay withCompletionHandler:(void (^)(ZGOutline*))completionHandler;

@end
