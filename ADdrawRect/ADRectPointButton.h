//
//  ADRectPointButton.h
//
//  Created by andong on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADRectPointButtonDelegate <NSObject>

@required
- (void)touchMoveButtonWithTag:(NSInteger)tag WithPoint:(CGPoint)point;
- (void)touchEndButtonWithTag:(NSInteger)tag WithPoint:(CGPoint)point;
@end

@interface ADRectPointButton : UIButton

@property (nonatomic,weak) id <ADRectPointButtonDelegate> delegete ;


@end
