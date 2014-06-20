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
        id delegate = [[UIApplication sharedApplication]delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
 }
    return self;
}

-(void) updateTime
{
    NSDate * now = [NSDate date];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
    _dateTime.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:now]];
    //[self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

-(IBAction)plusClick:(id)sender
{
    
    int count = [_text.text intValue];
    NSLog(@"%@",_text.text);
    NSString * str = [[NSString alloc]initWithFormat:@"%d",count+1 ];
    //_text.text = str;
    [_text setText:str];
    [self addNewObject:[NSDate date] :[NSNumber numberWithInt:1]];
    
}
-(IBAction)decClick:(id)sender
{
    int count = [_text.text intValue];
    if (count==0)
    {
        return;
    }
    NSString * str = [[NSString alloc]initWithFormat:@"%d",count-1 ];
    [_text setText:str];
    [self addNewObject:[NSDate date] :[NSNumber numberWithInt:-1]];
}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

-(void)addNewObject:(NSDate*) date : (NSNumber*) count
{
    NSManagedObjectContext * context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription * disc = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:[disc name] inManagedObjectContext:context];
    [object setValue: date forKey:@"date"];
    [object setValue:count forKey:@"number"];
    [context save:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stateChange];
    _text.delegate = self;
    [_text setText:@"100"];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _text.inputAccessoryView = numberToolbar;
    _dateActionSheet = [[UIActionSheet alloc] initWithTitle:@"DateTime"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem
                                :UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClick:)];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerCancelClick:)];
    [barItems addObject:cancelBtn];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [pickerDateToolbar setItems:barItems animated:YES];
    [self.dateActionSheet addSubview:pickerDateToolbar];
    [self.dateActionSheet addSubview:self.datePicker];
    [_swch addTarget:self action:@selector(stateChange) forControlEvents:UIControlEventValueChanged];
}

-(void) stateChange
{
    if ([_swch isOn])
    {
        
        [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
        [self updateTime];

    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTime) object:nil];
        [self.dateActionSheet showInView:self.view];
        [self.dateActionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
}

-(void)datePickerDoneClick:(id)sender
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
    _dateTime.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:_datePicker.date]];
      [self.dateActionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

-(void)datePickerCancelClick:(id)sender
{
     [self.dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)cancelNumberPad
{
    [_text resignFirstResponder];
    _text.text = [[NSString alloc]initWithFormat:@"%@",num];
}

-(void)doneWithNumberPad
{
    int count = [_text.text intValue];
    NSString * str = [[NSString alloc]initWithFormat:@"%d",count ];
    _text.text = str;
    [self addNewObject:[NSDate date] :[NSNumber numberWithInt:count]];
    [_text resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated
{
    //_dateTime.text = [[NSString alloc] initWithFormat:@"date: %@", _dateTimePicker.date];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    num = [[NSNumber alloc]initWithInt:[_text.text intValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
