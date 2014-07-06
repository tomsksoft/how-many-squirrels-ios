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

@interface HMOSQEditParametrViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSUserDefaults *perf;
    HMOSQParametr * parametr;
    NSArray *listOfTypes;
    NSArray *listEnum;
    NSString *firstValue;
    NSString *selectedType;
    NSString *defValue;
}

@property (weak, nonatomic) IBOutlet UIButton *makeCurrent;
-(id)initWithContext : (NSManagedObjectContext*) context : (HMOSQParametr*) p;
@property (weak, nonatomic) IBOutlet UIButton *addEnumButton;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *enumPicker;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
