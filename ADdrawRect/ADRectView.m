//
//  ADRectView.m
//
//  Created by andong on 10/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ADRectView.h"


const static CGFloat ADRectBorderLength = 100;
const static CGFloat ADRectButtonSize   = 40;

@interface ADRectView () <ADRectPointButtonDelegate>



@property (nonatomic,strong)ADRectPoint    * currentPoint;
@property (nonatomic,strong)UIBezierPath   * path;
@property (nonatomic,assign)ADViewShape      viewShape;

@property (nonatomic,assign)CGPoint          rectTopPoint;
@property (nonatomic,assign)CGPoint          rectBottomPoint;

@property (nonatomic,assign)CGPoint          lastMovePoint;

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
        [pointButton setImage:[UIImage imageNamed:buttonBackgroundImage_defaultStr] forState:UIControlStateNormal];
    }
    _buttonBackgroundImage_defaultStr = buttonBackgroundImage_defaultStr;
}

- (void) setButtonBackgroundImage_highlightedStr:(NSString *)buttonBackgroundImage_highlightedStr
{
    for (ADRectPointButton *pointButton  in self.allPointButtonArray) {
        [pointButton setImage:[UIImage imageNamed:buttonBackgroundImage_highlightedStr] forState:UIControlStateHighlighted];
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
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [self addGestureRecognizer:pan];
        

    }
    return self;
}

