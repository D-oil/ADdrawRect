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

    if ([_delegete respondsToSelector:@selector(touchMoveButton:WithTag:WithPoint:)]) {
        [self.delegete touchMoveButton:self WithTag:self.tag WithPoint:[touch locationInView:self.superview]];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects lastObject];

    if ([_delegete respondsToSelector:@selector(touchEndButton:WithTag:WithPoint:)]) {
        [self.delegete touchEndButton:self WithTag:self.tag WithPoint:[touch locationInView:self.superview]];
    }
    
    
}

@end
