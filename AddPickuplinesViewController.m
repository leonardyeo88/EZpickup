//
//  AddPickuplinesViewController.m
//  EZpickup
//
//  Created by Leonard Yeo on 13/5/14.
//  Copyright (c) 2014 leonard. All rights reserved.
//

#import "AddPickuplinesViewController.h"

@interface AddPickuplinesViewController ()

@end

@implementation AddPickuplinesViewController
@synthesize pickuplinesTextField, pulGender, pulCountry, pulPostalCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelButton:(id)sender {
    
    [self.delegate AddPickuplinesViewControllerDidCancel:self];
}

- (IBAction)doneButton:(id)sender {
    
    NSInteger success = 0;
    //NSInteger unsuccessful = 0;
    
    //pulGender = @"1";
    
    @try {
        
        NSString *post =[[NSString alloc] initWithFormat:@"postalcode=%@&country=%@&gender=%@&text=%@", pulPostalCode,pulCountry, pulGender, [self.pickuplinesTextField text]];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://vueartiste.com/ezpickup/addPickuplines.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        
        if ([response statusCode] >= 200 && [response statusCode] < 300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization
                                      JSONObjectWithData:urlData
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
            
            success = [jsonData[@"success"] integerValue];
            //unsuccessful = [jsonData[@"unsuccessfull"] integerValue];
            
            NSLog(@"Success: %ld",(long)success);
            
            if(success == 1)
            {
                NSLog(@"Pick up line added!!!");
                //[self alertStatus:@"":@"Volunteered!!!" :0];
            } else if (success == 0){
                
                //NSString *error_msg = (NSString *) jsonData[@"error"];
                //[self alertStatus:@"":@"Volunteered already!" :0];
                NSLog(@"Error: %@", error);
            }
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            //[self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            
            NSLog(@"Error: %@", error);
        }
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        //[self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }

    
    [self.delegate AddPickuplinesViewControllerDidDone:self];
}
@end
