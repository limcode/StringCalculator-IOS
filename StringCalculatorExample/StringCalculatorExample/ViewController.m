//
//  ViewController.m
//  StringCalculatorExample
//
//  Created by 韩乾坤 on 2017/7/28.
//  Copyright © 2017年 limhan. All rights reserved.
//

#import "ViewController.h"
#import "StringCalculator.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *calLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *calFiled;
@property (weak, nonatomic) IBOutlet UIButton *calBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location != NSNotFound) {
        NSMutableString *txt = textField.text.mutableCopy;
        [txt replaceCharactersInRange:range withString:string];
        _calLabel.text = txt;
    }
    return YES;
}


- (IBAction)startCal:(id)sender {
    _resultLabel.text = [[StringCalculator defaultCalculator] calculatWithStringFormula:_calLabel.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
