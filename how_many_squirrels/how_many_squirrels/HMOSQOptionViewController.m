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

#import "HMOSQOptionViewController.h"

@interface HMOSQOptionViewController ()

@end

@implementation HMOSQOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        id delegate = [[UIApplication sharedApplication]delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fetchedResultsController performFetch:nil];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _textView.inputAccessoryView = numberToolbar;
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *tmp = [prefs stringForKey:@"type"];
    if ([tmp length]!=0)
    {
        _textView.text = tmp;
    }
    else
    {
        _textView.text = @"Белки";
    }

    // Do any additional setup after loading the view from its nib.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    
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

-(void) cancelNumberPad
{
    [_textView resignFirstResponder];
    _textView.text = [prefs stringForKey:@"type"];
}

-(void) doneWithNumberPad
{
    [_textView resignFirstResponder];
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

-(IBAction)saveClick:(id)sender
{
    if (![[prefs stringForKey:@"type"] isEqualToString:_textView.text])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Все существующие данные будут стерты" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Принять", nil];
        [alert show];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [prefs setObject:_textView.text forKey:@"type"];
        [prefs setObject:0 forKey:@"count"];
        NSArray *items = [_fetchedResultsController fetchedObjects];
        
        
        for (NSManagedObject *managedObject in items)
        {
            [_managedObjectContext deleteObject:managedObject];
        }
        [_managedObjectContext save:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

}

@end
