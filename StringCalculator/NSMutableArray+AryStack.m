//
//  NSMutableArray+AryStack.m
//  CaculTest
//
//  Created by 韩乾坤 on 2017/7/27.
//  Copyright © 2017年 HQK. All rights reserved.
//

#import "NSMutableArray+AryStack.h"

@implementation NSMutableArray (AryStack)

- (void)push:(id)obj{
    [self insertObject:obj atIndex:0];
}

- (id)peek{
    return self.firstObject;
}

- (id)pop{
    id popObj = self.firstObject;
    [self removeObjectAtIndex:0];
    return popObj;
}



@end
