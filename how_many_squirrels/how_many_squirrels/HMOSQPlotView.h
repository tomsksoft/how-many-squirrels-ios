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

#import "CPTGraphHostingView.h"

#import "HMOSQInfo.h"
#import <CorePlot/CorePlot-CocoaTouch.h>

@interface HMOSQPlotView : CPTGraphHostingView <CPTPlotDataSource,CPTPlotDelegate,CPTPlotSpaceDelegate>
{
    CPTXYGraph *graph;
    NSDictionary *data;
    NSDictionary *sets;
    NSArray *dates;
    BOOL isDatePlot;
}

- (void)createDatePlot : (NSArray*) objects withMinDate:(NSDate*) minDate withMaxDate: (NSDate*)maxdate;
- (void)createBarPlot : (NSArray*) objects withMinDate:(NSDate*) minDate withMaxDate: (NSDate*)maxdate;
@end
