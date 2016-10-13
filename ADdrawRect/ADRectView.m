//
//  ADRectView.m
//
//  Created by andong on 10/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ADRectView.h"
#import "ADRectPoint.h"

const static CGFloat ADRectBorderLength = 80;
const static CGFloat ADRectButtonSize   = 20;

@interface ADRectView () <ADRectPointButtonDelegate>

@property (nonatomic,strong)NSMutableArray <ADRectPoint *> * allPointArray;
@property (nonatomic,strong)NSMutableArray <ADRectPointButton *> * allPointButtonArray;

@property (nonatomic,strong)ADRectPoint    * currentPoint;
@property (nonatomic,strong)UIBezierPath   * path;
@property (nonatomic,assign)ADViewShape      viewShape;

@property (nonatomic,assign)CGPoint          rectTopPoint;
@property (nonatomic,assign)CGPoint          rectBottomPoint;


@end

@implementation ADRectView


#pragma mark - properties

- (NSMutableArray *)allPointArray
{
    if (_allPointArray == nil) {
        _allPointArray = [NSMutableArray array];
    }
    return _allPointArray;
}

- (NSMutableArray *)allPointButtonArray
{
    if (_allPointButtonArray == nil) {
        _allPointButtonArray = [NSMutableArray array];
    }
    return _allPointButtonArray;
}

- (void) setButtonBackgroundImage_defaultStr:(NSString *)buttonBackgroundImage_defaultStr
{
    for (ADRectPointButton *pointButton  in self.allPointButtonArray) {
        [pointButton setBackgroundImage:[UIImage imageNamed:buttonBackgroundImage_defaultStr] forState:UIControlStateNormal];
    }
    _buttonBackgroundImage_defaultStr = buttonBackgroundImage_defaultStr;
}

- (void) setButtonBackgroundImage_highlightedStr:(NSString *)buttonBackgroundImage_highlightedStr
{
    for (ADRectPointButton *pointButton  in self.allPointButtonArray) {
        [pointButton setBackgroundImage:[UIImage imageNamed:buttonBackgroundImage_highlightedStr] forState:UIControlStateHighlighted];
    }
    _buttonBackgroundImage_highlightedStr = buttonBackgroundImage_highlightedStr;
}

#pragma mark - init
- (instancetype)initWithSuperViewBounds:(CGRect)superViewBounds shape:(ADViewShape)shape
{
    self = [super initWithFrame:superViewBounds];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.viewShape = shape;
        self.path  = [[UIBezierPath alloc]init];
        [self createAllPointWithFrame:superViewBounds];
        [self setDefaultInfo];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return nil;
}

- (void) createAllPointWithFrame:(CGRect)frame
{
    switch (self.viewShape) {
        case ADViewShape_triangle:
            [self createTriangleWithFrame:frame];
            break;
        case ADViewShape_Rect:
            [self createRectangleWithFrame:frame];
            break;
    }
}

- (void) setDefaultInfo
{
    self.fillColor = [UIColor grayColor];
    self.strokeColor = [UIColor redColor];
    self.buttonBackgroundImage_defaultStr = @"MenuIcon-Capture";
    self.buttonBackgroundImage_highlightedStr = @"MenuIcon-Capture";
    self.lineWidth = 2;
}

