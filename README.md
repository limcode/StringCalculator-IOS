# StringCalculator-IOS
## 特点
* 支持基础运算 *+* *-* *\** *\\*
* 格式自由 `NSString *calStr = @"1  + 2 * 3/4-  ( 5 +6* (4-1))";`
* 基于*NSDecimalNumber*，高精度、大数值运算
* 使用方便、简单，可扩展性强

## 使用方法
```
[[StringCalculator defaultCalculator] calculatWithStringFormula:@"1  + 2 * 3/4-  ( 5 +6* (4-1))"];
```


