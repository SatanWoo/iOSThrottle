//
//  NSObject+Throttle.h
//  ThrottleiOS
//
//  Created by z on 15/9/30.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Throttle)

- (void)wz_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval;

@end
