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
