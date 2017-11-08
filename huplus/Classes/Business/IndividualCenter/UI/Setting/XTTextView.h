//
//  XTTextView.h
//  XTTextView
//
//  Created by XT Xiong on 16/1/11.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  继承于UITextView，添加了placeholder支持，就像UITextField一样的拥有placeholder功能
 */
@interface XTTextView : UITextView

//占位符文本,与UITextField的placeholder功能一致
@property (nonatomic, strong) NSString *placeholder;

//占位符文本颜色
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
