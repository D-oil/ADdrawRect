//
//  ADRectViewsManager.m
//  ADdrawRect
//
//  Created by andong on 10/13/16.
//  Copyright © 2016 andong. All rights reserved.
//

#import "ADRectViewsManager.h"

@interface ADRectViewsManager () <ADRectViewDelegate>

@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) NSArray *buttonIcons;
@property (nonatomic,strong) NSMutableArray <ADRectView *> *rectViews;
@property (nonatomic,strong) ADRectView *currentView;
@end

@implementation ADRectViewsManager

- (NSArray *)colorArray {
    if (_colorArray == nil) {
        _colorArray = @[[UIColor colorWithRed:163/255.0 green:106/255.0 blue:248/255.0 alpha:0.7],
                        [UIColor colorWithRed:42/255.0 green:218/255.0 blue:157/255.0 alpha:0.7],
                        [UIColor colorWithRed:40/255.0 green:117/255.0 blue:238/255.0 alpha:0.7]];
    }
    return _colorArray;
}

- (NSArray *)buttonIcons {
    if (_buttonIcons == nil) {
        _buttonIcons = @[@"icon_point_p",@"icon_point_b",@"icon_point_g"];
    }
    return _buttonIcons;
}
- (NSMutableArray *)rectViews
{
    if (_rectViews == nil) {
        _rectViews = [NSMutableArray array];
    }
    return _rectViews;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [self.rectViews addObject:(ADRectView *)view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self rectviewBeSelectfromPoint:touchPoint];

}

- (void)createRectViewWithShape:(ADViewShape)shape
{
    ADRectView *rect = [[ADRectView alloc]initWithSuperViewBounds:self.bounds shape:shape];
    rect.ID = [NSString stringWithFormat:@"%ld",[self getMinID]];
    rect.fillColor = [self.colorArray objectAtIndex:[self getMinID] -1];
    rect.originalFillColor = [self.colorArray objectAtIndex:[self getMinID] -1];
    rect.buttonBackgroundImage_defaultStr = [self.buttonIcons objectAtIndex:[self getMinID] -1];
    rect.buttonBackgroundImage_highlightedStr = [self.buttonIcons objectAtIndex:[self getMinID] -1];
    rect.lineWidth   = 2;
    rect.delegate = self;
    self.currentView = rect;
    [self addSubview:rect];
}

- (void)createRectViewWithPoints:(NSArray <ADRectPoint *>*)points
{
    ADRectView *rect = [[ADRectView alloc]initWithSuperViewBounds:self.bounds PointArray:points];
    //为rect分配一个最低id
    rect.ID = [NSString stringWithFormat:@"%ld",[self getMinID]];
    rect.fillColor = [self.colorArray objectAtIndex:[self getMinID] -1];
    rect.originalFillColor = [self.colorArray objectAtIndex:[self getMinID] -1];
    rect.buttonBackgroundImage_defaultStr = [self.buttonIcons objectAtIndex:[self getMinID] -1];
    rect.buttonBackgroundImage_highlightedStr = [self.buttonIcons objectAtIndex:[self getMinID] -1];
    rect.lineWidth   = 2;
    rect.delegate = self;
    self.currentView = rect;
    [self addSubview:rect];
}

- (void)rectviewBeSelectfromPoint:(CGPoint)touchPoint
{
    for (ADRectView *rect in self.rectViews) {
        if ( touchPoint.x >= rect.rectTopPoint.x && touchPoint.y >= rect.rectTopPoint.y && touchPoint.x <= rect.rectBottomPoint.x && touchPoint.y <= rect.rectBottomPoint .y ) {
            [rect beginEditPath];
            self.currentView = rect;
            if ([_delegate respondsToSelector:@selector(beginEditWithRectView:)]) {
                [self.delegate beginEditWithRectView:self.currentView];
            }
            break;
        } else {
            [rect savePath];

            self.currentView = nil;
        }
    }
}

- (void)deleteRectView:(ADRectView *)rect
{
    [rect deletePath];
    [self.rectViews removeObject:rect];
}

- (void)editRectView:(ADRectView *)rect
{
    [rect beginEditPath];
}
- (NSArray *)saveRectView:(ADRectView *)rect
{
    
    return [rect savePath];
}



- (void)savePathWithRectView:(id)rect
{
    if ([_delegate respondsToSelector:@selector(endEditWithRectView:)]) {
        [self.delegate endEditWithRectView:rect];
    }
}

+ (ADRectPoint *)createADRectPointWithPoint:(CGPoint)point
{
    ADRectPoint *rectPoint = [[ADRectPoint alloc]init];
    rectPoint.point = point;
    return rectPoint;
}

- (NSInteger)getMinID
{
    NSMutableArray *haveIDArray = [NSMutableArray array];
    for (ADRectView *rect in self.rectViews) {
        [haveIDArray addObject:rect.ID];
    }

    for (int i = 1; i <4 ; i++) {
        if (![haveIDArray containsObject:[NSString stringWithFormat:@"%d",i]]) {
            return i;
        }

    }
   
    return 1;
}

@end
