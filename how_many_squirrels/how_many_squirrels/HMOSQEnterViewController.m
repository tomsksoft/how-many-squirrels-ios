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

-(void) updateTime
{
    NSDate * now = [NSDate date];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
    _dateTime.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:now]];
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTime];

    // Do any additional setup after loading the view from its nib.
}
- (void) viewDidAppear:(BOOL)animated
{
    //_dateTime.text = [[NSString alloc] initWithFormat:@"date: %@", _dateTimePicker.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
