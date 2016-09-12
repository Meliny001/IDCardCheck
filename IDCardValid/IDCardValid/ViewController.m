//
//  ViewController.m
//  IDCardValid
//
//  Created by HYG_IOS on 16/9/9.
//  Copyright © 2016年 magic. All rights reserved.
//

#import "ViewController.h"
#import "IDCardValid.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *idNumber;
- (IBAction)startCheck;
@property (weak, nonatomic) IBOutlet UILabel *checkMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString * idStr = @"150522198312194292";
    self.idNumber.delegate = self;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self startCheck];
    return YES;
}

- (IBAction)startCheck
{
    NSString * idStr = self.idNumber.text;
    if ([IDCardValid validIDCardWithString:idStr]) {
        self.checkMessage.text = @"身份证合法";
        self.checkMessage.textColor = [UIColor blackColor];
        NSLog(@"身份证合法");
    }else
    {
        self.checkMessage.text = @"身份证不合法";
        self.checkMessage.textColor = [UIColor redColor];
        NSLog(@"身份证不合法");
    }

}
@end
