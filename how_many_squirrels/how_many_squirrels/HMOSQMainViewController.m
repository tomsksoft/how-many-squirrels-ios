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

#import "HMOSQMainViewController.h"
#import "HMOSQOptionViewController.h"
@interface HMOSQMainViewController ()

@end

@implementation HMOSQMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Главная" image:[UIImage imageNamed:@"iconm.png"] tag:0];
        
        
    }
    return self;
}

-(id)initWithTabBar:(UITabBarController *)tab
{
    self = [super init];
    if (self)
    {
        tabBar = tab;
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Главная" image:[UIImage imageNamed:@"iconm.png"] tag:0];
        
    }
    return self;

}

-(IBAction)SettingClick:(id)sender
{
    HMOSQOptionViewController* options = [[HMOSQOptionViewController alloc]init ];
    [self presentViewController:options animated:YES completion:nil];
    
}

-(IBAction)enterClick:(id)sender
{
    [tabBar setSelectedIndex:1];
}

-(IBAction)plotClick:(id)sender
{
    [tabBar setSelectedIndex:2];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
