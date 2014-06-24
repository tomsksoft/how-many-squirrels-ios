//
//  HMOSQTableViewController.h
//  how_many_squirrels
//
//  Created by Student1 on 18/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMOSQEditViewController.h"
@interface HMOSQTableViewController : UIViewController<NSFetchedResultsControllerDelegate,UIActionSheetDelegate,HMOSQEditViewControllerDelegate>
{
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic)IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *deleteButton;
@property(nonatomic,strong) IBOutlet UINavigationItem *navItem;
@end
