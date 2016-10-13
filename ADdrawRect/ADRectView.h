//
//  ADRectView.h
//
//  Created by andong on 10/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRectPointButton.h"
/*
 point tag
     0         0       1        0    1
    /\         ---------         ____
   /  \        |       |      5 /    \ 2
  /    \       |       |        \____/
 --------      ---------        4     3
 2      1      3       2
*/
typedef NS_ENUM(NSUInteger, ADViewShape) {
    ADViewShape_triangle = 3,
    ADViewShape_Rect = 4
};

@interface ADRectView : UIView

//init
- (instancetype)initWithSuperViewBounds:(CGRect)superViewBounds shape:(ADViewShape)shape;

//option
- (NSArray *)savePath;
- (void)beginEditPath;
- (void)deletePath;


//properyies
@property (nonatomic,assign,readonly)CGPoint          rectTopPoint;
@property (nonatomic,assign,readonly)CGPoint          rectBottomPoint;

@property (nonatomic,strong)UIColor  *fillColor;         //default gray
@property (nonatomic,strong)UIColor  *strokeColor;       //default red
@property (nonatomic,assign)NSInteger lineWidth;         //default 2

@property (nonatomic,strong)NSString *buttonBackgroundImage_defaultStr;
@property (nonatomic,strong)NSString *buttonBackgroundImage_highlightedStr;

@end
