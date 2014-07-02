/*
 * How many squirrels: tool for young naturalist
 *
 * This application is created within the internship
 * in the Education Department of Tomsksoft, http://tomsksoft.com
 * Idea and leading: Sergei Borisov
 *
 * This software is licensed under a GPL v3
 * http://www.gnu.org/licenses/gpl.txt
 *
 * Created by Anton Tsygantsev on 18/06/14
 */

#import "HMOSQEnterViewController.h"

@interface HMOSQEnterViewController ()

@end

@implementation HMOSQEnterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Ввод данных" image:[UIImage imageNamed:@"iconm.png"] tag:0];        // Custom initialization
        id delegate = [[UIApplication sharedApplication]delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [recognizer setNumberOfTapsRequired:1];
        //lblName.userInteractionEnabled = true;  (setting this in Interface Builder)
        [_dateTime addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)tapAction
{
    if(!_swch.isOn)
    {
        [self.dateActionSheet showInView:self.view];
        [self.dateActionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
}

-(void) updateTime
{
    if (_swch.isOn)
    {
        NSDate * now = [NSDate date];
        NSDateFormatter * formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
        _dateTime.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:now]];
    }
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

-(IBAction)plusClick:(id)sender
{
    
    int count = [_text.text intValue];
    NSLog(@"%@",_text.text);
    NSString * str = [[NSString alloc]initWithFormat:@"%d",count+1 ];
    [_text setText:str];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd.MM.yy. hh:mm:ss"];
    //[dateFormater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *currentDate = [dateFormater dateFromString:_dateTime.text];
    NSLog(@"%@",currentDate);
    [self addNewObject:currentDate :[NSNumber numberWithInt:1]];
    [self setCount];
    
    
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
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    //[dateFormater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormater setDateFormat:@"dd.MM.yy. hh:mm:ss"];
    NSDate *currentDate = [dateFormater dateFromString:_dateTime.text];
    [self addNewObject:currentDate :[NSNumber numberWithInt:-1]];
    [self setCount];
}
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
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
    //[_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
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
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [recognizer setNumberOfTapsRequired:1];
    //lblName.userInteractionEnabled = true;  (setting this in Interface Builder)
    [_dateTime addGestureRecognizer:recognizer];
    
    prefs = [NSUserDefaults standardUserDefaults];
}

-(void) stateChange
{
    if ([_swch isOn])
    {
        [self updateTime];
        [_dateTime setTextColor:[UIColor blackColor]];
    }
    else
    {
        [self.dateActionSheet showInView:self.view];
        [self.dateActionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
}

-(void)datePickerDoneClick:(id)sender
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
    //[formater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    _dateTime.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:_datePicker.date]];
    [self.dateActionSheet dismissWithClickedButtonIndex:2 animated:YES];
    [_dateTime setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] ];
}

-(void)datePickerCancelClick:(id)sender
{
    [self.dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
    if (!_swch.isOn)
    {
        //[_swch setOn:YES];
        //[_text setTextColor:[UIColor blackColor]];
    }
    else
    {
        [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
    }
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
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd.MM.yy. hh:mm:ss"];
    //[dateFormater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *currentDate = [dateFormater dateFromString:_dateTime.text];
    [self addNewObject:currentDate :[NSNumber numberWithInt:count]];
    [_text resignFirstResponder];
    [self setCount];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSInteger myInt = [prefs integerForKey:@"count"];
    NSString *str = [[NSString alloc] initWithFormat:@"%ld", (long)myInt];
    if ([str length]!=0)
    {
        _text.text = str;
    }
    else
    {
        _text.text = @"0";
    }
}

-(void)setCount
{
    int number = [_text.text intValue];
    [prefs setInteger:number forKey:@"count"];
    [prefs synchronize];
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