- (instancetype)initWithSuperViewBounds:(CGRect)superViewBounds PointArray:(NSArray <ADRectPoint *> *)points
{
    self = [super initWithFrame:superViewBounds];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.viewShape = ADViewShape_Rect;
        self.path  = [[UIBezierPath alloc]init];
        [self createRectViewWithFrame:superViewBounds pointArray:points];
        [self setDefaultInfo];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [pan setMinimumNumberOfTouches:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [pan requireGestureRecognizerToFail:pan];
        });
        [self addGestureRecognizer:pan];
        
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
    self.strokeColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:0.5];
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
    

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];
    if ([self isTouchSelectViewWithTouchPoint:[touch locationInView:self]]) {
        [self beginEditPath];
    } else {
//        if ([_delegate respondsToSelector:@selector(savePathWithRectView:)]) {
//            [self.delegate savePathWithRectView:self];
//        }
//        [self savePath];
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
- (void)touchMoveButton:(ADRectPointButton *)rectPointButton WithTag:(NSInteger)tag WithPoint:(CGPoint)point
{
    NSLog(@"tag = %ld ,Point = %@",tag,NSStringFromCGPoint(point));
    ADRectPoint *pointObj = self.allPointArray[tag];
    pointObj.point = point;
    //计算其他三个内角的和计算出正在移动的这个button的内角度数
    
    [rectPointButton setCenter:point];
    //判断四变形内角的每个角是否有大于180度，大于这会变成凹四边形，这不能移动点了
    if ([self computeAllpointInnerAngleDeterminePointCanMoveWithCurrentButtontag:rectPointButton.tag]) {
       
        
        [self setNeedsDisplay];
        [self updateFrame];
    } else {
        
    }
      


}

-(void)touchEndButton:(ADRectPointButton *)rectPointButton WithTag:(NSInteger)tag WithPoint:(CGPoint)point
{
    ADRectPoint *pointObj = self.allPointArray[tag];
    pointObj.point = point;
    //判断四变形内角的每个角是否有大于180度，大于这会变成凹四边形，这不能移动点了
    if ([self computeAllpointInnerAngleDeterminePointCanMoveWithCurrentButtontag:rectPointButton.tag]) {
        
        
        [rectPointButton setCenter:point];
        [self updateFrame];
        [self setNeedsDisplay];
    } else {
     
    }
       
    
 
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

- (void)createRectViewWithFrame:(CGRect)frame pointArray:(NSArray *)points
{
    self.allPointButtonArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 4 ; index ++) {
        ADRectPoint *point = points[index];
        point.pointId = index;
        ADRectPointButton *PointButton = [[ADRectPointButton alloc]initWithFrame:CGRectMake(0, 0, ADRectButtonSize, ADRectButtonSize)];
     
        PointButton.delegete = self;
        PointButton.center = point.point;
        PointButton.tag = index;
        [self addSubview:PointButton];
        [self.allPointButtonArray addObject:PointButton];
    }
    self.allPointArray = [points mutableCopy];
    
    [self updateFrame];

}

- (void)createTriangleWithFrame:(CGRect)frame
{
    [self createRectangleWithFrame:frame];
}

- (BOOL)computeAllpointInnerAngleDeterminePointCanMoveWithCurrentButtontag:(NSUInteger)tag;
{
    double PointAAngle = [self computePointAngelWithLastPoint:self.allPointArray[3] currentPoint:self.allPointArray[0] nextPoint:self.allPointArray[1]];
    double PointBAngle = [self computePointAngelWithLastPoint:self.allPointArray[0] currentPoint:self.allPointArray[1] nextPoint:self.allPointArray[2]];
    double PointCAngle = [self computePointAngelWithLastPoint:self.allPointArray[1] currentPoint:self.allPointArray[2] nextPoint:self.allPointArray[3]];
    double PointDAngle = [self computePointAngelWithLastPoint:self.allPointArray[2] currentPoint:self.allPointArray[3] nextPoint:self.allPointArray[0]];
    
    NSMutableArray *pointAngleArray =[ @[[NSNumber numberWithDouble:PointAAngle],
                                         [NSNumber numberWithDouble:PointBAngle],
                                         [NSNumber numberWithDouble:PointCAngle],
                                         [NSNumber numberWithDouble:PointDAngle]] mutableCopy];
    
    [pointAngleArray removeObjectAtIndex:tag];
    double movePointInnerAngel = 2 *M_PI;
    for (NSNumber *point in pointAngleArray) {
       movePointInnerAngel = movePointInnerAngel - [point doubleValue];
    }
    
    if (movePointInnerAngel >= M_PI) {
        return NO;
    }

    return YES;
}
//输入四边形对应的三个点，计算中间点的内角角度
- (double)computePointAngelWithLastPoint:(ADRectPoint *)lastPoint currentPoint:(ADRectPoint *)currentPoint nextPoint:(ADRectPoint *) nextPoint
{
    //先根据坐标计算角所对应两条邻边的长度
    //用绝对值计算两边的长度
    double AE = fabs((currentPoint.point.x - lastPoint.point.x));
    double DE = fabs((currentPoint.point.y - lastPoint.point.y));
    //已知直角三角形两直角边，计算斜边长度
    double AD = hypot(AE, DE);
    
    //用绝对值计算两边的长度
    double AF = fabs((currentPoint.point.x - nextPoint.point.x));
    double BF = fabs((currentPoint.point.y - nextPoint.point.y));
    //已知直角三角形两直角边，计算斜边长度
    double AB = hypot(AF, BF);
    
    //计算BD的长度（BD是B点与D点的连线）
    double DG = fabs((lastPoint.point.x - nextPoint.point.x));
    double BG = fabs((lastPoint.point.y - nextPoint.point.y));
    //已知直角三角形两直角边，计算斜边长度
    double BD = hypot(DG, BG);
    
    //这里利用三角函数 cosA = （b平方 + c平方 -a平方） ／2bc
    //AD是 b AB是 c BD是 a
    double cosA =( AD*AD + AB*AB - BD*BD  ) / (2 * AD * AB);
    
    if (fabs(acos(cosA) - M_PI ) < 0.03) {
        return -acos(cosA);
    }
    
    //反三角函数得到A的弧度值
//    NSLog(@"----%lf----",acos(cosA));
    
    return acos(cosA);
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan
{
    NSLog(@"%@",NSStringFromCGPoint([pan translationInView:self.superview]));
    CGPoint movePoint = [pan translationInView:self.superview];
    
    CGFloat moveX = (movePoint.x - self.lastMovePoint.x ) /2.5;
    CGFloat moveY = (movePoint.y - self.lastMovePoint.y ) /2.5;
    
    //判断边界
    UIView *superview = self.superview;
    for (ADRectPoint *point in self.allPointArray) {
        if ((point.point.x <= 0 && moveX >= 0) ||
            (point.point.y <= 0 && moveY >= 0) ||
            (point.point.x >= superview.frame.size.width && moveX <= 0) ||
            (point.point.y >= superview.frame.size.height && moveY <= 0)) {
            
        }
        else if (point.point.x <= 0 || point.point.y <= 0 || point.point.x >= superview.frame.size.width || point.point.y >= superview.frame.size.height) {
            return;
        }
    }

    //移动点
    for (ADRectPoint *point in self.allPointArray) {
        point.point = CGPointMake(point.point.x + moveX, point.point.y + moveY);
    }
    //移动button
    for (ADRectPointButton *pointButton in self.allPointButtonArray) {
        pointButton.center = CGPointMake(pointButton.center.x + moveX, pointButton.center.y + moveY);
    }
    [self setNeedsDisplay];
    self.lastMovePoint = movePoint;
    if (pan.state == UIGestureRecognizerStateEnded) {
        self.lastMovePoint = CGPointZero;
    }
}

@end
