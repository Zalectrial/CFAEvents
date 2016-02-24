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

static NSString *const ReuseIdentifier = @"ReuseIdentifier";

@interface CFAEventsIncidentTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *incidentTableView;

@end

@implementation CFAEventsIncidentTableViewController

# pragma mark - Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"CFA Events";
    
    [self setupScreen];
    [self setupNavigationBar];
}

- (void)setupScreen
{
    self.view.backgroundColor = [UIColor backgroundColor];
    
    //Incident table view
    self.incidentTableView = [[UITableView alloc] init];
    self.incidentTableView.delegate = self;
    self.incidentTableView.dataSource = self;
    [self.view addSubview:self.incidentTableView];
    
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
    UIBarButtonItem *refreshIncidentsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                            target:self
                                                                                            action:@selector(refreshIncidentList)];
    
    self.navigationItem.rightBarButtonItem = refreshIncidentsButton;
}

# pragma mark - Actions

- (void)refreshIncidentList
{
    
}

# pragma mark - Error Handling

# pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = @"Title";
    cell.textLabel.font = [UIFont cellFont];
    
    cell.imageView.image = [UIImage imageNamed:@"flame_small"];
    
    cell.detailTextLabel.text = @"Subtitle";
    cell.detailTextLabel.font = [UIFont cellFont];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFAEventsIncidentDetailViewController *cfaEventsDetailViewController = [[CFAEventsIncidentDetailViewController alloc] init];
    [self.navigationController showDetailViewController:cfaEventsDetailViewController sender:self];
}

# pragma mark - NSFetchedResultsControllerDelegate

@end
