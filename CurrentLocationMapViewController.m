//
//  CurrentLocationMapViewController.m
//  EZpickup
//
//  Created by Leonard on 11/5/14.
//  Copyright (c) 2014 leonard. All rights reserved.
//

#import "CurrentLocationMapViewController.h"
#import <MapKit/MapKit.h>
#import "Pickuplines.h"
#import "PickuplinesCell.h"

#define JSON_GETPICKUPLINES_URL @"http://vueartiste.com/ezpickup/getPickuplines.php"

@interface CurrentLocationMapViewController ()

@end

@implementation CurrentLocationMapViewController
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *getPlacePostalCode;
    NSString *getPlaceTitle;
    NSString *getPlaceCountry;
    UIRefreshControl *refreshControl;
    
    
}

@synthesize json, pickuplinesArray, pickuplinesTable, imageCountDown;

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
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.pickuplinesTable.delegate = self;
    
    //[self.pickuplinesTable reloadData];
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    //[self retrieveData];
    
    //[self updatecurrentLocation];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    //self.refreshControl = refreshControl;
    [self.pickuplinesTable addSubview:refreshControl];
    
}

-(void) handleRefresh
{
    //[self.pickuplinesTable reloadData];
    [self updatecurrentLocation];
    [refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section
    return pickuplinesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];*/
    
    // Configure the cell...
    
    static NSString *CellIdentifier = @"PickuplinesCell";
    
    PickuplinesCell *cell = (PickuplinesCell *)[self.pickuplinesTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[PickuplinesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //retrieve current eventObject for use with this indexpath.row
    //Event *currentEvent = [eventsArray objectAtIndex:indexPath.row];
    //Event *currentEvent = [[Event alloc]init];
    
    Pickuplines *currentPickuplines = nil;
    
    currentPickuplines = [pickuplinesArray objectAtIndex:indexPath.row];
    
    
    cell.pickuplinesTextLabel.text = currentPickuplines.pickuplinesText;
    
    /*cell.imageLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.imageLabel.layer.shadowOffset = CGSizeMake(1, 1);
    cell.imageLabel.layer.shadowRadius = 2.0f;
    cell.imageLabel.layer.shadowOpacity = 0.80f;
    cell.imageLabel.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cell.imageLabel.layer.bounds] CGPath];
    cell.imageLabel.clipsToBounds = NO;
    cell.imageLabel.layer.shouldRasterize = YES;*/
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

-(void) retrieveData
{
    //NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    //NSString *userID = [fetchDefaults objectForKey:@"userid"];
    
    
    NSString *post =[[NSString alloc] initWithFormat:@"postalcode=%@&country=%@", getPlacePostalCode, getPlaceCountry];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:JSON_GETPICKUPLINES_URL];
    
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
    //NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    
    
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        //NSData *data = [NSData dataWithContentsOfURL:url];
        json = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:nil];
        
        //set up events array
        pickuplinesArray = [[NSMutableArray alloc] init];
        
        //NSLog(@"did happen");
        NSLog(@"%lu", (unsigned long)json.count);
        
        for (int i=0; i<json.count; i++) {
            //create event object
            NSString *pickuplinesText = [[json objectAtIndex:i] objectForKey:@"pickuplines_text"];
            //NSString *eventHours = [[json objectAtIndex:i] objectForKey:@"event_hours"];
            
            NSLog(@"pick up lines: %@",pickuplinesText);
            
            Pickuplines *myPickuplines = [[Pickuplines alloc] initWithPickuplinesText:pickuplinesText];
            
            //add event object to event array
            [pickuplinesArray addObject:myPickuplines];
            
        }
        self.pickuplinesArray = pickuplinesArray;
        [self.pickuplinesTable reloadData];
        
    }else {
        //if (error) NSLog(@"Error: %@", error);
        //[self alertStatus:@"Connection Failed" :@"" :0];
    }
    
}

