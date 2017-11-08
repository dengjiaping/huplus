//
//  WJOrderTypeCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 16/12/19.
//  Copyright © 2016年 IHUJIA. All rights reserved.
//

#import "WJOrderTypeCollectionViewCell.h"

@interface WJOrderTypeCollectionViewCell ()
{
    UIImageView *iconImageView;
    UILabel     *orderTypeL;
    UILabel     *messagePoint;
}
@end

@implementation WJOrderTypeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImage *image = [UIImage imageNamed:@"waitingPay"];
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - image.size.width)/2, (frame.size.height - image.size.height)/2 - ALD(10), image.size.width, image.size.height)];
        iconImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:iconImageView];
        
        orderTypeL = [[UILabel alloc] initWithFrame:CGRectMake(0,iconImageView.bottom + ALD(10) , frame.size.width, ALD(20))];
        orderTypeL.textAlignment = NSTextAlignmentCenter;
        orderTypeL.textColor = WJColorNavigationBar;
        orderTypeL.font = WJFont14;
        [self addSubview:orderTypeL];
        
        messagePoint = [[UILabel alloc] initWithFrame:CGRectMake(ALD(13), -ALD(6), ALD(12), ALD(12))];
        messagePoint.backgroundColor = WJColorMainRed;
        messagePoint.layer.cornerRadius = messagePoint.width/2;
        messagePoint.layer.masksToBounds = YES;
        messagePoint.textColor = WJColorWhite;
        messagePoint.font = WJFont10;
        messagePoint.textAlignment = NSTextAlignmentCenter;
        messagePoint.hidden = YES;
        [iconImageView addSubview:messagePoint];
        
    }
    return self;
}

- (void)configDataWithIcon:(NSString *)icon orderType:(NSString *)title count:(NSString *)count
{
    iconImageView.image = [UIImage imageNamed:icon];
    orderTypeL.text = title;
    
    if ([count integerValue] > 0) {
        
//        CGSize priceTxtSize = [messagePoint.text sizeWithAttributes:@{NSFontAttributeName:WJFont10} constrainedToSize:CGSizeMake(1000000, ALD(30))];
        
//        messagePoint.frame = CGRectMake(ALD(13), -ALD(2), priceTxtSize.width, priceTxtSize.width);
//        messagePoint.layer.cornerRadius = messagePoint.width/2;
//        messagePoint.layer.masksToBounds = YES;

        if ([count integerValue] > 10) {
            messagePoint.frame = CGRectMake(ALD(13), -ALD(10), ALD(18), ALD(18));
            messagePoint.layer.cornerRadius = messagePoint.width/2;
            messagePoint.layer.masksToBounds = YES;

        } else if ([count integerValue] > 100) {
            messagePoint.frame = CGRectMake(ALD(13), -ALD(12), ALD(25), ALD(25));
            messagePoint.layer.cornerRadius = messagePoint.width/2;
            messagePoint.layer.masksToBounds = YES;
        }

        messagePoint.text = count;
        messagePoint.hidden = NO;

    } else {
        messagePoint.hidden = YES;
    }
}

@end
