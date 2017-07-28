//
//  StringCalculator.m
//  CaculTest
//
//  Created by 韩乾坤 on 2017/7/27.
//  Copyright © 2017年 HQK. All rights reserved.
//

#import "StringCalculator.h"
#import <objc/message.h>
#import "NSMutableArray+AryStack.h"

typedef NS_ENUM(NSInteger, OperatorLevel) {
    OperatorLevel_1 = 0,
    OperatorLevel_2,
    OperatorLevel_3,
};

@interface StringCalculator()

@property(strong, nonatomic)NSDictionary *opMethodDic;
@property(strong, nonatomic)NSMutableArray *dList;
@property(strong, nonatomic)NSMutableArray *opStack;

@end

static StringCalculator *_instance;

@implementation StringCalculator

+ (instancetype)defaultCalculator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[StringCalculator alloc] init];
        }
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _opMethodDic = @{@"+":@"decimalNumberByAdding:",
                         @"-":@"decimalNumberBySubtracting:",
                         @"*":@"decimalNumberByMultiplyingBy:",
                         @"/":@"decimalNumberByDividingBy:",};
        
        _dList = @[].mutableCopy;
        _opStack = @[].mutableCopy;
    }
    return self;
}

- (NSString *)calculatWithStringFormula:(NSString *)calculatorStr{
    
    calculatorStr = [calculatorStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\d\\.]+|[\\(\\)\\+\\-\\*\\/]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *results = [regex matchesInString:calculatorStr options:0 range:NSMakeRange(0, [calculatorStr length])];
    
    for (NSTextCheckingResult *result in results) {
        NSString *subStr = [calculatorStr substringWithRange:result.range];
        if ([self isDecimalNumber:subStr]) {
            [_dList addObject:subStr];
        }
        else if ([self isOperator:subStr]){
            [self opstack:subStr];
        }
        else{
//            公式格式错误，存在除四则运算、括号和数字以外的其他字符
            return nil;
        }
    }
    while (_opStack.count) {
        [_dList addObject:[_opStack pop]];
    }
    
    NSString *result = [self cal];
    
    [self clearAry];
    
    return result;
}

- (void)opstack:(NSString *)op{
    //如果是空栈、左括号，则直接压入
    if (!_opStack.count || [@"(" isEqualToString:op]) {
        [_opStack push:op];
    }
    //如果op是右括号则对栈内元素进行出栈操作，直到遇到左括号
    else if ([@")" isEqualToString:op]){
        NSString *tmp_op = @"";
        while (![@"(" isEqualToString:tmp_op=[_opStack pop]]) {
            [_dList addObject:tmp_op];
        }
    }
    else if ([@"(" isEqualToString:[_opStack peek]] || [self comparePriority:op op2:[_opStack peek]]) {
        [_opStack push:op];
    }
    //如果当前元素的优先级低于栈顶元素的优先级
    else if (![self comparePriority:op op2:[_opStack peek]]){
        //如果栈顶不是左括号则进行出栈操作
        [_dList addObject:[_opStack pop]];
        [self opstack:op];
    }
}

- (NSString *)cal{
    for (NSString *str in _dList){
        if([self isDecimalNumber:str]){
            [_opStack push:str];
        }
        else if ([self isOperator:str]){
            NSDecimalNumber *dn1 = [NSDecimalNumber decimalNumberWithString:[_opStack pop]];
            NSDecimalNumber *dn2 = [NSDecimalNumber decimalNumberWithString:[_opStack pop]];
            NSDecimalNumber *dn3 = [dn2 performSelector:NSSelectorFromString(_opMethodDic[str]) withObject:dn1];
            [_opStack push:[dn3 stringValue]];
        }
    }
    
    return _opStack.lastObject;
}

- (void)clearAry{
    [_dList removeAllObjects];
    [_opStack removeAllObjects];
}

- (BOOL)comparePriority:(NSString *)op1 op2:(NSString *)op2{
    return [self getOperatorLevel:op1] > [self getOperatorLevel:op2];
}

- (OperatorLevel)getOperatorLevel:(NSString *)opStr {
    NSDictionary<NSString*, NSNumber*> *dic = nil;
    dic = @{@"+" : @(OperatorLevel_1),
            @"-" : @(OperatorLevel_1),
            @"*" : @(OperatorLevel_2),
            @"/" : @(OperatorLevel_2),
            @"(" : @(OperatorLevel_3),
            @")" : @(OperatorLevel_3)};
    
    return dic[opStr].integerValue;
}

- (BOOL)isDecimalNumber:(NSString *)str{
    NSScanner* scan = [NSScanner scannerWithString:str];
    int val;
    float val2;
    return ([scan scanInt:&val] && [scan isAtEnd]) || ([scan scanFloat:&val2] && [scan isAtEnd]);
}

- (BOOL)isOperator:(NSString *)opStr{
    NSArray *ary = @[@"+", @"-", @"*", @"/", @"(", @")"];
    return [ary containsObject:opStr];
}


@end
