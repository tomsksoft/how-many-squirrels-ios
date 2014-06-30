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
#import <CorePlot/CorePlot-CocoaTouch.h>
#import "HMOSQInfo.h"
#import "HMOSQPlotView.h"

@interface HMOSQPlotViewController : UIViewController<NSFetchedResultsControllerDelegate,UIActionSheetDelegate>

{
    CPTXYGraph *graph;
    NSArray *plotData;
    NSDate *minDate;
    NSDate *maxDate;
    BOOL isMinDateClick;
}

@property(strong,nonatomic) IBOutlet HMOSQPlotView* plotView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic)IBOutlet UILabel * minLabel;
@property(strong,nonatomic)IBOutlet UILabel * maxLabel;
@property (nonatomic, retain) UIActionSheet *dateActionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property(strong,nonatomic) IBOutlet UISwitch * swch;
@end
