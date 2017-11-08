//
//  WJPhotoViewCollectionViewCell.m
//  HuPlus
//
//  Created by reborn on 17/3/22.
//  Copyright © 2017年 IHUJIA. All rights reserved.
//

#import "WJPhotoViewCollectionViewCell.h"
@interface WJPhotoViewCollectionViewCell ()
{
    UIImageView *imageView;
}

@end

@implementation WJPhotoViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"add_icon"];
        [self addSubview:imageView];
        
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(imageView.width - ALD(16), 0, ALD(16), ALD(16));
        deleteButton.hidden = YES;
        deleteButton.tag = 2004;
        [deleteButton setImage:[UIImage imageNamed:@"collection_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:deleteButton];
    
    }
    return self;
}

-(void)configDataWithImage:(UIImage *)uploadImage
{
    UIButton *deleteBtn = (UIButton *)[imageView viewWithTag:2004];

    if ([uploadImage isKindOfClass:[UIImage class]]) {
        imageView.image = uploadImage;
        deleteBtn.hidden = NO;

    } else {
        imageView.image = [UIImage imageNamed:@"add_icon"];
        deleteBtn.hidden = YES;

    }
}

-(void)deleteButtonAction
{
    self.deleteBlock();
}

@end
