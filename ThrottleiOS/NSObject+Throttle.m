//
//  NSObject+Throttle.m
//  ThrottleiOS
//
//  Created by z on 15/9/30.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

#import "NSObject+Throttle.h"
#import <objc/runtime.h>
#import <objc/message.h>

static char WZThrottledSelectorKey;
static char WZThrottledSerialQueue;

@implementation NSObject (Throttle)

- (void)wz_performSelector:(SEL)aSelector withThrottle:(NSTimeInterval)inteval
{
    dispatch_async([self getSerialQueue], ^{
        NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &WZThrottledSelectorKey) mutableCopy];
        
        if (!blockedSelectors) {
            blockedSelectors = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(self, &WZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        NSString *selectorName = NSStringFromSelector(aSelector);
        if (![blockedSelectors objectForKey:selectorName]) {
            [blockedSelectors setObject:selectorName forKey:selectorName];
            objc_setAssociatedObject(self, &WZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                objc_msgSend(self, aSelector);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(inteval * NSEC_PER_SEC)), [self getSerialQueue], ^{
                    [self unlockSelector:selectorName];
                });
            });
        }
    });
}

#pragma mark - 
- (void)unlockSelector:(NSString *)selectorName
{
    dispatch_async([self getSerialQueue], ^{
        NSMutableDictionary *blockedSelectors = [objc_getAssociatedObject(self, &WZThrottledSelectorKey) mutableCopy];
        
        if ([blockedSelectors objectForKey:selectorName]) {
            [blockedSelectors removeObjectForKey:selectorName];
        }
        
        objc_setAssociatedObject(self, &WZThrottledSelectorKey, blockedSelectors, OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

- (dispatch_queue_t)getSerialQueue
{
    dispatch_queue_t serialQueur = objc_getAssociatedObject(self, &WZThrottledSerialQueue);
    if (!serialQueur) {
        serialQueur = dispatch_queue_create("com.satanwoo.throttle", NULL);
        objc_setAssociatedObject(self, &WZThrottledSerialQueue, serialQueur, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return serialQueur;
}

@end
