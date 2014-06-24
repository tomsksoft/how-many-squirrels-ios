//
//  HMOSQEnterViewController.h
//  how_many_squirrels
//
//  Created by Student1 on 18/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMOSQEnterViewController : UIViewController<NSFetchedResultsControllerDelegate,UITextViewDelegate,UIActionSheetDelegate>
{
    NSNumber * num;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIActionSheet *dateActionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property(strong,nonatomic)IBOutlet UILabel * dateTime;
@property (strong,nonatomic)IBOutlet UITextView * text;
@property(strong,nonatomic) IBOutlet UISwitch * swch;
-(IBAction)plusClick:(id)sender;
-(IBAction)decClick:(id)sender;
@end
