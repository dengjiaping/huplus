//
//  WJTag.m
//  HuPlus
//
//  Created by reborn on 17/1/16.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJTag.h"
static const CGFloat kDefaultFontSize = 13.0;

@implementation WJTag
- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize = kDefaultFontSize;
        _textColor = [UIColor blackColor];
        _bgColor = [UIColor whiteColor];
        _enable = YES;
    }
    return self;
}

- (instancetype)initWithText: (NSString *)text {
    self = [self init];
    if (self) {
        _text = text;
    }
    return self;
}

+ (instancetype)tagWithText: (NSString *)text {
    return [[self alloc] initWithText: text];
}


@end
