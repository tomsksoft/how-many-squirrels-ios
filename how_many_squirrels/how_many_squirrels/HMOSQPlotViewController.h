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

@interface HMOSQPlotViewController : UIViewController<NSFetchedResultsControllerDelegate,CPTPlotDataSource>

{
    CPTXYGraph *graph;
    NSArray *plotData;
}

@property(strong,nonatomic) IBOutlet CPTGraphHostingView* plotView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
