//
//  ViewController.m
//  ThrottleiOS
//
//  Created by z on 15/9/30.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Throttle.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) + 1)];
    //[self wz_performSelector:@selector(testThrottle) withThrottle:5.0];
    // Do any additional setup after loading the view, typically from a nib.
}

static int thro = 0;
- (void)testThrottle
{
    NSLog(@"thro is %d", thro);
    thro++;
}

static int withoutThro = 0;
- (void)testWithoutThrottle
{
    NSLog(@"withoutThro is %d", withoutThro);
    withoutThro++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self testWithoutThrottle];
    [self wz_performSelector:@selector(testThrottle) withThrottle:0.25];
}

@end
