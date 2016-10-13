//
//  ADRectPointButton.m
//
//  Created by andong on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ADRectPointButton.h"

@implementation ADRectPointButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];
    [self setCenter:[touch locationInView:self.superview]];
    
    if ([_delegete respondsToSelector:@selector(touchMoveButtonWithTag:WithPoint:)]) {
        [self.delegete touchMoveButtonWithTag:self.tag WithPoint:self.center];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];
    [self setCenter:[touch locationInView:self.superview]];
    
    if ([_delegete respondsToSelector:@selector(touchEndButtonWithTag:WithPoint:)]) {
        [self.delegete touchEndButtonWithTag:self.tag WithPoint:self.center];
    }
}

@end
