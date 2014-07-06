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

-(void)deleteAll
{
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"Params" inManagedObjectContext:self.managedObjectContext]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [self.managedObjectContext executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [self.managedObjectContext deleteObject:car];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
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
    HMOSQParametr * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Params"
     inManagedObjectContext:self.managedObjectContext];
    newEntry.name = name;
    newEntry.type = type;
    newEntry.def = data;
    newEntry.value = [NSSet setWithObjects: nil];
    [_managedObjectContext save:nil];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    currentType = [prefs stringForKey:@"type"];
    currentName = [prefs stringForKey:@"name"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    [self.fetchedResultsController performFetch:nil];
    
    
    //[self defaultOptions];
    //[self deleteAll];
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
    return [_fetchedResultsController.fetchedObjects count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    NSArray *array = [_fetchedResultsController fetchedObjects];
    HMOSQParametr * param = [array objectAtIndex:indexPath.item];
    cell.detailTextLabel.text = param.type;
    cell.textLabel.text = param.name;
    if (param.value.count!=0)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, (%@)", param.type,@"Есть данные"];
    }
    if ([param.name isEqualToString: currentName] && [param.type isEqualToString: currentType])
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
