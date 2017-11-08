//
//  WJSegmentedView.m
//  HuPlus
//
//  Created by reborn on 16/12/21.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJSegmentedView.h"
#define kLineTag     999
@interface WJSegmentedView ()
{
    NSMutableArray *buttonArray;
    UIView         *bottomLine;
}
@property(nonatomic,readonly)NSUInteger numberOfSegments;

@end

@implementation WJSegmentedView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items{
    if (self = [super initWithFrame:frame]) {
        
        buttonArray = [NSMutableArray arrayWithCapacity:items.count];
        _numberOfSegments = items.count;
        _selectedSegmentIndex = 0;
        
        CGFloat btnWith = frame.size.width / items.count;
        CGFloat lineHeight = 3.f;
        CGFloat lineWith = 40.f;
        CGFloat btnHeight = frame.size.height;
        
        UIColor *selectColor = WJColorMainRed;
        UIColor *norColor = WJColorLightGray;
//        UIColor *bgColor = WJColorViewBg;
        UIColor *bgColor = WJColorWhite;

        
        UIFont *font = [UIFont systemFontOfSize:16.f];
        
        for (int i = 0; i < items.count; i++) {
            id item = [items objectAtIndex:i];
            if (![item isKindOfClass:[NSString class]]) {
                break;
            }
            
            NSString *title = (NSString *)item;
            UIButton *btn = [[UIButton alloc] init];
            btn.titleLabel.font = font;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:selectColor forState:UIControlStateSelected];
            [btn setTitleColor:norColor forState:UIControlStateNormal];
            btn.backgroundColor = bgColor;
            btn.frame = CGRectMake(i*btnWith, 0, btnWith, btnHeight);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [buttonArray addObject:btn];
            
            if (i == _selectedSegmentIndex) {
                btn.selected = YES;
            }
            
            UIView *tView = [[UIView alloc] init];
            tView.hidden = !btn.selected;
            tView.tag = kLineTag;
            tView.backgroundColor = selectColor;
            [btn addSubview:tView];
            tView.frame = CGRectMake((btnWith-lineWith)/2, btnHeight-lineHeight, lineWith, lineHeight);
        }
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1.f, self.width, 1.f)];
        bottomLine.backgroundColor = WJColorSeparatorLine;
        bottomLine.hidden = YES;
        [self addSubview:bottomLine];
        
    }
    return self;
}

-(void)setBottomLineView:(BOOL)isShow
{
    if (isShow) {
        bottomLine.hidden = NO;

    } else {
        bottomLine.hidden = YES;
    }
}

//设置选中
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (_selectedSegmentIndex == selectedSegmentIndex) {
        return;
    }
    
    [self cancelButton:_selectedSegmentIndex];
    _selectedSegmentIndex = selectedSegmentIndex;
    [self selectButton:selectedSegmentIndex];
    
}

//单击选中
- (void)btnClick:(UIButton *)sender
{
    NSUInteger index = [buttonArray indexOfObject:sender];
    self.selectedSegmentIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(segmentedView:buttonClick:)]) {
        [self.delegate segmentedView:self buttonClick:index];
    }
}

//设置选中按钮状态
- (void)selectButton:(NSUInteger)index
{
    UIButton *btn = [buttonArray objectAtIndex:index];
    btn.selected = YES;
    UIView *tView = [btn viewWithTag:kLineTag];
    tView.hidden = !btn.selected;
}

//取消选中按钮状态
- (void)cancelButton:(NSUInteger)index
{
    UIButton *preBtn = [buttonArray objectAtIndex:index];
    preBtn.selected = NO;
    UIView *preView = [preBtn viewWithTag:kLineTag];
    preView.hidden = !preBtn.selected;
}

-(void)changeSegmentTitleWithItems:(NSArray *)items
{
    for (int i = 0; i < items.count; i++) {
        UIButton *button = [buttonArray objectAtIndex:i];
        [button setTitle: [items objectAtIndex:i] forState:UIControlStateNormal];
    }
}


@end
