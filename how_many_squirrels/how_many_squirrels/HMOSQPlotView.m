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

#import "HMOSQPlotView.h"

@implementation HMOSQPlotView

-(void)generateDataWithoutTime:(NSDate*) minDate : (NSDate*)maxDate :(NSArray*)objects
{
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    NSMutableArray* datesTmp = [[NSMutableArray alloc] init];
    sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], @"Plot 1",nil];
    HMOSQInfo *inf;
    NSDate *dt = minDate;
    int count =0;
    NSTimeInterval oneDay = 60*60*24;
    
    NSTimeInterval secondsBetween = [maxDate timeIntervalSinceDate:minDate];
    
    int numberOfDays = secondsBetween / oneDay+1;
    for (int i=0; i<numberOfDays; i++)
    {
        for (NSManagedObject *object in objects)
        {
            inf = object;
            if (([self getDay:dt] == [self getDay:inf.date])&&
                ([self getMonth:dt] == [self getMonth:inf.date]))
            {
                count+=[inf.number intValue];
            }
        }
        if (count!=0)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yy"];
            NSString *str = [dateFormatter stringFromDate:dt];
            [datesTmp addObject:str];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *set in sets)
            {
                [dict setObject:[NSNumber numberWithInt:count] forKey:set];
            }
            [dataTemp setObject:dict forKey:[datesTmp objectAtIndex:[datesTmp count]-1]];
            
        }
        NSLog(@"date = %@,count = %d ",dt,count);
        dt = [dt dateByAddingTimeInterval:oneDay];
        count = 0;
        
    }
    data = dataTemp;
    dates = datesTmp;
    
    
}

- (void)initBarPlot
{
    //Create graph from theme
	graph                               = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	[graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
	self.hostedGraph = graph;
    graph.plotAreaFrame.masksToBorder   = NO;
    graph.paddingLeft                   = 0.0f;
    graph.paddingTop                    = 0.0f;
	graph.paddingRight                  = 0.0f;
	graph.paddingBottom                 = 0.0f;
    //self.allowPinchScaling = YES;
    //self.userInteractionEnabled = YES;
    
    CPTMutableLineStyle *borderLineStyle    = [CPTMutableLineStyle lineStyle];
	borderLineStyle.lineColor               = [CPTColor whiteColor];
	borderLineStyle.lineWidth               = 2.0f;
	graph.plotAreaFrame.borderLineStyle     = borderLineStyle;
	graph.plotAreaFrame.paddingTop          = 10.0;
	graph.plotAreaFrame.paddingRight        = 10.0;
	graph.plotAreaFrame.paddingBottom       = 80.0;
	graph.plotAreaFrame.paddingLeft         = 70.0;
    
	//Add plot space
	CPTXYPlotSpace *plotSpace       = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.delegate              = self;
	plotSpace.yRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                                                   length:CPTDecimalFromInt(10 * sets.count)];
	plotSpace.xRange                = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(-1)
                                                                   length:CPTDecimalFromInt(8)];
    
    //Grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth            = 0.75;
	majorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth            = 0.25;
	minorGridLineStyle.lineColor            = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    //Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //X axis
    CPTXYAxis *x                    = axisSet.xAxis;
    x.orthogonalCoordinateDecimal   = CPTDecimalFromInt(0);
	x.majorIntervalLength           = CPTDecimalFromInt(1);
	x.minorTicksPerInterval         = 0;
    x.labelingPolicy                = CPTAxisLabelingPolicyNone;
    x.majorGridLineStyle            = majorGridLineStyle;
    x.axisConstraints               = [CPTConstraints constraintWithLowerOffset:0.0];
    
    //X labels
    int labelLocations = 0;
    NSMutableArray *customXLabels = [NSMutableArray array];
    for (NSString *day in dates) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:day textStyle:x.labelTextStyle];
        newLabel.tickLocation   = [[NSNumber numberWithInt:labelLocations] decimalValue];
        newLabel.offset         = x.labelOffset + x.majorTickLength;
        newLabel.rotation       = M_PI / 4;
        [customXLabels addObject:newLabel];
        labelLocations++;
    }
    x.axisLabels                    = [NSSet setWithArray:customXLabels];
    
    //Y axis
	CPTXYAxis *y            = axisSet.yAxis;
	y.title                 = @"Value";
	y.titleOffset           = 50.0f;
    y.labelingPolicy        = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle    = majorGridLineStyle;
    y.minorGridLineStyle    = minorGridLineStyle;
    y.axisConstraints       = [CPTConstraints constraintWithLowerOffset:0.0];
    
    //Create a bar line style
    CPTMutableLineStyle *barLineStyle   = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineWidth              = 1.0;
    barLineStyle.lineColor              = [CPTColor whiteColor];
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color                = [CPTColor whiteColor];
    
    //Plot
    BOOL firstPlot = YES;
    for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        CPTBarPlot *plot        = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        plot.lineStyle          = barLineStyle;
        CGColorRef color        = ((UIColor *)[sets objectForKey:set]).CGColor;
        plot.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:color]];
        if (firstPlot) {
            plot.barBasesVary   = NO;
            firstPlot           = NO;
        } else {
            plot.barBasesVary   = YES;
        }
        plot.barWidth           = CPTDecimalFromFloat(1.f);
        plot.barsAreHorizontal  = NO;
        plot.dataSource         = self;
        plot.identifier         = set;
        [graph addPlot:plot toPlotSpace:plotSpace];
    }
}
-(void)createDatePlot:(NSArray *)objects withMinDate:(NSDate *)minDate withMaxDate:(NSDate *)maxdate
{
    isDatePlot = YES;
    [self generateDataWithTime:minDate :maxdate :objects];
    [self initDatePlot:minDate];
    //[self generateData];
    //[self generateLayout];
}

