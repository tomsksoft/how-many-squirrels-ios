//
//  HMOSQEditViewController.h
//  how_many_squirrels
//
//  Created by Student1 on 24/06/14.
//  Copyright (c) 2014 TomskSoft. All rights reserved.
//

@protocol HMOSQEditViewControllerDelegate;
#import <UIKit/UIKit.h>

@interface HMOSQEditViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSManagedObject *manageObject;
@property (nonatomic, weak) id <HMOSQEditViewControllerDelegate> delegate;
@property (nonatomic, retain)IBOutlet UIDatePicker *datePicker;
@property (strong,nonatomic)IBOutlet UITextView * text;
@end

@protocol HMOSQEditViewControllerDelegate
- (void)addViewController:(HMOSQEditViewController *)controller didFinishWithSave:(BOOL)save;
@end
