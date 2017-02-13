//
//  ADRectViewsManager.m
//  ADdrawRect
//
//  Created by andong on 10/13/16.
//  Copyright © 2016 andong. All rights reserved.
//

#import "ADRectViewsManager.h"

@interface ADRectViewsManager () <ADRectViewDelegate>

@property (nonatomic,strong) NSMutableArray <ADRectView *> *rectViews;
@property (nonatomic,strong) ADRectView *currentView;
@end

@implementation ADRectViewsManager

- (NSMutableArray *)rectViews
{
    if (_rectViews == nil) {
        _rectViews = [NSMutableArray array];
    }
    return _rectViews;
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
    rect.fillColor   = [UIColor colorWithRed:(arc4random() % 255)/255.0 green:(arc4random() % 255)/255.0 blue:(arc4random() % 255)/255.0 alpha:0.5];
    rect.strokeColor = [UIColor brownColor];
    rect.buttonBackgroundImage_defaultStr = @"btn_thumb";
    rect.buttonBackgroundImage_highlightedStr = @"btn_thumb";
    rect.lineWidth   = 2;
    rect.delegate = self;
    self.currentView = rect;
    [self addSubview:rect];
}

- (void)createRectViewWithPoints:(NSArray <ADRectPoint *>*)points
{
    ADRectView *rect = [[ADRectView alloc]initWithSuperViewBounds:self.bounds PointArray:points];
    rect.fillColor   = [UIColor colorWithRed:(arc4random() % 255)/255.0 green:(arc4random() % 255)/255.0 blue:(arc4random() % 255)/255.0 alpha:0.5];
    rect.strokeColor = [UIColor brownColor];
    rect.buttonBackgroundImage_defaultStr = @"btn_thumb";
    rect.buttonBackgroundImage_highlightedStr = @"btn_thumb";
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

@end
