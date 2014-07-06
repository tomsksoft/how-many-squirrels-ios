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

#import "HMOSQEditParametrViewController.h"

@interface HMOSQEditParametrViewController ()

@end

@implementation HMOSQEditParametrViewController

- (IBAction)saveClick:(id)sender
{
    if (![parametr.type isEqualToString:selectedType])
    {
        if (parametr.value.count!=0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Изменен тип параметра.Все данные будут удалены."  delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles: @"Принять", nil];
            [alert show];
        }
    }
    else
    {
        parametr.name = _textField.text;
        [perf setValue:parametr.name forKey:@"name"];
        [perf synchronize];
        [_managedObjectContext save:nil];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Отмена");
    }
    else
    {
        NSLog(@"Принять");
        parametr.name = _textField.text;
        parametr.type = selectedType;
        parametr.def = defValue;
        for (NSManagedObject *o in parametr.value)
        {
            [_managedObjectContext deleteObject:o];
        }
        [_managedObjectContext save:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addToEnum:(id)sender
{
    
}
- (IBAction)makeCurrent:(id)sender
{
    [perf setValue:parametr.name forKey:@"name"];
    [perf setValue:parametr.type forKey:@"type"];
    [perf synchronize];
    [_makeCurrent setHidden:YES];
}

-(id)initWithContext:(NSManagedObjectContext *)context : (HMOSQParametr*)p
{
    self = [super init];
    if (self)
    {
        parametr = p;
        self.managedObjectContext = context;
    }
    return self;
    
}

-(void)customInit
{
    perf = [NSUserDefaults standardUserDefaults];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],nil];
    [numberToolbar sizeToFit];
    _textField.inputAccessoryView = numberToolbar;
    _textField.text = parametr.name;
    listOfTypes = [NSArray arrayWithObjects:@"Целое",@"Вещественное",@"Перечислимое",@"Момент времени",@"Интервал времени",nil];
    for (int i =0; i<listOfTypes.count; i++)
    {
        if ([listOfTypes[i] isEqualToString:parametr.name])
        {
            [_typePicker selectRow:i inComponent:0 animated:YES];
            selectedType = [listOfTypes objectAtIndex:i];
        }
    }
    if (([[perf stringForKey:@"name"] isEqualToString:parametr.name]) && [[perf stringForKey:@"type"] isEqualToString:parametr.type])
    {
        _makeCurrent.hidden = YES;
    }
    if ([parametr.name isEqualToString:@"Перечислимое"])
    {
        listEnum = [parametr.def componentsSeparatedByString:@"/"];
        _enumPicker.hidden = NO;
        _addEnumButton.hidden = NO;
    }
    defValue = @"";
}

-(void)cancelNumberPad
{
    _textField.text = firstValue;
    [_textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    firstValue = _textField.text;
}

-(void)doneWithNumberPad
{
    parametr.name = _textField.text;
    [_textField resignFirstResponder];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag ==1)
    {
        return [listOfTypes count];
    }
    else
    {
        return [listEnum count];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag ==1)
    {
        selectedType = [listOfTypes objectAtIndex:row];
        switch (row)
        {
            case 0:
            {
                defValue = @"1/-1"; break;
            }
            case 1:
            {
                defValue = @"0.1/-0.1"; break;
            }
            case 2:
            {
                for (NSString *str in listEnum)
                {
                    if([defValue isEqualToString:@""])
                        defValue = str;
                    else
                    {
                        defValue = [NSString stringWithFormat:@"%@/%@",str,defValue];
                    }
                }
                break;
            }
                
            default:
                break;
        }
        if (row== 2)
        {
            _enumPicker.hidden = NO;
            _addEnumButton.hidden = NO;
        }
        else
        {
            _enumPicker.hidden = YES;
            _addEnumButton.hidden = YES;
        }
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title;
    
    if (pickerView.tag == 1)
    {
        title=[listOfTypes objectAtIndex:row];
    }
    else if (pickerView.tag == 2)
    {
        title=[listEnum objectAtIndex:row];
    }
    
    return title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
