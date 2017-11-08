//
//  WJWebTableViewCell.h
//  HuPlus
//
//  Created by reborn on 17/3/9.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReloadWebViewDelegate <NSObject>

- (void)reloadByHeight:(CGFloat)height;

@end

@interface WJWebTableViewCell : UITableViewCell

@property (nonatomic, assign) id<ReloadWebViewDelegate> heightDelegate;
- (void)configWithURL:(NSString *)url;



@end
