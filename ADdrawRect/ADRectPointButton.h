//
//  ADRectPointButton.h
//
//  Created by andong on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADRectPointButton;
@protocol ADRectPointButtonDelegate <NSObject>

@required
- (void)touchMoveButton:(ADRectPointButton *)rectPointButton WithTag:(NSInteger)tag WithPoint:(CGPoint)point;
- (void)touchEndButton:(ADRectPointButton *)rectPointButton WithTag:(NSInteger)tag WithPoint:(CGPoint)point;

@end

@interface ADRectPointButton : UIButton

@property (nonatomic,weak) id <ADRectPointButtonDelegate> delegete ;


@end
