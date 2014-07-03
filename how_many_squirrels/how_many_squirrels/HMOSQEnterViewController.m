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
#import "HMOSQEnum.h"

@interface HMOSQEnterViewController ()

@end

@implementation HMOSQEnterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Ввод данных" image:[UIImage imageNamed:@"iconm.png"] tag:0];        // Custom initialization
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [recognizer setNumberOfTapsRequired:1];
        //lblName.userInteractionEnabled = true;  (setting this in Interface Builder)
        //[_dateTime addGestureRecognizer:recognizer];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pikerData!=nil)
    {
        //NSLog(@"picker count = %lu",(unsigned long)[pikerData count]);
        return [pikerData count];//this will tell the picker how many rows it has - in this case, the size of your loaded array...
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //you can also write code here to descide what data to return depending on the component ("column")
    if (pikerData!=nil)
    {
        //NSLog(@"value at row%@",[pikerData objectAtIndex:row]);
        return [pikerData objectAtIndex:row];//assuming the array contains strings..
    }
    return @"";//or nil, depending how protective you are
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    firstValue = _field.text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    valueForAdd = [pikerData objectAtIndex:row];
    NSLog(@"value to add = %@",valueForAdd);
}

-(void) customInit
{
    
    /*[prefs setObject:@"Белки" forKey:@"name"];
    [prefs setObject:@"Целое" forKey:@"type"];
    [prefs synchronize];*/
    currentParamType = @"Вещественное";
    _currentParam.text = [NSString stringWithFormat:@"Текущий параметр: %@,Тип: %@",currentParamName,currentParamType];
    if ([currentParamType isEqualToString:@"Целое"])
    {
        pikerData = [[NSArray alloc] initWithObjects: @"1", @"-1", nil];
        //valueForAdd = pikerData[0];
    }
    if([currentParamType isEqualToString:@"Вещественное"])
    {
        pikerData = [[NSArray alloc] initWithObjects: @"0.1", @"-0.1", nil];
        
    }
    valueForAdd = pikerData[0];
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
        [_dateTime setTextColor:[UIColor blackColor]];
    }
    
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

-(IBAction)oneClick:(id)sender
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd.MM.yy. hh:mm:ss"];
    //[dateFormater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *currentDate = [dateFormater dateFromString:_dateTime.text];
    _field.text = valueForAdd;
    [self addNewObject:currentDate :currentParamName];
    [self saveLastValue];
}

-(IBAction)addFromKeyboard:(id)sender
{
    [_field setUserInteractionEnabled:YES];
    [_field becomeFirstResponder];
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

-(void)addNewObject:(NSDate*) date  :(NSString*) paramName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Params"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name = %@", paramName];
    [request setPredicate:pred];
    HMOSQParametr *par = [self.managedObjectContext executeFetchRequest:request error:nil][0];
    NSMutableArray * a =[[par.value allObjects]mutableCopy];
    HMOSQInfo* i = [NSEntityDescription insertNewObjectForEntityForName:@"Info" inManagedObjectContext:self.managedObjectContext];
    i.date = date;
    i.number = valueForAdd;
    i.param = par;
    [a addObject:i];
    par.value = [NSSet setWithArray:a];
    [self.managedObjectContext save:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stateChange];
    
    
    _field.delegate = self;
    _showPicker.delegate =self;
    //_textView.delegate = self;
    //[_text setText:@"100"];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],nil];
    [numberToolbar sizeToFit];
    _field.inputAccessoryView = numberToolbar;
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
    
    //UITextField * textFieldItem = [[UITextField alloc] init];
   // UIBarButtonItem *field = [[UIBarButtonItem alloc] initWithCustomView:_textView];
    
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
    
    id delegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [delegate managedObjectContext];
}

-(void) stateChange
{
    if ([_swch isOn])
    {
        [self updateTime];
        isSelfTime = NO;
        //[_dateTime setTextColor:[UIColor blackColor]];
    }
    else
    {
        isSelfTime = YES;
        [self.dateActionSheet showInView:self.view];
        [self.dateActionSheet setBounds:CGRectMake(0,0,320, 464)];
    }
}

-(void)datePickerDoneClick:(id)sender
{
    isSelfTime = NO;
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
    if (!_swch.isOn && isSelfTime)
    {
        [_swch setOn:YES];
        //[_text setTextColor:[UIColor blackColor]];
    }
    else
    {
        [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
    }
}
-(void)cancelNumberPad
{
    _field.text = firstValue;
    [_field resignFirstResponder];
    [_field setUserInteractionEnabled:NO];
    //_text.text = [[NSString alloc]initWithFormat:@"%@",num];
}

-(void)doneWithNumberPad
{
    valueForAdd = _field.text;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd.MM.yy. hh:mm:ss"];
    //[dateFormater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *currentDate = [dateFormater dateFromString:_dateTime.text];
    [self addNewObject:currentDate :currentParamName];
    [_field resignFirstResponder];
    [self saveLastValue];
}

- (void) viewWillAppear:(BOOL)animated
{
    [_showPicker reloadAllComponents];
    
    currentParamName = [prefs stringForKey:@"name"];
    currentParamType = [prefs stringForKey:@"type"];
    [self customInit];
    NSString *str = [prefs stringForKey:@"count"];
    if ([str length]!=0)
    {
        _field.text = str;
    }
    else
    {
        _field.text = @"0";
    }
}

-(void)saveLastValue
{
    [prefs setObject:valueForAdd forKey:@"count"];
    [prefs synchronize];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //num = [[NSNumber alloc]initWithInt:[_text.text intValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