-(void) placePostalCode:(NSString *)placePostalCode andPlaceTitle:(NSString *)placeTitle andPlaceCountry:(NSString *)placeCountry
{
    //NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    //NSString *userID = [fetchDefaults objectForKey:@"userid"];
    
    
    NSString *post =[[NSString alloc] initWithFormat:@"postalcode=%@&country=%@", placePostalCode, placeCountry];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:JSON_GETPICKUPLINES_URL];
    
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
    //NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    
    
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        //NSData *data = [NSData dataWithContentsOfURL:url];
        json = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:nil];
        
        //set up events array
        pickuplinesArray = [[NSMutableArray alloc] init];
        
        //NSLog(@"did happen");
        NSLog(@"%lu", (unsigned long)json.count);
        
        for (int i=0; i<json.count; i++) {
            //create event object
            NSString *pickuplinesText = [[json objectAtIndex:i] objectForKey:@"pickuplines_text"];
            //NSString *eventHours = [[json objectAtIndex:i] objectForKey:@"event_hours"];
            
            NSLog(@"pick up lines: %@",pickuplinesText);
            
            Pickuplines *myPickuplines = [[Pickuplines alloc] initWithPickuplinesText:pickuplinesText];
            
            //add event object to event array
            [pickuplinesArray addObject:myPickuplines];
            
        }
        self.pickuplinesArray = pickuplinesArray;
        [self.pickuplinesTable reloadData];
        
    }else {
        //if (error) NSLog(@"Error: %@", error);
        //[self alertStatus:@"Connection Failed" :@"" :0];
    }
    
}

- (void) updatecurrentLocation
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"failed to get location");
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error){
        
        if(error == nil && [placemarks count] > 0){
            placemark = [placemarks objectAtIndex:0];
            
            getPlacePostalCode = [NSString stringWithFormat:@"%@", placemark.postalCode];
            getPlaceTitle = [NSString stringWithFormat:@"%@", placemark.name];
            getPlaceCountry = [NSString stringWithFormat:@"%@", placemark.country];
            
            [self foundLocation:newLocation andPlaceTitle:getPlaceTitle andPlacePostalCode:getPlacePostalCode andPlaceCountry:getPlaceCountry];
            
        }
        
    }];
    
}

- (void)foundLocation:(CLLocation *)userLocation andPlaceTitle:(NSString *) placeTitle andPlacePostalCode:(NSString *) placePostalCode andPlaceCountry:(NSString *) placeCountry
{
    //CLLocationCoordinate2D coord = [userLocation coordinate];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
    //add an annotation
    
    point.coordinate = userLocation.coordinate;
    point.title = [NSString stringWithFormat:@"%@", placeTitle];
    point.subtitle = [NSString stringWithFormat:@"%@", placePostalCode];
    
    [self.mapView addAnnotation:point];
    [locationManager stopUpdatingLocation];
    [self placePostalCode:placePostalCode andPlaceTitle:placeTitle andPlaceCountry:placeCountry];
    
    
    
}

/*- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    //CLLocation *currentLocation = userLocation.location;
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    
            //add an annotation
            
            point.coordinate = userLocation.coordinate;
            point.title = [NSString stringWithFormat:@"%@", placetitle];
            point.subtitle = [NSString stringWithFormat:@"%@", address];
            
            [self.mapView addAnnotation:point];

    [locationManager stopUpdatingLocation];
    
    
}*/

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

- (IBAction)getMyLocation:(id)sender {
    
    [self updatecurrentLocation];
}

- (void)AddPickuplinesViewControllerDidCancel:(AddPickuplinesViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)AddPickuplinesViewControllerDidDone:(AddPickuplinesViewController *)controller
{
    [self updatecurrentLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"moveToAddPickuplinesViewController"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        AddPickuplinesViewController *addPickuplinesViewController = [navigationController viewControllers][0];
        addPickuplinesViewController.delegate = self;
        
        addPickuplinesViewController.pulPostalCode = getPlacePostalCode;
        addPickuplinesViewController.pulCountry = getPlaceCountry;
        addPickuplinesViewController.pulGender = [NSString stringWithFormat:@"%@", @"Hunk"];
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self attachExplosionAnimation];
    
}

- (UIImageView *) explosion{
    //Position the explosion image view somewhere in the middle of your current view. In my case, I want it to take the whole view.Try to make the png to mach the view size, don't stretch it
    
    CGRect aRect = CGRectMake(70, 198, 200, 200);
    imageCountDown = [[UIImageView alloc]initWithFrame:aRect];
    
    //Add images which will be used for the animation using an array. Here I have created an array on the fly
    imageCountDown.animationImages =  @[[UIImage imageNamed:@"3.png"], [UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"go.png"]];
    
    //Set the duration of the entire animation
    imageCountDown.animationDuration = 1.5;
    
    //Set the repeat count. If you don't set that value, by default will be a loop (infinite)
    imageCountDown.animationRepeatCount = 1;
    
    //Start the animationrepeatcount
    [imageCountDown startAnimating];
    
    return imageCountDown;
}

//Call this method for start explosion animation
- (void) attachExplosionAnimation {
    [self.view addSubview:self.explosion];
}

@end
