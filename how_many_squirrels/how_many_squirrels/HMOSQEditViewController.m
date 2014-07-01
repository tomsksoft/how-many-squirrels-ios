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
    info = self.manageObject;
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
    //_datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSLog(@"date %@",info.date);
    _datePicker.date = info.date;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    num = [[NSNumber alloc]initWithInt:[_text.text intValue]];
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
    [self.delegate closeEdit:self didFinishWithSave:NO withObject:info];
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
    [self.delegate closeEdit:self didFinishWithSave:YES withObject:info];
}
@end
