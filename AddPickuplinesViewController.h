//
//  AddPickuplinesViewController.h
//  EZpickup
//
//  Created by Leonard Yeo on 13/5/14.
//  Copyright (c) 2014 leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddPickuplinesViewController;

@protocol AddPickuplinesViewControllerDelegate <NSObject>
- (void)AddPickuplinesViewControllerDidCancel:(AddPickuplinesViewController *)controller;
- (void)AddPickuplinesViewControllerDidDone:(AddPickuplinesViewController *)controller;
@end

@interface AddPickuplinesViewController : UIViewController

@property (strong, nonatomic) NSString *pulPostalCode;
@property (strong, nonatomic) NSString *pulCountry;
@property (strong, nonatomic) NSString *pulGender;

@property (nonatomic, weak) id <AddPickuplinesViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *pickuplinesTextField;

- (IBAction)cancelButton:(id)sender;
- (IBAction)doneButton:(id)sender;

@end
