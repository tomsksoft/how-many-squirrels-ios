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
#import "HMOSQMainViewController.h"
#import "HMOSQEnterViewController.h"
#import "HMOSQPlotViewController.h"
#import "HMOSQTableViewController.h"

@interface HMOSQAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong,nonatomic)UITabBarController *tabBarController;
@property(strong,nonatomic) NSUserDefaults *options;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(NSArray*)getAllRecords;
@end
