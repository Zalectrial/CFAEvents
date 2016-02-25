//
//  CFAEventsIncidentDetailViewController.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "CFAEventsIncidentDetailViewController.h"
#import "OAStackView.h"
#import "NSLayoutConstraint+Extensions.h"
#import <MapKit/MapKit.h>

@interface CFAEventsIncidentDetailViewController ()

@property (nonatomic, strong) UIScrollView *detailScrollView;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UISegmentedControl *detailSegmentedControl;

@end

@implementation CFAEventsIncidentDetailViewController

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
    
    self.mapView.alpha = 0;
    
    //Scroll View
    self.detailScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.detailScrollView];
    
    //Status Icon Image
    UIImage *statusImage = [[UIImage imageNamed:@"flame_large"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *statusImageView = [[UIImageView alloc] initWithImage:statusImage];
    [self.detailScrollView addSubview:statusImageView];
    
    //Type Title Label
    UILabel *typeTitleLabel = [[UILabel alloc] init];
    typeTitleLabel.text = @"Placeholder";
    typeTitleLabel.font = [UIFont titleFont];
    [self.detailScrollView addSubview:typeTitleLabel];
    
    //Status Labels
    UILabel *statusTitleLabel = [[UILabel alloc] init];
    statusTitleLabel.text = @"Incident Status";
    statusTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *statusTextLabel = [[UILabel alloc] init];
    statusTextLabel.text = @"Placeholder";
    statusTextLabel.textColor = [UIColor textLabelColor];
    statusTextLabel.font = [UIFont textLabelFont];
    
    //Location Labels
    UILabel *locationTitleLabel = [[UILabel alloc] init];
    locationTitleLabel.text = @"Location";
    locationTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *locationTextLabel = [[UILabel alloc] init];
    locationTextLabel.text = @"Placeholder";
    locationTextLabel.textColor = [UIColor textLabelColor];
    locationTextLabel.font = [UIFont textLabelFont];
    
    //Size Labels
    UILabel *sizeTitleLabel = [[UILabel alloc] init];
    sizeTitleLabel.text = @"Size";
    sizeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *sizeTextLabel = [[UILabel alloc] init];
    sizeTextLabel.text = @"Placeholder";
    sizeTextLabel.textColor = [UIColor textLabelColor];
    sizeTextLabel.font = [UIFont textLabelFont];
    
    //Start Time Labels
    UILabel *startTimeTitleLabel = [[UILabel alloc] init];
    startTimeTitleLabel.text = @"Start Time";
    startTimeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *startTimeTextLabel = [[UILabel alloc] init];
    startTimeTextLabel.text = @"Placeholder";
    startTimeTextLabel.textColor = [UIColor textLabelColor];
    startTimeTextLabel.font = [UIFont textLabelFont];
    
    //Owner Labels
    UILabel *ownerTitleLabel = [[UILabel alloc] init];
    ownerTitleLabel.text = @"Owner";
    ownerTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *ownerTextLabel = [[UILabel alloc] init];
    ownerTextLabel.text = @"Placeholder";
    ownerTextLabel.textColor = [UIColor textLabelColor];
    ownerTextLabel.font = [UIFont textLabelFont];
    
    //Resource Count Labels
    UILabel *resourceCountTitleLabel = [[UILabel alloc] init];
    resourceCountTitleLabel.text = @"Resource #";
    resourceCountTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *resourceCountTextLabel = [[UILabel alloc] init];
    resourceCountTextLabel.text = @"Placeholder";
    resourceCountTextLabel.textColor = [UIColor textLabelColor];
    resourceCountTextLabel.font = [UIFont textLabelFont];
    
    //Latitude Labels
    UILabel *latitudeTitleLabel = [[UILabel alloc] init];
    latitudeTitleLabel.text = @"Latitude";
    latitudeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *latitudeTextLabel = [[UILabel alloc] init];
    latitudeTextLabel.text = @"Placeholder";
    latitudeTextLabel.textColor = [UIColor textLabelColor];
    latitudeTextLabel.font = [UIFont textLabelFont];
    
    //Longitude Labels
    UILabel *longitudeTitleLabel = [[UILabel alloc] init];
    longitudeTitleLabel.text = @"Longitude";
    longitudeTitleLabel.font = [UIFont titleLabelFont];
    
    UILabel *longitudeTextLabel = [[UILabel alloc] init];
    longitudeTextLabel.text = @"Placeholder";
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
                                              
                                              NSLayoutConstraintMakeInset(self.detailScrollView, ALTop, 60),
                                              NSLayoutConstraintMakeEqual(self.detailScrollView, ALBottom, self.view),
                                              NSLayoutConstraintMakeEqual(self.detailScrollView, ALLeft, self.view),
                                              NSLayoutConstraintMakeEqual(self.detailScrollView, ALRight, self.view),
                                              
                                              NSLayoutConstraintMakeAll(statusImageView, ALLeft, ALEqual, self.detailScrollView, ALLeft, 1.0, 30, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeAll(statusImageView, ALTop, ALEqual, self.detailScrollView, ALTop, 1.0, 10, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeAll(statusImageView, ALHeight, ALEqual, nil, ALHeight, 1.0, 50, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeAll(statusImageView, ALWidth, ALEqual, nil, ALWidth, 1.0, 50, UILayoutPriorityRequired),
                                              
                                              NSLayoutConstraintMakeEqual(typeTitleLabel, ALCenterY, statusImageView),
                                              NSLayoutConstraintMakeHSpace(statusImageView, typeTitleLabel, 5),
                                              
                                              NSLayoutConstraintMakeEqual(titleLabelsStackView, ALLeft, self.detailScrollView),
                                              NSLayoutConstraintMakeAll(titleLabelsStackView, ALRight, ALEqual, self.detailScrollView, ALCenterX, 1.0, -5, UILayoutPriorityRequired),
                                              NSLayoutConstraintMakeVSpace(statusImageView, titleLabelsStackView, 20),
                                              
                                              NSLayoutConstraintMakeEqual(textLabelsStackView, ALRight, self.detailScrollView),
                                              NSLayoutConstraintMakeEqual(textLabelsStackView, ALTop, titleLabelsStackView),
                                              
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
}

- (void)setupMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
}

- (void)initialiseSegmentedControl
{
    [self.detailSegmentedControl setEnabled:YES forSegmentAtIndex:0];
}

# pragma mark - Actions

- (void)segmentedControlChange
{
    if (self.detailSegmentedControl.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.mapView.alpha = 0;
            self.detailScrollView.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            self.mapView.alpha = 1;
            self.detailScrollView.alpha = 0;
        }];
    }
}

@end
