//
//  CFAEventsIncidentDetailViewController.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "CFAEventsIncidentDetailViewController.h"
#import "AppearanceUtility.h"
#import "OAStackView.h"
#import "NSLayoutConstraint+Extensions.h"
#import <MapKit/MapKit.h>

static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface CFAEventsIncidentDetailViewController () <MKMapViewDelegate>

@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UISegmentedControl *detailSegmentedControl;

@property (nonatomic, strong) Incident *incident;
@property (nonatomic) IncidentStatus status;
@end

@implementation CFAEventsIncidentDetailViewController

- (instancetype)initWithIncident:(Incident *)selectedIncident
{
    self = [super init];
    if (self)
    {
        self.incident = selectedIncident;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Details";
    
    [self setupNavigation];
    [self setupMapView];
    [self setupScreen];
    [self initialiseSegmentedControl];
}

- (void)setupScreen
{
    self.view.backgroundColor = [UIColor backgroundColor];
    
    if (!self.incident)
    {
        self.incident = [Incident MR_findFirst];
    }

    //Scroll View
    self.detailScrollView = [[UIScrollView alloc] init];
    self.detailScrollView.contentSize = CGSizeMake(1000, 1000);
    self.detailScrollView.scrollEnabled = YES;
    self.detailScrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.detailScrollView];
    
    //Status Icon Image
    UIImage *statusImage = [[UIImage imageNamed:@"flame_large"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *statusImageView = [[UIImageView alloc] initWithImage:statusImage];
    
    self.status = [self.incident incidentStatusFromString:self.incident.status];
    switch (self.status)
    {
        case IncidentStatusSafe:
            statusImageView.tintColor = [UIColor safeColor];
            break;
        case IncidentStatusControlled:
            statusImageView.tintColor = [UIColor controlledColor];
            break;
        case IncidentStatusContained:
            statusImageView.tintColor = [UIColor containedColor];
            break;
        case IncidentStatusGoing:
            statusImageView.tintColor = [UIColor goingColor];
            break;
        default:
            statusImageView.tintColor = [UIColor defaultColor];
            break;
    }
    
    [self.detailScrollView addSubview:statusImageView];
    
    //Type Title Label
    UILabel *typeTitleLabel = [[UILabel alloc] init];
    typeTitleLabel.text = self.incident.type;
    typeTitleLabel.font = [UIFont titleFont];
    [self.detailScrollView addSubview:typeTitleLabel];
    
    //Status Labels
    UILabel *statusTitleLabel = [[UILabel alloc] init];
    statusTitleLabel.text = @"Incident Status";
    statusTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *statusTextLabel = [[UILabel alloc] init];
    statusTextLabel.text = self.incident.status;
    statusTextLabel.textColor = [UIColor textLabelColor];
    statusTextLabel.font = [UIFont textLabelFont];
    
    //Location Labels
    UILabel *locationTitleLabel = [[UILabel alloc] init];
    locationTitleLabel.text = @"Location";
    locationTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *locationTextLabel = [[UILabel alloc] init];
    locationTextLabel.text = self.incident.location;
    locationTextLabel.textColor = [UIColor textLabelColor];
    locationTextLabel.font = [UIFont textLabelFont];
    
    //Size Labels
    UILabel *sizeTitleLabel = [[UILabel alloc] init];
    sizeTitleLabel.text = @"Size";
    sizeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *sizeTextLabel = [[UILabel alloc] init];
    sizeTextLabel.text = self.incident.size;
    sizeTextLabel.textColor = [UIColor textLabelColor];
    sizeTextLabel.font = [UIFont textLabelFont];
    
    //Start Time Labels
    UILabel *startTimeTitleLabel = [[UILabel alloc] init];
    startTimeTitleLabel.text = @"Start Time";
    startTimeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *startTimeTextLabel = [[UILabel alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    startTimeTextLabel.text = [formatter stringFromDate:self.incident.originDate];
    startTimeTextLabel.textColor = [UIColor textLabelColor];
    startTimeTextLabel.font = [UIFont textLabelFont];
    
    //Owner Labels
    UILabel *ownerTitleLabel = [[UILabel alloc] init];
    ownerTitleLabel.text = @"Owner";
    ownerTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *ownerTextLabel = [[UILabel alloc] init];
    ownerTextLabel.text = self.incident.owner;
    ownerTextLabel.textColor = [UIColor textLabelColor];
    ownerTextLabel.font = [UIFont textLabelFont];
    
    //Resource Count Labels
    UILabel *resourceCountTitleLabel = [[UILabel alloc] init];
    resourceCountTitleLabel.text = @"Resource #";
    resourceCountTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *resourceCountTextLabel = [[UILabel alloc] init];
    resourceCountTextLabel.text = [self.incident.resourceCount stringValue];
    resourceCountTextLabel.textColor = [UIColor textLabelColor];
    resourceCountTextLabel.font = [UIFont textLabelFont];
    
    //Latitude Labels
    UILabel *latitudeTitleLabel = [[UILabel alloc] init];
    latitudeTitleLabel.text = @"Latitude";
    latitudeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *latitudeTextLabel = [[UILabel alloc] init];
    latitudeTextLabel.text = [self.incident.latitude stringValue];
    latitudeTextLabel.textColor = [UIColor textLabelColor];
    latitudeTextLabel.font = [UIFont textLabelFont];
    
    //Longitude Labels
    UILabel *longitudeTitleLabel = [[UILabel alloc] init];
    longitudeTitleLabel.text = @"Longitude";
    longitudeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *longitudeTextLabel = [[UILabel alloc] init];
    longitudeTextLabel.text = [self.incident.longitude stringValue];
    longitudeTextLabel.textColor = [UIColor textLabelColor];
    longitudeTextLabel.font = [UIFont textLabelFont];
    
    //Title Labels Stack View
    OAStackView *titleLabelsStackView = [[OAStackView alloc] initWithArrangedSubviews:@[
                                                                                        
                                                                                        statusTitleLabel,
                                                                                        locationTitleLabel,
                                                                                        sizeTitleLabel,
                                                                                        startTimeTitleLabel,
                                                                                        ownerTitleLabel,
                                                                                        resourceCountTitleLabel,
                                                                                        latitudeTitleLabel,
                                                                                        longitudeTitleLabel,
                                                                                    
                                                                                        ]];
    
    titleLabelsStackView.axis = UILayoutConstraintAxisVertical;
    titleLabelsStackView.alignment = OAStackViewAlignmentTrailing;
    titleLabelsStackView.distribution = OAStackViewDistributionFill;
    titleLabelsStackView.spacing = 12;
    
    [self.detailScrollView addSubview:titleLabelsStackView];
    
    //Text Labels Stack View
    OAStackView *textLabelsStackView = [[OAStackView alloc] initWithArrangedSubviews:@[
                                                                                        
                                                                                        statusTextLabel,
                                                                                        locationTextLabel,
                                                                                        sizeTextLabel,
                                                                                        startTimeTextLabel,
                                                                                        ownerTextLabel,
                                                                                        resourceCountTextLabel,
                                                                                        latitudeTextLabel,
                                                                                        longitudeTextLabel,
                                                                                        
                                                                                        ]];
    
    textLabelsStackView.axis = UILayoutConstraintAxisVertical;
    textLabelsStackView.alignment = OAStackViewAlignmentLeading;
    textLabelsStackView.distribution = OAStackViewDistributionFill;
    textLabelsStackView.spacing = 12;
    
    [self.detailScrollView addSubview:textLabelsStackView];
    
    //Constraints
    [NSLayoutConstraint activateConstraints:@[
                                              
                                              //Scroll View
                                              NSLayoutConstraintMakeInset(self.detailScrollView, ALTop, 60),
                                              NSLayoutConstraintMakeEqual(self.detailScrollView, ALBottom, self.view),
                                              NSLayoutConstraintMakeEqual(self.detailScrollView, ALLeft, self.view),
                                              NSLayoutConstraintMakeEqual(self.detailScrollView, ALRight, self.view),
                                              
                                              //Status Image View
                                              NSLayoutConstraintMakeAll(statusImageView, ALLeft, ALEqual, self.detailScrollView, ALLeft, 1.0, 30, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeAll(statusImageView, ALTop, ALEqual, self.detailScrollView, ALTop, 1.0, 10, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeAll(statusImageView, ALHeight, ALEqual, nil, ALHeight, 1.0, 50, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeAll(statusImageView, ALWidth, ALEqual, nil, ALWidth, 1.0, 50, UILayoutPriorityRequired),
                                              
                                              //Type Title Label
                                              NSLayoutConstraintMakeEqual(typeTitleLabel, ALCenterY, statusImageView),
                                              NSLayoutConstraintMakeHSpace(statusImageView, typeTitleLabel, 5),
                                              
                                              //Title Labels Stack View
                                              NSLayoutConstraintMakeEqual(titleLabelsStackView, ALLeft, self.detailScrollView),
                                              NSLayoutConstraintMakeAll(titleLabelsStackView, ALRight, ALEqual, self.detailScrollView, ALCenterX, 1.0, -5, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeEqual(titleLabelsStackView, ALBottom, self.detailScrollView),
                                              NSLayoutConstraintMakeVSpace(statusImageView, titleLabelsStackView, 20),
                                              
                                              //Text Labels Stack View
                                              NSLayoutConstraintMakeEqual(textLabelsStackView, ALRight, self.detailScrollView),
                                              NSLayoutConstraintMakeEqual(textLabelsStackView, ALTop, titleLabelsStackView),
                                              NSLayoutConstraintMakeEqual(textLabelsStackView, ALBottom, titleLabelsStackView),
                                              NSLayoutConstraintMakeHSpace(titleLabelsStackView, textLabelsStackView, 10),
                                              
                                              ]];
}

- (void)setupNavigation
{
    [AppearanceUtility setupNavigationBar];
    
    //Segmented View
    self.detailSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Detail", @"Map"]];
    self.detailSegmentedControl.tintColor = [UIColor whiteColor];
    [self.detailSegmentedControl addTarget:self
                                    action:@selector(segmentedControlChange)
                          forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.detailSegmentedControl;
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)setupMapView
{
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    self.mapView.alpha = 0;
    
    //Constraints
    [NSLayoutConstraint activateConstraints:@[
                                              
                                              //Map View Constraints
                                              NSLayoutConstraintMakeEqual(self.mapView, ALTop, self.view),
                                              NSLayoutConstraintMakeEqual(self.mapView, ALBottom, self.view),
                                              NSLayoutConstraintMakeEqual(self.mapView, ALRight, self.view),
                                              NSLayoutConstraintMakeEqual(self.mapView, ALLeft, self.view),
                                              
                                              ]];
}

/**
 *  Initialises the segemented control.
 *  On load the view defaults to the details screen.
 */
- (void)initialiseSegmentedControl
{
    [self.detailSegmentedControl setEnabled:YES forSegmentAtIndex:0];
}

# pragma mark - Actions

/**
 *  Handles when the user changes the value of the segmented control
 *  The alpha of the two views are animated based on what the user has selected
 */
- (void)segmentedControlChange
{
    if (self.detailSegmentedControl.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.mapView.alpha = 0;
            self.detailScrollView.alpha = 1;
            
            if (self.incident)
            {
                [self.mapView removeAnnotation:self.incident];
            }
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.mapView.alpha = 1;
            self.detailScrollView.alpha = 0;
            
            if (self.incident)
            {
                [self.mapView showAnnotations:@[self.incident] animated:NO];
            }
        }];
    }
}

# pragma mark - Map View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ReuseIdentifier];
    
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:ReuseIdentifier];
    }
    
    annotationView.canShowCallout = YES;
    
    UIImage *flameIcon = [[UIImage imageNamed:@"flame_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:flameIcon];
    
    switch (self.status)
    {
        case IncidentStatusSafe:
            annotationView.leftCalloutAccessoryView.tintColor = [UIColor safeColor];
            annotationView.image = [flameIcon colorImage:[UIColor safeColor]];
            break;
        case IncidentStatusControlled:
            annotationView.leftCalloutAccessoryView.tintColor = [UIColor controlledColor];
            annotationView.image = [flameIcon colorImage:[UIColor controlledColor]];
            break;
        case IncidentStatusContained:
            annotationView.leftCalloutAccessoryView.tintColor = [UIColor containedColor];
            annotationView.image = [flameIcon colorImage:[UIColor containedColor]];
            break;
        case IncidentStatusGoing:
            annotationView.leftCalloutAccessoryView.tintColor = [UIColor goingColor];
            annotationView.image = [flameIcon colorImage:[UIColor goingColor]];
            break;
        default:
            annotationView.leftCalloutAccessoryView.tintColor = [UIColor defaultColor];
            annotationView.image = [flameIcon colorImage:[UIColor defaultColor]];
            break;
    }
    
    return annotationView;
}

@end
