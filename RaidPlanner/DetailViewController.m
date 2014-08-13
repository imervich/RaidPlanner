//
//  DetailViewController.m
//  RaidPlanner
//
//  Created by Iván Mervich on 8/13/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DetailViewController.h"
#import "Adventurer.h"
#import "Raid.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DetailViewController

- (IBAction)onAddRaid:(id)sender
{
	Raid *raid = [self raid];
	[self.adventurer addRaidsObject:raid];

	NSError *saveError;
	[self.adventurer.managedObjectContext save:&saveError];

	if (saveError) {
		UIAlertView *alertView = [UIAlertView new];
		alertView.title = @"Saving error";
		alertView.message = saveError.localizedDescription;
		[alertView addButtonWithTitle:@"OK"];
		[alertView show];

		NSLog(@"Saving error: %@", saveError.localizedDescription);
	}
}

- (Raid *)raid
{
	Raid *raid;
	NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Raid"];
	request.predicate = [NSPredicate predicateWithFormat:@"date = %@", self.datePicker.date];

	NSError *fetchError;
	NSArray *results = [self.adventurer.managedObjectContext executeFetchRequest:request error:nil];

	if (fetchError) {
		UIAlertView *alertView = [UIAlertView new];
		alertView.title = @"Fetch error";
		alertView.message = fetchError.localizedDescription;
		[alertView addButtonWithTitle:@"OK"];
		[alertView show];

		NSLog(@"Fetch error: %@", fetchError.localizedDescription);
	}

	if (results.count > 0) {
		raid = results[0];
	} else {
		raid = [NSEntityDescription insertNewObjectForEntityForName:@"Raid" inManagedObjectContext:self.adventurer.managedObjectContext];
		raid.date  = self.datePicker.date;
	}

	return raid;
}
@end
