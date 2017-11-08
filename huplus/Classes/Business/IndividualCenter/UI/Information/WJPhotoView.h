//
//  WJPhotoView.h
//  HuPlus
//
//  Created by reborn on 17/1/4.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WJPhotoViewDelegate <NSObject>

-(void)photoViewClickAlbum;
-(void)photoViewClickTakePhoto;

@end

@interface WJPhotoView : UIView
@property(nonatomic,weak)id<WJPhotoViewDelegate>delegate;

@end
