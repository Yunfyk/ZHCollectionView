//
//  ViewController.m
//  ZHCustomCollect
//
//  Created by 朱三保 on 2018/1/30.
//  Copyright © 2018年 zhusanbao. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "NBNSTeamCollectView.h"
#import "TestView.h"

@interface ViewController ()

@property (nonatomic, weak) NBNSTeamCollectView *collect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"start load");
    NBNSTeamCollectView *collect = [[NBNSTeamCollectView alloc] init];
    _collect = collect;
    collect.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:collect];
    collect.indexAscending = YES;
    collect.alignment      = kCollectLayoutAlignmentRight;
    collect.horizoneMargin = 5;
    collect.verticalMargin = 5;
    collect.layoutEdgeInsets = UIEdgeInsetsMake(10, 8, 10, 8);
    collect.layoutClassName= NSStringFromClass([TestView class]);
//    collect.viewForIndex = ^__kindof UIView *(NSInteger index) {
//        return [[TestView alloc] init];
//    };
//    collect.contentInstricFit = YES;
    collect.scrollEnabel = YES;
//    collect.itemWidth   = 36;
    collect.numberOfItemEachLine = 4;
    collect.numberOfItems  = 14;
    collect.wh_ratio       = 1;
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(self.view).multipliedBy(0.68);
//        make.width.mas_lessThanOrEqualTo(self.view).multipliedBy(0.8);
        make.height.mas_lessThanOrEqualTo(500);
    }];
    [collect reloadDataForItems:^(UIView *cell, NSInteger idx) {
        NSLog(@"%@, idx : %ld",cell,idx);
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        collect.numberOfItems = 25;
//    });
//    [collect reloadItemAtIndex:10 item:^(UIView *cell) {
//        NSLog(@"%@, idx : %d",cell,cell.tag);
//    }];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        _collect.numberOfItemEachLine = 6;
    }else{
        _collect.numberOfItemEachLine = 6;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
