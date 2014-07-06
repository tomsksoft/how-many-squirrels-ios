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
    id delegate = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    pref = [NSUserDefaults standardUserDefaults];
    if ([pref valueForKey:@"name"] == nil  && [pref valueForKey:@"type"] == nil)
    {
        [pref setValue:@"Белки" forKey:@"name"];
        [pref setValue:@"Целое" forKey:@"type"];
        [pref setValue:@"0" forKey:@"count"];
        [pref synchronize];
        NSFetchRequest *paramRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *paramEntity = [NSEntityDescription entityForName:@"Params"
                                                       inManagedObjectContext:self.managedObjectContext];
        [paramRequest setEntity:paramEntity];
        NSFetchRequest *infoRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *infoEntity = [NSEntityDescription entityForName:@"Info"
                                                      inManagedObjectContext:self.managedObjectContext];
        [infoRequest setEntity:infoEntity];
        HMOSQParametr * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Params"
                                                                     inManagedObjectContext:self.managedObjectContext];
        newEntry.name = @"Белки";
        newEntry.type = @"Целое";
        newEntry.def = @"1/-1";
        NSMutableSet * set = [[NSMutableSet alloc] init];
        for (HMOSQInfo *o in [self.managedObjectContext executeFetchRequest:infoRequest error:nil])
        {
            o.param = newEntry;
            [set addObject:o];
        }
        newEntry.value = [set mutableCopy];
        [_managedObjectContext save:nil];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
