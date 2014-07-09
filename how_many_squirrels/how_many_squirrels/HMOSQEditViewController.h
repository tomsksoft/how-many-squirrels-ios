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

@protocol HMOSQEditViewControllerDelegate;
#import <UIKit/UIKit.h>
#import "HMOSQInfo.h"

@interface HMOSQEditViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate>
{
    NSNumber * num;
    HMOSQInfo* info;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <HMOSQEditViewControllerDelegate> delegate;
@property (nonatomic, retain)IBOutlet UIDatePicker *datePicker;
@property (strong,nonatomic)IBOutlet UITextView * text;
@end

@protocol HMOSQEditViewControllerDelegate

-(id)initWhithContext:(NSManagedObjectContext*)context withInfo:(HMOSQInfo*) inf;
- (void)closeEdit:(HMOSQEditViewController *)controller didFinishWithSave:(BOOL)save withObject:(HMOSQInfo*) object;
@end
