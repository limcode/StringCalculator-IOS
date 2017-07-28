//
//  StringCalculator.h
//  CaculTest
//
//  Created by 韩乾坤 on 2017/7/27.
//  Copyright © 2017年 HQK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringCalculator : NSObject

+ (instancetype)defaultCalculator;
- (NSString *)calculatWithStringFormula:(NSString *)calculatorStr;

@end
