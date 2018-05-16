//
//  NBNSTeamCollectView.h
//  NBNamiboxApp
//
//  Created by 朱三保 on 2018/1/30.
//  Copyright © 2018年 相颖. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    kCollectLayoutAlignmentLeft,
    kCollectLayoutAlignmentRight
} kCollectLayoutAlignment;

@interface NBNSTeamCollectView : UIView
/** 开启scrollview滚动 default NO*/
@property (nonatomic, assign) BOOL                  scrollEnabel;
/** scrollview ,scrollEnabel开启是有效*/
@property (nonatomic, readonly) UIScrollView        *scrollView;
/** 对齐方式，靠左、靠右 */
@property (nonatomic, assign)   kCollectLayoutAlignment alignment;
/** 在kCollectLayoutAlignmentRight靠右对其模式下，索引依旧从左向右升序返回，否则从右向左升序返回 */
@property (nonatomic, assign) BOOL                  indexAscending;
/** 预配置上下左右边距 default : UIEdgeInsetsZero */
@property (nonatomic, assign) UIEdgeInsets          layoutEdgeInsets;
/** 预配置垂直方向间距 */
@property (nonatomic, assign) CGFloat               verticalMargin;
/** 预配置水平方向间距 */
@property (nonatomic, assign) CGFloat               horizoneMargin;
/** 自适应大小，item宽度自适应，容器宽度自适应,需先于numberOfItemEachLine设置,优先级高于itemWidth */
@property (nonatomic, assign) BOOL                  contentInstricFit;
/** 另一种给定item宽度的布局方式，容器宽度自适应，外部不要设置容器宽度,需先于numberOfItemEachLine设置 */
@property (nonatomic, assign) CGFloat               itemWidth;
/** width÷height比例 默认1.0 方形 */
@property (nonatomic, assign) CGFloat               wh_ratio;
/** 预配置布局view类 */
@property (nonatomic, copy)   NSString              *layoutClassName;
/** 每行多少个item 在numberOfItems之前设置*/
@property (nonatomic, assign) NSUInteger            numberOfItemEachLine;
/** 总共多少个item，最后设置的属性 放到最后设置*/
@property (nonatomic, assign) NSUInteger            numberOfItems;
/** 外部传入view视图，无需自动生成(此时设置layoutClassName无效)，需放到numberOfItems设置之前 */
@property (nonatomic, copy) __kindof UIView *(^viewForIndex)(NSInteger index);
//刷新某一个item
- (void)reloadItemAtIndex:(NSInteger)index item:(void(^)(UIView *cell))itemBlock;
/** 全部刷新 */
- (void)reloadDataForItems:(void(^)(UIView *cell, NSInteger idx))itemBlock;
/** 查找索引 */
- (NSInteger)indexForItem:(UIView *)item;
@end
