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
#import "HMOSQParametr.h"

@interface HMOSQEditViewController : UIViewController
{
    NSNumber * num;
    HMOSQInfo* info;
    NSUserDefaults *pref;
    NSInteger numberOfComponent;
    HMOSQParametr *parametr;
    NSArray *listEnum;
    NSString *lastValue;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *momentPicker;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id <HMOSQEditViewControllerDelegate> delegate;
@property (nonatomic, retain)IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain)IBOutlet UIPickerView *enumPicker;
@property (strong,nonatomic)IBOutlet UITextField * text;

@property (strong,nonatomic)IBOutlet UILabel * label;


-(id)initWhithContext:(NSManagedObjectContext*)context withInfo:(HMOSQInfo*) inf withParametr:(HMOSQParametr*)p;

@end