#pragma mark - option
- (NSArray *)savePath
{
    [self setUserInteractionEnabled:NO];
    [self.allPointButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    return self.allPointArray;
}

- (void)beginEditPath
{
    [self setUserInteractionEnabled:YES];
    for (ADRectPointButton *pointButton in self.allPointButtonArray) {
        [self addSubview:pointButton];
    }
}
- (void)deletePath
{
    [self removeFromSuperview];
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    [self.path removeAllPoints];

    //set path
    CGPoint firstPoint = CGPointZero;
    for (ADRectPoint *rectPoint in self.allPointArray) {
        if (rectPoint.pointId == 0) {
            [self.path moveToPoint:rectPoint.point];
            firstPoint = rectPoint.point;
        } else {
            [self.path addLineToPoint:rectPoint.point];
        }
    }
    [self.path addLineToPoint:firstPoint];
    [self.path closePath];
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    [self.path setLineWidth:self.lineWidth];
    [self.path fill];
    [self.path stroke];
    
 
}

- (void)updateFrame
{
    // set Viewframe
    self.rectTopPoint    = CGPointZero;
    self.rectBottomPoint = CGPointZero;
    CGFloat firstPointx  = CGFLOAT_MAX;
    CGFloat firstPointy  = CGFLOAT_MAX;
    CGFloat bottomPointx = CGFLOAT_MIN;
    CGFloat bottomPointy = CGFLOAT_MIN;
    
    for (ADRectPoint *rectPoint in self.allPointArray) {
        
        if (firstPointx > rectPoint.point.x ) {
            firstPointx = rectPoint.point.x;
        }
        
        if (firstPointy > rectPoint.point.y ) {
            firstPointy = rectPoint.point.y;
        }
        self.rectTopPoint = CGPointMake(firstPointx, firstPointy);

        if (bottomPointx < rectPoint.point.x ) {
            bottomPointx = rectPoint.point.x;
        }
        if (bottomPointy < rectPoint.point.y ) {
            bottomPointy = rectPoint.point.y;
        }
        self.rectBottomPoint = CGPointMake(bottomPointx, bottomPointy);
    }
    
//    [self setFrame:CGRectMake(firstPointx, firstPointy  , bottomPointx - firstPointx + ADRectButtonSize  , bottomPointy - firstPointy + ADRectButtonSize )];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];
    if ([self isTouchSelectViewWithTouchPoint:[touch locationInView:self]]) {
        [self beginEditPath];
    } else {
        [self savePath];
    }
    
}

- (BOOL)isTouchSelectViewWithTouchPoint:(CGPoint)touchPoint
{
    BOOL isTouch = NO;
    if ( touchPoint.x >= self.rectTopPoint.x && touchPoint.y >= self.rectTopPoint.y && touchPoint.x <= self.rectBottomPoint.x && touchPoint.y <= self.rectBottomPoint .y ) {
        isTouch = YES;
    }
    return isTouch;
}

#pragma mark - ADRectPointButtonDelegate
- (void)touchMoveButtonWithTag:(NSInteger)tag WithPoint:(CGPoint)point
{
//    NSLog(@"tag = %ld ,Point = %@",tag,NSStringFromCGPoint(point));
    ADRectPoint *pointObj = self.allPointArray[tag];
    pointObj.point = point;
    [self setNeedsDisplay];
    [self updateFrame];

}

-(void)touchEndButtonWithTag:(NSInteger)tag WithPoint:(CGPoint)point
{
    ADRectPoint *pointObj = self.allPointArray[tag];
    pointObj.point = point;
    [self updateFrame];
    [self setNeedsDisplay];
}

#pragma mark - create shape Point
- (void)createRectangleWithFrame:(CGRect)frame
{
    for (NSInteger index = 0; index < self.viewShape ; index ++) {
        
        ADRectPoint *currentpoint = [[ADRectPoint alloc] init];
        ADRectPointButton *PointButton = [[ADRectPointButton alloc]initWithFrame:CGRectMake(0, 0, ADRectButtonSize, ADRectButtonSize)];
        PointButton.delegete = self;
        [self addSubview:PointButton];

        PointButton.tag = index;
        currentpoint.pointId = index;
        CGPoint point = CGPointZero;
        CGPoint center = CGPointZero;
        switch (index) {
            case 0:
            {
                center = CGPointMake( ADRectButtonSize / 2,  ADRectButtonSize / 2);
                point  = CGPointZero;
                currentpoint.point = point;
                PointButton.center = center;
            }
                break;
            case 1:
            {
                center = CGPointMake(ADRectBorderLength - ADRectButtonSize , ADRectButtonSize / 2);
                point  = CGPointMake(ADRectBorderLength, 0);
                currentpoint.point = point;
                PointButton.center = center;
            }
                break;
            case 2:
            {
                center = CGPointMake(ADRectBorderLength -  ADRectButtonSize , ADRectBorderLength - ADRectButtonSize);
                point  = CGPointMake(ADRectBorderLength, ADRectBorderLength);
                currentpoint.point = point;
                PointButton.center = center;
            }
                break;
            case 3:
            {
                center = CGPointMake(ADRectButtonSize / 2, ADRectBorderLength - ADRectButtonSize);
                point  = CGPointMake(0, ADRectBorderLength);
                currentpoint.point = point;
                PointButton.center = center;
            }
                break;
        }
        [self.allPointArray addObject:currentpoint];
        [self.allPointButtonArray addObject:PointButton];
    }
    [self updateFrame];
}

- (void)createTriangleWithFrame:(CGRect)frame
{
    [self createRectangleWithFrame:frame];
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches.allObjects lastObject];
//    [self setCenter:[touch locationInView:self.superview]];
//}
@end
