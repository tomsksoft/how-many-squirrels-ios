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

#import "HMOSQEditViewController.h"

@interface HMOSQEditViewController ()

@end

@implementation HMOSQEditViewController


-(id)initWhithContext:(NSManagedObjectContext*)context withInfo:(HMOSQInfo*) inf withParametr:(HMOSQParametr *)p
{
    self = [super init];
    if (self)
    {
        self.managedObjectContext = context;
        info = inf;
        parametr = p;
    }
    return self;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (numberOfComponent)
    {
        case 1:
        {
            return [listEnum count];break;
        }
        case 3:
        {
            switch (component)
            {
                case 0:return 24; break;
                case 1:return 60; break;
                case 2:return 60; break;
                default:
                    break;
            }
        }
        default:
        {
            break;
        }
    }
    return 0;

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    switch (numberOfComponent)
    {
        case 1:
        {
            return [listEnum objectAtIndex:row];break;
        }
        case 3:
        {
            switch (component)
            {
                case 0:
                    return [[NSString alloc] initWithFormat:@"%ldч.",(long)row];
                    break;
                case 1:
                    return [[NSString alloc] initWithFormat:@"%ldмин.",(long)row];
                    break;
                case 2:
                    return [[NSString alloc] initWithFormat:@"%ldсек.",(long)row];
                    break;
                    
                default:
                    break;
            }
        }
            
        default:
        {
            break;
        }
    }
    
    return result;
}


-(void)customInit
{
    
    [_text setText: [[NSString alloc] initWithFormat:@"%@",info.number]];
    _datePicker.date = info.date;
    parametr.type = @"Интервал времени";
    listEnum = [parametr.def componentsSeparatedByString:@"/"];
    if ([parametr.type isEqualToString:@"Целое"])
    {
        _enumPicker.hidden = 1;
    }
    if ([parametr.type isEqualToString:@"Вещественное"])
    {
        _enumPicker.hidden = 1;
    }
    if ([parametr.type isEqualToString:@"Перечисление"])
    {
        _enumPicker.hidden = 0;
        _label.hidden = 1;
        _text.hidden = 1;
        numberOfComponent = 1;
    }
    if ([parametr.type isEqualToString:@"Момент времени"])
    {
        _enumPicker.hidden = 1;
        _label.hidden = 1;
        _text.hidden = 1;
    }
    if ([parametr.type isEqualToString:@"Интервал времени"])
    {
        
        numberOfComponent = 3;
        _enumPicker.hidden = 0;
        [_text setBorderStyle:UITextBorderStyleNone];
        [_text setUserInteractionEnabled:0];
        info.number = @"0ч.2мин.50сек.";
        _text.text = info.number;
        NSArray *array = [info.number componentsSeparatedByString:@"."];
        [_enumPicker selectRow:[array[0] intValue] inComponent:0 animated:0];
        [_enumPicker selectRow:[array[1] intValue] inComponent:1 animated:0];
        [_enumPicker selectRow:[array[2] intValue] inComponent:2 animated:0];
    }



}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _enumPicker.delegate = self;
    pref = [NSUserDefaults standardUserDefaults];
    //_text.delegate = self;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _text.inputAccessoryView = numberToolbar;
    [self customInit];
    //_datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
}

-(void) cancelNumberPad
{
    [_text resignFirstResponder];
    _text.text = [[NSString alloc]initWithFormat:@"%@",num];
}

-(void) doneWithNumberPad
{
    [_text resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    //[self.delegate closeEdit:self didFinishWithSave:NO withObject:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setCurrentDate:(id)sender
{
    _datePicker.date = [NSDate date];
}


- (IBAction)save:(id)sender
{
    int tmp = [_text.text intValue];
    info.number = [[NSNumber alloc] initWithInt:tmp];
    info.date = _datePicker.date;
}
@end
