//
//  ADRectViewsManager.h
//  ADdrawRect
//
//  Created by andong on 10/13/16.
//  Copyright © 2016 andong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRectView.h"

@protocol ADRectViewsManagerDelegate <NSObject>

- (void)beginEditWithRectView:(ADRectView *)rect;
- (void)endEditWithRectView:(ADRectView *)rect;

- (void)rectPointMoving:(ADRectView *)rect;
- (void)rectPointMoveStop:(ADRectView *)rect;
@end

@interface ADRectViewsManager : UIView

@property (nonatomic,strong,readonly)ADRectView *currentView;

@property (nonatomic,weak) id <ADRectViewsManagerDelegate> delegate;

- (void)createRectViewWithShape:(ADViewShape)shape;
- (void)createRectViewWithPoints:(NSArray <ADRectPoint *>*)points;

- (void)editRectView:(ADRectView *)rect;
- (void)deleteRectView:(ADRectView *)rect;
- (NSArray *)saveRectView:(ADRectView *)rect;

+ (ADRectPoint *)createADRectPointWithPoint:(CGPoint)point;

- (NSInteger)getMinID;
@end
