//
//  ViewController.m
//  ADdrawRect
//
//  Created by andong on 10/12/16.
//  Copyright © 2016 andong. All rights reserved.
//

#import "ViewController.h"
#import "ADRectViewsManager.h"
#import "ADRectView.h"

@interface ViewController () <ADRectViewsManagerDelegate>

@property (weak, nonatomic) IBOutlet ADRectViewsManager *rectViewsManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.rectViewsManager.delegate = self;

    
    
}

- (IBAction)RectAction:(UIButton *)sender
{
    if ([sender.currentTitle isEqualToString:@"create"]) {
        [self.rectViewsManager createRectViewWithShape:self.segmentedControl.selectedSegmentIndex + 3];
    }
    if ([sender.currentTitle isEqualToString:@"delete"]) {
        [self.rectViewsManager deleteRectView:self.rectViewsManager.currentView];
    }
    if ([sender.currentTitle isEqualToString:@"save"]) {
        NSArray *array = [self.rectViewsManager saveRectView:self.rectViewsManager.currentView];
        NSLog(@"\npoint array \n%@\n ",array) ;
    }
    if ([sender.currentTitle isEqualToString:@"edit"]) {
        [self.rectViewsManager editRectView:self.rectViewsManager.currentView];
    }
}

-(IBAction)createRect
{
    //test date
    CGPoint pointOne = CGPointMake(100, 100);
    CGPoint pointTwo = CGPointMake(150, 100);
    CGPoint pointThree = CGPointMake(150, 150);
    CGPoint pointFour = CGPointMake(100, 150);
   
    ADRectPoint *rectPoint1 = [ADRectViewsManager createADRectPointWithPoint:pointOne];
    rectPoint1.pointId = 0;
     ADRectPoint *rectPoint2 = [ADRectViewsManager createADRectPointWithPoint:pointTwo];
    rectPoint2.pointId = 1;
     ADRectPoint *rectPoint3 = [ADRectViewsManager createADRectPointWithPoint:pointThree];
    rectPoint3.pointId = 2;
     ADRectPoint *rectPoint4 = [ADRectViewsManager createADRectPointWithPoint:pointFour];
    rectPoint4.pointId = 3;
    
    NSArray *pointArray = @[rectPoint1,rectPoint2,rectPoint3,rectPoint4];
    [self.rectViewsManager createRectViewWithPoints:pointArray];
    
}

- (void)beginEditWithRectView:(ADRectView *)rect
{
    
}

- (void)endEditWithRectView:(ADRectView *)rect
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
