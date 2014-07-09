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

#import "HMOSQParametrAddViewController.h"

@interface HMOSQParametrAddViewController ()

@end

@implementation HMOSQParametrAddViewController


-(id)initWithContext:(NSManagedObjectContext*)context
{
    self = [super init];
    if (self)
    {
        self.managedObjectContext = context;
    }
    return self;
}
-(IBAction)addToEnum:(id)sender
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Перечислимый параметр" message:@"Введите параметр" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Добавить", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
}

-(IBAction)deleteFromEnum:(id)sender
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

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            NSString *name = [actionSheet textFieldAtIndex:0].text;
            NSMutableArray * a = [[NSMutableArray alloc] initWithArray:listEnum];
            [a addObject:name];
            listEnum = [[NSArray alloc] initWithArray:a];
            _deleteButton.hidden = 0;
            [_enumPicker reloadAllComponents];
            [_enumPicker selectRow:[a indexOfObject:name] inComponent:0 animated:0];
            break;
        }
            
        default:
            break;
    }
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


-(IBAction)cancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveClick:(id)sender
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
    [self addNewObject:_textField.text :listOfTypes[[_typePicker selectedRowInComponent:0]] :defValue];
    if (_swch.isOn)
    {
        [perf setValue:_textField.text forKey:@"name"];
        [perf setValue:listOfTypes[[_typePicker selectedRowInComponent:0]] forKey:@"type"];
        [perf setValue:@"" forKey:@"count"];
        [perf synchronize];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

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
}

-(void)addNewObject:(NSString*) name : (NSString*) type :(NSString*)data
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Params"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    for (HMOSQParametr *p in [self.managedObjectContext executeFetchRequest:request error:nil])
    {
        if ([p.name isEqualToString:name])
        {
            return;
        }
    }
    HMOSQParametr * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Params"inManagedObjectContext:self.managedObjectContext];
    newEntry.name = name;
    newEntry.type = type;
    newEntry.def = data;
    newEntry.value = [NSSet setWithObjects: nil];
    [_managedObjectContext save:nil];
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
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Params"
                                              inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    for (HMOSQParametr *p in [self.managedObjectContext executeFetchRequest:request error:nil])
    {
        if ([p.name isEqualToString:_textField.text])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание"
                                                        message:@"Параметр с таким именем существует."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alert show];

            return;
        }
    }
    parametr.name = _textField.text;
    [_textField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customInit];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
