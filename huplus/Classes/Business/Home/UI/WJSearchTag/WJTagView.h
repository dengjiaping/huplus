//
//  WJTagView.h
//  HuPlus
//
//  Created by reborn on 17/1/16.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJTag.h"
@interface WJTagView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) CGFloat regularWidth; //!< 固定宽度
@property (nonatomic,assign ) CGFloat regularHeight; //!< 固定高度
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index);

@property (nonatomic,assign) NSInteger totalHeight;


- (void)addTag: (nonnull WJTag *)tag;
- (void)insertTag: (nonnull WJTag *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull WJTag *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;

-(void)configViewWithArray:(nonnull NSArray *)hotKeyArray;
@end
