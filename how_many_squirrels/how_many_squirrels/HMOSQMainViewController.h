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

@interface HMOSQMainViewController : UIViewController
{
    UITabBarController* tabBar;
}

- (IBAction) SettingClick : (id)sender;
- (IBAction) plotClick : (id)sender;
- (IBAction) enterClick : (id)sender;

-(id)initWithTabBar:(UITabBarController*) tab;

@end
