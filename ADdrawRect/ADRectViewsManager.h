//
//  ADRectViewsManager.h
//  ADdrawRect
//
//  Created by andong on 10/13/16.
//  Copyright © 2016 andong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRectView.h"

@interface ADRectViewsManager : UIView

@property (nonatomic,strong,readonly)ADRectView *currentView;

- (void)createRectViewWithShape:(ADViewShape)shape;

- (void)editRectView:(ADRectView *)rect;
- (NSArray *)saveRectView:(ADRectView *)rect;
- (void)deleteRectView:(ADRectView *)rect;

@end
