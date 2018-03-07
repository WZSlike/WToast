//
//  ViewController.m
//  WToastExample
//
//  Created by 吴泽松 on 2018/3/7.
//  Copyright © 2018年 WZS. All rights reserved.
//

#import "ViewController.h"
#import "WToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(32.5, 60, 300, 50);
    button.backgroundColor = [UIColor orangeColor];
    button.selected = NO;
    [button setTitle:@"显示第一个轻提示" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(32.5, 150, 300, 50);
    button1.backgroundColor = [UIColor orangeColor];
    button1.selected = NO;
    [button1 setTitle:@"显示第二个轻提示" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(play1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

#pragma mark - Actions
- (void)play {
    [[WToast share] showToastWithMessage:@"这是第一个轻提示" duration:1.2];
}

- (void)play1 {
    [[WToast share] showToastWithMessage:@"这是第二个轻提示" duration:1.2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
