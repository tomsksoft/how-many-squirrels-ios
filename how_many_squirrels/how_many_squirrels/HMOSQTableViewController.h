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

#import <UIKit/UIKit.h>
#import "HMOSQEditViewController.h"
#import "HMOSQParametr.h"
@interface HMOSQTableViewController : UIViewController<NSFetchedResultsControllerDelegate>
{
    NSUserDefaults *pref;
    NSString *currentName;
    NSString *currentType;
    HMOSQParametr *p;
    NSArray *valuesArray;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *deleteButton;
@property(nonatomic,strong) IBOutlet UINavigationItem *navItem;

@end
