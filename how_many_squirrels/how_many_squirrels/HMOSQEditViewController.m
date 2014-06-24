//
//  HMOSQEditViewController.m
//  how_many_squirrels
//
//  Created by Student1 on 24/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

#import "HMOSQEditViewController.h"
#import "HMOSQInfo.h"

@interface HMOSQEditViewController ()

@end

@implementation HMOSQEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HMOSQInfo * info = self.manageObject;
    _text.delegate = self;
    [_text setText: [[NSString alloc] initWithFormat:@"%@",info.number]];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _text.inputAccessoryView = numberToolbar;
    _datePicker.date = info.date;
    // Do any additional setup after loading the view from its nib.
}

-(void) cancelNumberPad
{
    
}

-(void) doneWithNumberPad
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate addViewController:self didFinishWithSave:NO];
}


- (IBAction)save:(id)sender
{
    [self.delegate addViewController:self didFinishWithSave:YES];
}
@end
