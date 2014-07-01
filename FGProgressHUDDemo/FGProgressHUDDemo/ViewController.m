//
//  ViewController.m
//  FGProgressHUDDemo
//
//  Created by wangzz on 14-6-30.
//  Copyright (c) 2014年 FOOGRY. All rights reserved.
//

#import "ViewController.h"
#import "FGProgressHUD.h"

@interface ViewController ()
{
    FGProgressHUD *_hud;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStartButtonAction:(UIButton *)sender
{
    if ([FGProgressHUD isVisible]) {
        [FGProgressHUD dismiss];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        [FGProgressHUD show];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

@end
