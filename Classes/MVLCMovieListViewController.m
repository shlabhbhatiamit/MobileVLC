    //
//  MVLCMovieListViewController.m
//  MobileVLC
//
//  Created by Romain Goyet on 12/07/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MVLCMovieListViewController.h"
#import "MVLCMovieViewController.h"
#import "MVLCMovieGridViewCell.h"

@implementation MVLCMovieListViewController
@synthesize gridView=_gridView;
- (void)viewDidLoad {
    [super viewDidLoad];
	self.gridView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	
	_allMedia = [[NSMutableArray alloc] init];
	NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	for (NSString * fileName in [[NSFileManager defaultManager] directoryContentsAtPath:documentsDirectory]) {
		NSLog(@"filePath = %@", fileName);
		[_allMedia addObject:[VLCMedia mediaWithPath:[documentsDirectory stringByAppendingPathComponent:fileName]]];
	}
	VLCMedia * freebox = [VLCMedia mediaWithURL:[NSURL URLWithString:@"http://tv.freebox.fr/stream_france2"]];
	[_allMedia addObject:freebox];

	[self.gridView reloadData];
}

- (void)dealloc {
	[_allMedia release];
	[_gridView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark -
#pragma mark AQGridViewDataSource
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
	return [_allMedia count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
	static NSString * MVLCMovieListGridCellIdentifier = @"MVLCMovieListGridCellIdentifier";
	MVLCMovieGridViewCell * cell = (MVLCMovieGridViewCell *)[gridView dequeueReusableCellWithIdentifier:MVLCMovieListGridCellIdentifier];
	if (cell == nil) {
		cell = [[[MVLCMovieGridViewCell alloc] initWithReuseIdentifier:MVLCMovieListGridCellIdentifier] autorelease];
		cell.media = [_allMedia objectAtIndex:index];
	}
	return cell; 
}

#pragma mark -
#pragma mark AQGridViewDelegate
- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
	MVLCMovieViewController * movieViewController = [[MVLCMovieViewController alloc] init];
	movieViewController.media = [_allMedia objectAtIndex:index];
	[self.navigationController pushViewController:movieViewController animated:YES];
	[movieViewController release];
}

@end
