//
//  HMOSQEnterViewController.m
//  how_many_squirrels
//
//  Created by Student1 on 18/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

#import "HMOSQEnterViewController.h"
#import "HMOSQKeyViewController.h"

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
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

-(IBAction)plusClick:(id)sender
{
    
    int count = [_text.text intValue];
    NSString * str = [[NSString alloc]initWithFormat:@"%d",count+1 ];
    _text.text = str;
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
    _text.text = str;
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
    [self updateTime];
    _text.delegate = self;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _text.inputAccessoryView = numberToolbar;
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
