//
//  NBNSTeamCollectView.m
//  NBNamiboxApp
//
//  Created by 朱三保 on 2018/1/30.
//  Copyright © 2018年 相颖. All rights reserved.
//

#import "NBNSTeamCollectView.h"
#import "Masonry.h"
#import <objc/runtime.h>

@interface NBNSTeamCollectView()

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) UIScrollView   *scrollWrapper;
@property (nonatomic, strong) UIView         *contentView;
@property (nonatomic, assign) NSInteger      layoutNumberOfEachLine;

@end

@implementation NBNSTeamCollectView

void setImplicitTagForView(UIView *aView, NSInteger idx){
    objc_setAssociatedObject(aView, "implicit_tag", @(idx), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
NSInteger implicitTagForView(UIView *aView){
    if (!aView) {return NSNotFound;}
    return [objc_getAssociatedObject(aView, "implicit_tag") integerValue];
}

- (NSMutableArray *)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}
- (UIScrollView *)scrollWrapper{
    if (!_scrollWrapper) {
        _scrollWrapper = [[UIScrollView alloc] init];
        _scrollWrapper.scrollEnabled = NO;
        _scrollWrapper.showsHorizontalScrollIndicator = NO;
    }
    return _scrollWrapper;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 100);
        _wh_ratio       = 1.0f;
        _itemWidth      = -1;
        _indexAscending = NO;
        self.layoutEdgeInsets = UIEdgeInsetsZero;
        [self addSubview:self.scrollWrapper];
        [self.scrollWrapper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.height.equalTo(self);
        }];
        [self.scrollWrapper addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            make.width.equalTo(self.scrollWrapper);
            make.height.equalTo(self).priority(900);
        }];
    }
    return self;
}

- (void)setScrollEnabel:(BOOL)scrollEnabel{
    _scrollWrapper.scrollEnabled = scrollEnabel;
}
- (BOOL)scrollEnabel{
    return _scrollWrapper.scrollEnabled;
}
- (UIScrollView *)scrollView{
    return self.scrollEnabel ? _scrollWrapper : nil;
}

- (void)setNumberOfItems:(NSUInteger)numberOfItems{
    if (_numberOfItemEachLine == 0) {NSAssert(0, @"请先设置每行item数量numberOfItemEachLine");}
    if (_numberOfItemEachLine > numberOfItems) {NSAssert(0, @"numberOfItemEachLine不能大于numberOfItems");}
    _numberOfItems = numberOfItems;
    if (_numberOfItems > 0) {
        [self setupViews];
        [self layoutCollectViews];
    }
}
- (void)setWh_ratio:(CGFloat)wh_ratio{
    _wh_ratio = wh_ratio < 0 ? 1.0f : wh_ratio;
}
- (void)setNumberOfItemEachLine:(NSUInteger)numberOfItemEachLine{
    _numberOfItemEachLine = numberOfItemEachLine;
    if (_numberOfItemEachLine > 0 && _numberOfItems >= _numberOfItemEachLine) {
        [self layoutCollectViews];
    }
}

- (BOOL)lastRightAlignmentLineForIndex:(NSInteger)idx{
    if (_numberOfItemEachLine == 0 || kCollectLayoutAlignmentRight != self.alignment) {return NO;}
    if (_numberOfItems - (idx)/_numberOfItemEachLine * _numberOfItemEachLine <= _numberOfItemEachLine) {
        return YES;
    }else{
        return NO;
    }
//    NSInteger count = _numberOfItems - (_numberOfItems/_numberOfItemEachLine * _numberOfItemEachLine);
//    return (_numberOfItems - (idx) <= count && kCollectLayoutAlignmentRight == self.alignment);
}

- (void)layoutCollectViews{
    if (self.itemsArray.count != _numberOfItems) {return;}
    if (_numberOfItems <= 0 || _numberOfItemEachLine > _numberOfItems) {return;}
    if (_layoutNumberOfEachLine == _numberOfItemEachLine) {return;}
    _layoutNumberOfEachLine = _numberOfItemEachLine;
    UIView *tmpView         = nil;
    UIView *baseLineView    = nil;
    for (int i = 0; i < self.itemsArray.count; ++i) {
        UIView *view = self.itemsArray[i];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if ((i == _numberOfItemEachLine - 1 && _numberOfItemEachLine <= _numberOfItems) || (i == _numberOfItems - 1 && _numberOfItemEachLine >= _numberOfItems)) {
                make.right.mas_equalTo(-self.layoutEdgeInsets.right).priority(900);
            }
            if (_contentInstricFit) {
                if (tmpView) {
                    make.width.height.equalTo(tmpView);
                }else if (baseLineView){
                    make.width.height.equalTo(baseLineView);
                }
            }else if (_itemWidth > 0) {
                make.width.mas_equalTo(_itemWidth);
                make.height.mas_equalTo(_itemWidth/_wh_ratio);
            }
            if (i % _numberOfItemEachLine == 0) {
                if ([self lastRightAlignmentLineForIndex:i]) {
                    make.left.mas_equalTo(self.layoutEdgeInsets.left).priority(750);
                }else{
                    make.left.mas_equalTo(self.layoutEdgeInsets.left);
                }
            }else{
                make.left.equalTo(tmpView.mas_right).offset(self.horizoneMargin);
            }
            if (i == _numberOfItems - 1) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-self.layoutEdgeInsets.bottom);
                if (kCollectLayoutAlignmentRight == self.alignment) {
                    make.right.mas_equalTo(-self.layoutEdgeInsets.right);
                }
            }
            if (baseLineView) {
                make.top.equalTo(baseLineView.mas_bottom).offset(self.verticalMargin);
            }else{
                make.top.mas_equalTo(self.layoutEdgeInsets.top);
            }
        }];
        if ((i + 1) % _numberOfItemEachLine == 0) {
            tmpView = nil;
            baseLineView = view;
        }else{
            tmpView = view;
        }
    }
}

