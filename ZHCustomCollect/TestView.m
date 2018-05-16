//
//  TestView.m
//  ZHCustomCollect
//
//  Created by 朱三保 on 2018/1/30.
//  Copyright © 2018年 zhusanbao. All rights reserved.
//

#import "TestView.h"
#import "Masonry.h"

@implementation TestView{
    UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%100+100)/255.0 green:0.3 blue:0.3 alpha:1];
        label = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 30, 30)];
        label.numberOfLines = 0;
//        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)didMoveToWindow{
    self.index = self.tag;
    [super didMoveToWindow];
}

- (void)setIndex:(NSInteger)index{
    label.text = [NSString stringWithFormat:@"%ld",index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
