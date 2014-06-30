//
//  FGViewController.m
//  FGProgressDemo
//
//  Created by wangzz on 14-6-28.
//  Copyright (c) 2014年 foogry. All rights reserved.
//

#import "FGViewController.h"
#import "FGProgress.h"


@interface FGViewController ()
{
    FGProgress *_pro;
}

@end

@implementation FGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStartButtonAction:(UIButton *)sender
{
    if (_pro.isAnimating) {
        [_pro removeAnimation];
        [_pro removeFromSuperview];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    } else {
        _pro = [[FGProgress alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
        [self.view addSubview:_pro];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    }
}



@end