-(void)createBarPlot:(NSArray *)objects withMinDate:(NSDate *)minDate withMaxDate:(NSDate *)maxdate
{
    isDatePlot = NO;
    [self generateDataWithoutTime:minDate :maxdate :objects];
    [self initBarPlot];
}

-(void)generateDataWithTime:(NSDate*) minDate : (NSDate*)maxDate :(NSArray*)objects
{
    HMOSQInfo *inf;
    NSDate *dt = minDate;
    int count =0;
    NSTimeInterval oneDay = 60*60*24;
    
    NSTimeInterval secondsBetween = [maxDate timeIntervalSinceDate:minDate];
    
    int numberOfDays = secondsBetween / oneDay+1;
    NSMutableArray *newData = [NSMutableArray array];
    for (int i=0; i<numberOfDays; i++)
    {
        for (NSManagedObject *object in objects)
        {
            inf = object;
            if (([self getDay:dt] == [self getDay:inf.date])&&
                ([self getMonth:dt] == [self getMonth:inf.date]))
            {
                count+=[inf.number intValue];
            }
        }
        [newData addObject:
         @{ @(CPTScatterPlotFieldX): @(oneDay*i),
            @(CPTScatterPlotFieldY): [NSNumber numberWithInt:count] }
         ];
        NSLog(@"date = %@,count = %d ",dt,count);
        dt = [dt dateByAddingTimeInterval:oneDay];
        count = 0;
        
    }
    dates = newData;
}

-(void)initDatePlot:(NSDate*) minDate
{
    isDatePlot = YES;
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    self.hostedGraph = graph;
    //self.allowPinchScaling = YES;
    //_plotView.hostedGraph = graph;
    //_plotView.allowPinchScaling = YES;
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    NSTimeInterval xLow       = -oneDay;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xLow) length:CPTDecimalFromDouble(oneDay * 7.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(10.0)];
    plotSpace.allowsUserInteraction = YES;
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.majorIntervalLength         = CPTDecimalFromFloat(oneDay);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    x.minorTicksPerInterval       = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM";
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = minDate;
    x.labelFormatter            = timeFormatter;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength         = CPTDecimalFromDouble(1);
    y.minorTicksPerInterval       = 10;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(oneDay);
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Date Plot";
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 1.0;
    lineStyle.lineColor              = [CPTColor greenColor];
    lineStyle.lineCap = kCGLineCapSquare;
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    //[self generateDateWithTime];
}


-(NSInteger)getDay:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date];
    NSInteger day = [components day];
    return day;
}

-(NSInteger)getMonth:(NSDate*)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:date];
    NSInteger month = [components month];
    return month;
}
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return dates.count;
}

#pragma mark - CPTPlotDataSource methods

- (double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if (isDatePlot)
    {
        return [dates[index][@(fieldEnum)] intValue];
    }
    else
    {
        double num = NAN;
        
        //X Value
        if (fieldEnum == 0)
        {
            num = index;
        }
        
        else
        {
            double offset = 0;
            if (((CPTBarPlot *)plot).barBasesVary) {
                for (NSString *set in [[sets allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)])
                {
                    if ([plot.identifier isEqual:set])
                    {
                        break;
                    }
                    offset += [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:set] doubleValue];
                }
            }
            
            //Y Value
            if (fieldEnum == 1)
            {
                num = [[[data objectForKey:[dates objectAtIndex:index]] objectForKey:plot.identifier] doubleValue] + offset;
            }
            else
            {
                num = offset;
            }
        }
        return num;
    }
}

@end