- (void)setupViews{
    if (_numberOfItems <= 0) {return;}
    if (self.itemsArray.count != _numberOfItems) {
        _layoutNumberOfEachLine = 0;
        [self.itemsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [(UIView *)obj removeFromSuperview];
        }];
        [self.itemsArray removeAllObjects];
        for (int i = 0; i < _numberOfItems; ++i) {
            [self.itemsArray addObject:[NSNull null]];
        }
        for (int i = 0; i < _numberOfItems; ++i) {
            UIView *view = nil;
            if (self.viewForIndex) {
                view = self.viewForIndex(i);
            }
            if (!view) {
                view = _layoutClassName ? [[NSClassFromString(self.layoutClassName) alloc] init] : [[UIView alloc] init];
            }
            view.tag = i;
            setImplicitTagForView(view, i);
            //左右对齐排列处理
            if (!_indexAscending && [self lastRightAlignmentLineForIndex:i]) {
                NSInteger row = i/_numberOfItemEachLine;
                NSInteger lastLines = _numberOfItems - row * _numberOfItemEachLine;
                NSInteger cunrrentIdx = i + 1 - row * _numberOfItemEachLine;
                NSInteger tag = row * _numberOfItemEachLine + lastLines - cunrrentIdx;
                [self.itemsArray replaceObjectAtIndex:tag withObject:view];
            }else if (!_indexAscending && kCollectLayoutAlignmentRight == self.alignment){
                NSInteger row = i/_numberOfItemEachLine;
                NSInteger tag = row * _numberOfItemEachLine + (_numberOfItemEachLine - (i + 1 - row * _numberOfItemEachLine));
                [self.itemsArray replaceObjectAtIndex:tag withObject:view];
            }else{
                [self.itemsArray replaceObjectAtIndex:i withObject:view];
            }
            
            [self.contentView addSubview:view];
            
//            [view mas_makeConstraints:^(MASConstraintMaker *make) {
//                if (i % _numberOfItemEachLine == 0) {
//                    make.left.mas_equalTo(self.layoutEdgeInsets.left);
//                }else{
//                    make.left.equalTo(tmpView.mas_right).offset(self.horizoneMargin);
//                }
//                if (i == _numberOfItems - 1) {
//                    make.bottom.equalTo(self.contentView.mas_bottom).offset(-self.layoutEdgeInsets.bottom);
//                }
//                if (baseLineView) {
//                    make.top.equalTo(baseLineView.mas_bottom).offset(self.verticalMargin);
//                }else{
//                    make.top.mas_equalTo(self.layoutEdgeInsets.top);
//                }
//            }];
//            [self.itemsArray addObject:view];
//            if ((i + 1) % _numberOfItemEachLine == 0) {
//                tmpView = nil;
//                baseLineView = view;
//            }else{
//                tmpView = view;
//            }
        }
    }
}

- (void)layoutSubviews{
//    UIView *tmp = nil;
    if (_itemWidth <= 0 && !_contentInstricFit) {//没有传入固定宽度或者子视图自适应大小计算宽高
        CGFloat w = (self.frame.size.width - self.layoutEdgeInsets.left - self.layoutEdgeInsets.right - (self.horizoneMargin * (self.numberOfItemEachLine - 1)))/self.numberOfItemEachLine;
        if (w <= 0) {NSAssert(0, @"宽度计算小于零，请重新设置视图宽度");}
        for (int i = 0; i < self.itemsArray.count; ++i) {
            UIView *view = self.itemsArray[i];
            if ([view isKindOfClass:[UIView class]]) {
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(w).priority(950);
                    make.height.mas_equalTo(w/_wh_ratio).priority(950);
                }];
            }
            //        tmp = ((i + 1) % _numberOfItemEachLine == 0) ? nil : view;
        }
    }
    [super layoutSubviews];
}

- (void)reloadItemAtIndex:(NSInteger)index item:(void (^)(UIView *))itemBlock{
    if (_numberOfItems <= 0) {return;}
    if (index >= 0 && index < self.itemsArray.count) {
        if (itemBlock) {
            if (kCollectLayoutAlignmentRight == self.alignment) {
                for (int i = 0; i < _numberOfItems; ++i) {
                    if (implicitTagForView(self.itemsArray[i]) == index) {
                        if ([self.itemsArray[i] isKindOfClass:[UIView class]]) {
                            itemBlock(self.itemsArray[i]);
                        }
                        break;
                    }
                }
            }else{
                if ([self.itemsArray[index] isKindOfClass:[UIView class]]) {
                    itemBlock(self.itemsArray[index]);
                }
            }
        }
    }else{
        NSAssert(0, @"reload for index can not find");
    }
}

- (void)reloadDataForItems:(void (^)(UIView *, NSInteger))itemBlock{
    [self.itemsArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (itemBlock && [obj isKindOfClass:[UIView class]]) {
            itemBlock(obj,implicitTagForView(obj));
        }
    }];
}

- (NSInteger)indexForItem:(UIView *)item{
    return [self.itemsArray indexOfObject:item];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
