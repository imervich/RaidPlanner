//
//  MasterViewController.m
//  RaidPlanner
//
//  Created by Iván Mervich on 8/13/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Adventurer.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Adventurer"];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"species" cacheName:@"rapidplanner"];

	self.fetchedResultsController.delegate = self;

	NSError *fetchError;
	[self.fetchedResultsController performFetch:&fetchError];

	if (fetchError) {
		UIAlertView *alertView = [UIAlertView new];
		alertView.title = @"Fetch error";
		alertView.message = fetchError.localizedDescription;
		[alertView addButtonWithTitle:@"OK"];
		[alertView show];

		NSLog(@"Fetch error: %@", fetchError.localizedDescription);
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return  [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.fetchedResultsController.sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Adventurer *adventurer = [self.fetchedResultsController objectAtIndexPath:indexPath];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.text = adventurer.name;
	cell.detailTextLabel.text = [NSNumber numberWithInt: adventurer.raids.count].description;
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.fetchedResultsController.sections[section] name];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	[self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)addNewAdventurerNamed:(UITextField *)sender
{
	NSArray *species = @[@"Human", @"Orc", @"Elf", @"Hobbit"];
	Adventurer *adventurer = [NSEntityDescription insertNewObjectForEntityForName:@"Adventurer"
														   inManagedObjectContext:self.managedObjectContext];
	adventurer.name = sender.text;
	adventurer.species = species[arc4random() % species.count];

	NSError *saveError;
	[self.managedObjectContext save:&saveError];

	if (saveError) {
		UIAlertView *alertView = [UIAlertView new];
		alertView.title = @"Saving error";
		alertView.message = saveError.localizedDescription;
		[alertView addButtonWithTitle:@"OK"];
		[alertView show];

		NSLog(@"Saving error: %@", saveError.localizedDescription);
	}

	sender.text = nil;
	[sender resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	Adventurer *adventurer = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
	DetailViewController *detailVC = segue.destinationViewController;
	detailVC.adventurer = adventurer;
}

@end
