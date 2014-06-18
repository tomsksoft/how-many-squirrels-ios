//
//  HMOSQEnterViewController.m
//  how_many_squirrels
//
//  Created by Student1 on 18/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

#import "HMOSQEnterViewController.h"

@interface HMOSQEnterViewController ()

@end

@implementation HMOSQEnterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Ввод данных" image:[UIImage imageNamed:@""] tag:0];        // Custom initialization
 }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
