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

#import "HMOSQTableViewController.h"
#import "HMOSQInfo.h"

@interface HMOSQTableViewController ()
@end

@implementation HMOSQTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Таблица" image:[UIImage imageNamed:@"iconm.png"] tag:0];        // Custom initialization
        id delegate = [[UIApplication sharedApplication]delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        //self.fetchedRecordsArray = [delegate getAllRecords];
    }
    return self;
}

- (void)closeEdit:(HMOSQEditViewController *)controller didFinishWithSave:(BOOL)save withObject:(HMOSQInfo*) object
{
    if (save)
    {
        HMOSQInfo* inf = [_fetchedResultsController objectAtIndexPath:[_tableView indexPathForSelectedRow]];
        [inf setValue:object.date forKey:@"date"];
        [inf setValue:object.number forKeyPath:@"number"];
        [self.managedObjectContext save:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)editClick:(id)sender
{
    
    [_tableView setEditing:YES animated:YES];
    _navItem.rightBarButtonItem = _cancelButton;
    _navItem.leftBarButtonItem = _deleteButton;
}

-(IBAction)cancelClick:(id)sender
{
    
    [_tableView setEditing:NO animated:YES];
    _navItem.rightBarButtonItem = _editButton;
    _navItem.leftBarButtonItem = nil;
}

-(IBAction)deleteClick:(id)sender
{
    NSArray *selectedRows = [_tableView indexPathsForSelectedRows];
    if (selectedRows.count==0 || selectedRows.count == [_fetchedResultsController.fetchedObjects count])
    {
        for (NSManagedObject * inf in _fetchedResultsController.fetchedObjects)
        {
            [_managedObjectContext deleteObject:inf];
        }
    }
    else
    {
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [_managedObjectContext deleteObject:[_fetchedResultsController objectAtIndexPath:selectionIndex]];
            [_managedObjectContext save:nil];
            [self configureCell:[_tableView cellForRowAtIndexPath:selectionIndex] atIndexPath:selectionIndex];
        }
    }
    [_managedObjectContext save:nil];
    [_tableView setEditing:NO animated:YES];
    _navItem.rightBarButtonItem = _editButton;
    _navItem.leftBarButtonItem = nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path
{
    if([_tableView isEditing])
    {
        [self updateDeleteButtonTitle];
    }
    else
    {
        
        HMOSQEditViewController* editView = [[HMOSQEditViewController alloc]init ];
        editView.manageObject = [_fetchedResultsController objectAtIndexPath:path];
        editView.delegate = self;
        [self presentViewController:editView animated:YES completion:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updateDeleteButtonTitle];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.fetchedResultsController performFetch:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    //[_tableView endUpdates];
}
- (NSFetchedResultsController *)fetchedResultsController
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    //[self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    //[self.tableView endUpdates];
    [self.tableView reloadData];
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    HMOSQInfo * inf = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd/MM/yy hh:mm:ss";
    [formater setTimeZone: [NSTimeZone localTimeZone]];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:inf.date]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ",inf.number];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _navItem.rightBarButtonItem = _editButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDeleteButtonTitle
{
    NSArray *selectedRows = [_tableView indexPathsForSelectedRows];
    
    BOOL allItemsAreSelected = selectedRows.count == [_fetchedResultsController.fetchedObjects count];
    BOOL noItemsAreSelected = selectedRows.count == 0;
    
    if (allItemsAreSelected || noItemsAreSelected)
    {
        self.deleteButton.title = (@"Удалить все");
    }
    else
    {
        NSString *titleFormatString = (@"Удалить (%d)");
        _deleteButton.title = [NSString stringWithFormat:titleFormatString, selectedRows.count];
    }
}

@end
