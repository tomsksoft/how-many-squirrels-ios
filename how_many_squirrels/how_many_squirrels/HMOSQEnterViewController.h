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
#import "HMOSQParametr.h"
#import "HMOSQInfo.h"

@interface HMOSQEnterViewController : UIViewController<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate>
{
    NSNumber * num;
    NSUserDefaults *prefs;
    NSString *currentParamName;
    NSString *currentParamType;
    NSArray *pikerData;
    id valueForAdd;
    NSString *firstValue;
    BOOL isSelfTime;
}
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UIActionSheet *dateActionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain)IBOutlet UIPickerView *showPicker;
@property(strong,nonatomic)IBOutlet UILabel * dateTime;
@property(strong,nonatomic)IBOutlet UILabel * currentParam;
@property (strong,nonatomic)IBOutlet UITextField * field;
@property(strong,nonatomic) IBOutlet UISwitch * swch;
-(IBAction)oneClick:(id)sender;
-(IBAction)addFromKeyboard:(id)sender;
@end
