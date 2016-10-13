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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *drawView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@property (nonatomic,strong)ADRectViewsManager *rectViewsManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.rectViewsManager = [[ADRectViewsManager alloc] initWithFrame:self.drawView.bounds];
    [self.drawView addSubview:self.rectViewsManager];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
