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
#import "HMOSQPlotViewController.h"

@interface HMOSQPlotViewController ()

@end

@implementation HMOSQPlotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"График" image:[UIImage imageNamed:@""] tag:0];
        id delegate = [[UIApplication sharedApplication]delegate];
        self.managedObjectContext = [delegate managedObjectContext];
    }
    return self;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    return plotData[index][@(fieldEnum)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dateActionSheet = [[UIActionSheet alloc] initWithTitle:@"DateTime"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:nil];
    
    
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem
                                :UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClick:)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datePickerCancelClick:)];
    [barItems addObject:cancelBtn];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [pickerDateToolbar setItems:barItems animated:YES];
    [self.dateActionSheet addSubview:pickerDateToolbar];
    [self.dateActionSheet addSubview:self.datePicker];
    [_swch addTarget:self action:@selector(stateChange) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minTapAction)];
    [recognizer setNumberOfTapsRequired:1];
    [_minLabel addGestureRecognizer:recognizer];
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maxTapAction)];
    [recognizer setNumberOfTapsRequired:1];
    [_maxLabel addGestureRecognizer:recognizer2];
    _minLabel.text = @"22.06.14";
    _maxLabel.text = @"27.06.14";
    NSString *dateStr = @"22.06.2014. 02:00:00";
    NSString *dateStr2 = @"27.06.2014. 02:00:00";
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy. hh:mm:ss";
    minDate = [formater dateFromString:dateStr];
    maxDate = [formater dateFromString:dateStr2];
    [self initGraph];
    // Do any additional setup after loading the view from its nib.
}

-(void)minTapAction
{
    isMinDateClick = YES;
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy";
    _datePicker.date = [formater dateFromString:_minLabel.text];
    [self.dateActionSheet showInView:self.view];
    [self.dateActionSheet setBounds:CGRectMake(0,0,320, 464)];
}

-(void)maxTapAction
{
    isMinDateClick = NO;
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy";
    _datePicker.date = [formater dateFromString:_maxLabel.text];
    [self.dateActionSheet showInView:self.view];
    [self.dateActionSheet setBounds:CGRectMake(0,0,320, 464)];
}

-(void)datePickerDoneClick:(id)sender
{
    NSDate *oldDate = _datePicker.date;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:oldDate];
    comps.hour   = 2;
    comps.minute = 0;
    comps.second = 0;
    NSDate *newDate = [calendar dateFromComponents:comps];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"dd.MM.yy";
    if(isMinDateClick)
    {
        minDate = newDate;
        _minLabel.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:newDate]];
    }
    
    else
    {
        maxDate = newDate;
        _maxLabel.text = [[NSString alloc] initWithFormat:@"%@",[formater stringFromDate:newDate]];
    }
    [self initGraph];
    [self.dateActionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

-(void)datePickerCancelClick:(id)sender
{
    [self.dateActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)initGraph
{
    [self.fetchedResultsController performFetch:nil];
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:theme];
    _plotView.hostedGraph = graph;
    _plotView.allowPinchScaling = YES;
    
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
    [self generateDate];
}

-(void)generateDate
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
        for (NSManagedObject *object in [_fetchedResultsController fetchedObjects])
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
        plotData = newData;
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
    return plotData.count;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self initGraph];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Info" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}
@end
