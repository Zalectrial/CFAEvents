//
//  CFAEventsIncidentDetailViewController.h
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Incident.h"

/**
 *  The detail view controller of the application.
 *  Displays detailed information about an incident.
 *  The user can toggle between the details or a map view showing the location of the incident.
 */
@interface CFAEventsIncidentDetailViewController : UIViewController

/**
 *  Initialises the view controller with the selected incident
 *
 *  @param selectedIncident The incident to initialise with
 *
 *  @return an instance of the view controller
 */
- (instancetype)initWithIncident:(Incident *)selectedIncident;

@end
