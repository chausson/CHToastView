//
//  CHViewController.m
//  CHToastView
//
//  Created by chausson on 12/28/2018.
//  Copyright (c) 2018 chausson. All rights reserved.
//

#import "CHViewController.h"
#import <CHToastView/CHToastView.h>

@interface CHViewController ()<CHToastViewDelegate>
@property (strong, nonatomic) UIView *textView;
@end

@implementation CHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.textView.backgroundColor = [UIColor whiteColor];
    UILabel *a = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    a.textColor = [UIColor lightTextColor];
    a.font = [UIFont systemFontOfSize:13];
    a.text = @"遮罩演示效果";
    [CHToastView sharedInstance].delegate = self;

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (IBAction)showAction:(id)sender {
    [[CHToastView sharedInstance] showAnimation];
}
- (UIView *)presentView:(CHToastView *)container {
    return self.textView;
}
- (void)toastDidAppear {
    
}
- (void)toastDidClosed {
    
}
@end
