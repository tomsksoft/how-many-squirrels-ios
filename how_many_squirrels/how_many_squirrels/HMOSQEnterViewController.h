//
//  HMOSQEnterViewController.h
//  how_many_squirrels
//
//  Created by Student1 on 18/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMOSQEnterViewController : UIViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property(strong,nonatomic)UIDatePicker * dateTimePicker;
@property(strong,nonatomic)IBOutlet UILabel * dateTime;
-(IBAction)addClick:(id)sender;

@end
