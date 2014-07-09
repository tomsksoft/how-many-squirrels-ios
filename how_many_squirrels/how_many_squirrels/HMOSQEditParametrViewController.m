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
- (IBAction)deleteFromEnum:(id)sender
{
    NSInteger row = [_enumPicker selectedRowInComponent:0];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:listEnum];
    [array removeObjectAtIndex:row];
    listEnum = [[NSArray alloc]initWithArray:array];
    [_enumPicker reloadAllComponents];
    if (listEnum.count == 0)
    {
        _deleteButton.hidden = 1;
    }
}

- (IBAction)saveClick:(id)sender
{
    if (![parametr.type isEqualToString:listOfTypes[[_typePicker selectedRowInComponent:0]]])
    {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Изменен тип параметра.Все данные будут удалены."  delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles: @"Принять", nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        [self saveChanges];
    }
}

-(void)saveChanges
{
    NSInteger row = [_typePicker selectedRowInComponent:0];
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
                if (![str isEqualToString:@""])
                {
                    if(defValue == nil)
                        defValue = [NSString stringWithFormat:@"%@",str];
                    else
                        defValue = [NSString stringWithFormat:@"%@/%@",str,defValue];
                }
            }
            break;
        }
            
        case 3:
        {
                /*NSDateFormatter * formater = [[NSDateFormatter alloc] init];
            formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
            //[formater setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
            defValue = [[NSString alloc] initWithFormat:@"%@/",[formater stringFromDate: [NSDate date]]];

            break;*/
        }
        case 4:
        {
            defValue = @"0ч.0мин.0сек./";
            break;
        }
        default:
        {
            defValue = @"";
            break;
        }
    }
    
    if (![parametr.type isEqualToString:listOfTypes[[_typePicker selectedRowInComponent:0]]])
    {
        
        parametr.type = listOfTypes[[_typePicker selectedRowInComponent:0]];
        [perf setValue:@"" forKey:@"count"];
        [perf synchronize];
    }
    parametr.name = _textField.text;
    parametr.def = defValue;
    if (isCurrent)
    {
        
        [perf setValue:parametr.name forKey:@"name"];
        [perf setValue:parametr.type forKeyPath:@"type"];
        [perf synchronize];
    }
    [_managedObjectContext save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1:
        {
            if (buttonIndex == 0)
            {
                NSLog(@"Отмена");
            }
            else
            {
                [self saveChanges];
                for (NSManagedObject *o in parametr.value)
                {
                    [_managedObjectContext deleteObject:o];
                }
                [_managedObjectContext save:nil];
            }
            break;
        }
        case 2:
        {
            NSString *name = [actionSheet textFieldAtIndex:0].text;
            NSMutableArray * a = [[NSMutableArray alloc] initWithArray:listEnum];
            [a addObject:name];
            listEnum = [[NSArray alloc] initWithArray:a];
            _deleteButton.hidden = 0;
            [_enumPicker reloadAllComponents];
            [_enumPicker selectRow:[a indexOfObject:name] inComponent:0 animated:0];
            NSLog(@"%@",defValue);
            break;
        }
        default:
        {
            break;
        }
    }
}

- (IBAction)cancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addToEnum:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Перечислимый параметр" message:@"Введите параметр" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Добавить", nil];
    av.tag = 2;
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
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
    listEnum = [parametr.def componentsSeparatedByString:@"/"];
    for (int i =0; i<listOfTypes.count; i++)
    {
        if ([listOfTypes[i] isEqualToString:parametr.type])
        {
            [_typePicker selectRow:i inComponent:0 animated:YES];
        }
    }
    if (([[perf stringForKey:@"name"] isEqualToString:parametr.name]) && [[perf stringForKey:@"type"] isEqualToString:parametr.type])
    {
        isCurrent = 1;
        _makeCurrent.hidden = YES;
    }
    //listEnum = [[NSArray alloc] init];
    if ([parametr.type isEqualToString:@"Перечислимое"])
    {
        if (listEnum!=nil)
        {
            _deleteButton.hidden = NO;
        }
        _enumPicker.hidden = NO;
        _addEnumButton.hidden = NO;
    }
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
        //selectedType = [listOfTypes objectAtIndex:row];
        //NSLog(@"%@",selectedType);
        switch (row)
        {
            case 0:
            {
                _addEnumButton.hidden = 1;
                _enumPicker.hidden = 1;
                _deleteButton.hidden = 1;
                break;
            }
            case 1:
            {
                _addEnumButton.hidden = 1;
                _enumPicker.hidden = 1;
                _deleteButton.hidden = 1;
                break;
            }
            case 2:
            {
                if(![parametr.type isEqualToString:@"Перечислимое"])
                {
                    NSMutableArray * a = [[NSMutableArray alloc] initWithArray:listEnum];
                    [a removeAllObjects];
                    listEnum = [NSArray arrayWithArray:a];
                    [_enumPicker reloadAllComponents];
                }
                _addEnumButton.hidden = 0;
                _enumPicker.hidden = 0;
                if (listEnum.count != 0)
                {
                    _deleteButton.hidden = 0;
                }
                break;
            }
                
            default:
            {
                _addEnumButton.hidden = 1;
                _enumPicker.hidden = 1;
                _deleteButton.hidden = 1;
                break;
            }
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
