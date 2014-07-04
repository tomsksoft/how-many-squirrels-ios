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
#import "HMOSQParametr.h"
#import "HMOSQInfo.h"

@interface HMOSQOptionViewController ()

@end

@implementation HMOSQOptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        //[self haveData];
    }
    return self;
}

-(void)defaultOptions
{
    
    [self addNewObject:@"Белки" :@"Целое":@"1/-1"];
    [self addNewObject:@"Граммы" :@"Вещественное":@"0.1/-0.1"];
    [self addNewObject:@"Прием пищи" :@"Перечислимое":@"Завтрак/Обед/Ужин"];
    [self addNewObject:@"Миг" :@"Момент времени":@""];
    [self addNewObject:@"Продолжительность" :@"Интервал времени":@""];
}

-(void)addNewObject:(NSString*) name : (NSString*) type :(NSString*)data
{
    HMOSQParametr * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Params"
     inManagedObjectContext:self.managedObjectContext];
     //  2
    newEntry.name = name;
    newEntry.type = type;
    newEntry.data = data;
    
     //  6
     /*HMOSQInfo * info = [NSEntityDescription insertNewObjectForEntityForName:@"Info"
     inManagedObjectContext:self.managedObjectContext];
     info.date = [NSDate date];
     info.number = @"1";*/
     
     //  7
     newEntry.value = [NSSet setWithObjects: nil];
    NSError * eror;
    [_managedObjectContext save:&eror];
    //NSLog(@"%@",eror);

    
}

-(void)viewWillAppear:(BOOL)animated
{
    currentType = [prefs stringForKey:@"type"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    [self.fetchedResultsController performFetch:nil];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Принять" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    //_textView.inputAccessoryView = numberToolbar;
    prefs = [NSUserDefaults standardUserDefaults];
    
    /*NSString *tmp = [prefs stringForKey:@"type"];
    if ([tmp length]!=0)
    {
        _textView.text = tmp;
    }
    else
    {
        _textView.text = @"Белки";
    }

    // Do any additional setup after loading the view from its nib.*/
}

- (NSFetchedResultsController *)fetchedResultsController
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Params" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    for (NSManagedObject *o in [aFetchedResultsController fetchedObjects])
    {
        NSLog(@"%@",o);
    }
    return _fetchedResultsController;
}

-(void) cancelNumberPad
{
    //[_textView resignFirstResponder];
    //_textView.text = [prefs stringForKey:@"type"];
}

-(void) doneWithNumberPad
{
    //[_textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    //[self.tableView endUpdates];
    [self.tableView reloadData];
}

-(IBAction)cancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if([_tableView isEditing])
    {
        //[self updateDeleteButtonTitle];
    }
    else
    {
        
        //HMOSQEditViewController* editView = [[HMOSQEditViewController alloc]init ];
        //editView.manageObject = [_fetchedResultsController objectAtIndexPath:path];
        //editView.delegate = self;
        //[self presentViewController:editView animated:YES completion:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self updateDeleteButtonTitle];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleNone;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"sfd = %lu",(unsigned long)[_fetchedResultsController.fetchedObjects count]);
    return [_fetchedResultsController.fetchedObjects count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    NSArray *array = [_fetchedResultsController fetchedObjects];
    HMOSQParametr * param = [array objectAtIndex:indexPath.item];
    cell.detailTextLabel.text = param.type;
    cell.textLabel.text = param.name;
    NSLog(@"%@   %@",param.type,param.name);
    //NSLog(@"%@",param.values);
    if (param.value!=nil)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, (%@)", param.type,@"Have data"];
    }
    if ([param.name isEqualToString: currentType])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


@end
