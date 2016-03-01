//
//  CFAEventsIncidentTableViewController.m
//  CFAEvents
//
//  Created by Robyn Van Deventer on 24/02/2016.
//  Copyright © 2016 Robyn Van Deventer. All rights reserved.
//

#import "CFAEventsIncidentTableViewController.h"
#import "NSLayoutConstraint+Extensions.h"
#import "CFAEventsIncidentDetailViewController.h"
#import "AppearanceUtility.h"
#import "CoreDataUtility.h"
#import "Incident.h"
#import "LocationManager.h"
#import "NetworkManager.h"

static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface CFAEventsIncidentTableViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UITableView *incidentTableView;
@property (nonatomic, strong) UIRefreshControl *refreshCFAIncidentsControl;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CFAEventsIncidentTableViewController

# pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fetchedResultsController = [Incident MR_fetchAllSortedBy:@"status,originDate"
                                                     ascending:YES
                                                 withPredicate:nil
                                                       groupBy:nil
                                                      delegate:self];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    self.title = @"CFA Events";
    
    [self setupNavigationBar];
    [self setupScreen];
    [self fetchCFAEvents];
}

- (void)setupScreen
{
    self.view.backgroundColor = [UIColor backgroundColor];
    
    //Incident Table view
    self.incidentTableView = [[UITableView alloc] init];
    self.incidentTableView.backgroundColor = [UIColor backgroundColor];
    self.incidentTableView.delegate = self;
    self.incidentTableView.dataSource = self;
    [self.view addSubview:self.incidentTableView];
    
    //Refresh Control
    self.refreshCFAIncidentsControl = [[UIRefreshControl alloc] init];
    [self.refreshCFAIncidentsControl addTarget:self
                                   action:@selector(refreshIncidentList)
                         forControlEvents:UIControlEventValueChanged];
    [self.incidentTableView addSubview:self.refreshCFAIncidentsControl];
    
    //Constraints
    [NSLayoutConstraint activateConstraints:@[
                                              
                                              NSLayoutConstraintMakeEqual(self.incidentTableView, ALTop, self.view),
                                              NSLayoutConstraintMakeEqual(self.incidentTableView, ALBottom, self.view),
                                              NSLayoutConstraintMakeEqual(self.incidentTableView, ALRight, self.view),
                                              NSLayoutConstraintMakeEqual(self.incidentTableView, ALLeft, self.view),
                                              
                                              ]];
}

- (void)setupNavigationBar
{
    [AppearanceUtility setupNavigationBar];
}

/**
 *  Calls the shared network manager to download the latest CFA incidents and receives a dictionary of incidents.
 *  If these incidents are successfully retrieved they are passed onto a core data utility class to populate core data.
 *  Alert controllers are presented if either of these fail.
 */
- (void)fetchCFAEvents
{
    [[NetworkManager sharedManager] getCFAEventsWithCompletionHandler:^(NSDictionary *incidents, NSError *error)
    {
        if (error)
        {
            [self createAlertControllerWithError:error];
        }
        else
        {
            [CoreDataUtility createIncidentsFromDictionary:incidents withCompletionHandler:^(BOOL success, NSError *error)
            {
                if (error)
                {
                    [self createAlertControllerWithError:error];
                }
            }];
        }
    }];
}

# pragma mark - Actions

/**
 *  Refreshes the CFA incidents. Simply calls fetchCFAEvents
 */
- (void)refreshIncidentList
{
    [self fetchCFAEvents];
    [self.refreshCFAIncidentsControl endRefreshing];
}

# pragma mark - Error Handling

/**
 *  Presents an alert controller for any errors passed in with a completion handler
 *
 *  @param error The error that was passed in
 */
- (void)createAlertControllerWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:error.domain
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    
    [alert addAction:okayAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ReuseIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Incident *incident = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor backgroundColor];
    
    cell.textLabel.text = incident.type;
    cell.textLabel.font = [UIFont cellFont];
    
    UIImage *flameIcon = [[UIImage imageNamed:@"flame_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.image = flameIcon;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];

    IncidentStatus status = [incident incidentStatusFromString:incident.status];
    switch(status)
    {
        case IncidentStatusGoing:
            cell.imageView.tintColor = [UIColor goingColor];
            cell.selectedBackgroundView.backgroundColor = [[UIColor goingColor] colorWithAlphaComponent:0.25];
            break;
        case IncidentStatusContained:
            cell.imageView.tintColor = [UIColor containedColor];
            cell.selectedBackgroundView.backgroundColor = [[UIColor containedColor] colorWithAlphaComponent:0.25];
            break;
        case IncidentStatusControlled:
            cell.imageView.tintColor = [UIColor controlledColor];
            cell.selectedBackgroundView.backgroundColor = [[UIColor controlledColor] colorWithAlphaComponent:0.25];
            break;
        case IncidentStatusSafe:
            cell.imageView.tintColor = [UIColor safeColor];
            cell.selectedBackgroundView.backgroundColor = [[UIColor safeColor] colorWithAlphaComponent:0.25];
            break;
        default:
            cell.imageView.tintColor = [UIColor defaultColor];
            cell.selectedBackgroundView.backgroundColor = [[UIColor defaultColor] colorWithAlphaComponent:0.25];
            break;
    }
    
    CGFloat distance = [[LocationManager sharedManager] getDistanceFromCurrentLocationToIncidentLocation:CLLocationCoordinate2DMake([incident.latitude doubleValue], [incident.longitude doubleValue])];
    if (distance)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.fkm", distance];
    }
    else
    {
        cell.detailTextLabel.text = @"-km";
    }
    
    cell.detailTextLabel.font = [UIFont cellFont];
}

/**
 *  Presents the detail view controller and initialises it with an incident when it is selected in the table view
 *
 *  @param tableView The table the selected row is in
 *  @param indexPath The row that was selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFAEventsIncidentDetailViewController *cfaEventsDetailViewController = [[CFAEventsIncidentDetailViewController alloc] initWithIncident:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cfaEventsDetailViewController];
    [self.navigationController showDetailViewController:navController sender:self];
}

/**
 *  I'm sure there's more rhyme and reason to using user defaults than this
 *  Maybe you can show me the proper application sometime
 *  I did forget to ask, do these only update in the simulator after exiting and running again?
 *
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Melbourne"]];
    NSString *date = [formatter stringFromDate:[defaults objectForKey:@"Background Fetch"]];
    
    if (date)
    {
        return [NSString stringWithFormat:@"Last background sync: %@", date];
    }
    else
    {
        return [NSString stringWithFormat:@"Last background sync:"];
    }
}

# pragma mark - NSFetchedResultsControllerDelegate

/**
 *  Begins updating the table view
 *
 *  @param controllerr The fetched results controller
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.incidentTableView beginUpdates];
}

/**
 *  Inserts or removes sections that were changed
 *
 *  @param controller   The fetched results controller
 *  @param sectionInfo  The section info
 *  @param sectionIndex The section index
 *  @param type         The change type
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.incidentTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                    withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.incidentTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                    withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/**
 *  Inserts, updates or deletes phones that were changed
 *
 *  @param controller   The fetched results controller
 *  @param anObject     The phone that changed
 *  @param indexPath    The row
 *  @param type         The change type
 *  @param newIndexPath The new index path
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.incidentTableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

/**
 *  Finishes updating the table view
 *
 *  @param controller The fetched results controller
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.incidentTableView endUpdates];
}

@end
