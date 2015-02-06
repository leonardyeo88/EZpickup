//
//  CurrentLocationMapViewController.h
//  EZpickup
//
//  Created by Leonard on 11/5/14.
//  Copyright (c) 2014 leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AddPickuplinesViewController.h"

@interface CurrentLocationMapViewController : UIViewController <UINavigationControllerDelegate,CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, AddPickuplinesViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *json;
@property (nonatomic, strong) NSMutableArray *pickuplinesArray;
@property (weak, nonatomic) IBOutlet UITableView *pickuplinesTable;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIImageView *imageCountDown;
- (IBAction)getMyLocation:(id)sender;
-(void) retrieveData;
@end
