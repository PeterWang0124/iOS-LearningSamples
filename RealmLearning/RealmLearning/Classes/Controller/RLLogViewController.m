//
//  RLLogViewController.m
//  RealmLearning
//
//  Created by PeterWang on 1/7/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "RLLogViewController.h"

//Category
#import "UISearchBar+EmptySearchText.h"

//Model
#import "RLSpecimen.h"
#import "RLCategory.h"

//View
#import "RLSpecimenTableViewCell.h"

//Controller
#import "RLAddNewEntryViewController.h"

@interface RLLogViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) RLMResults *specimens;

@property (weak, nonatomic) IBOutlet UISearchBar *specimenSearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *specimenTableView;

@end

@implementation RLLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Log View";
    
    //Register
    [self.specimenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RLSpecimenTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RLSpecimenTableViewCell class])];
    
    //Init data
    [self updateSpecimenWithNameSearchString:@"" sortType:RLLogSortTypeAToZ];
    [self.specimenTableView reloadData];
}

- (void)updateSpecimenWithNameSearchString:(NSString *)searchString sortType:(RLLogSortType)sortType {
    //Search name by search string.
    RLMResults *searchResults;
    if (searchString.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH [c]%@", searchString];
        searchResults = [RLSpecimen objectsWithPredicate:predicate];
    }
    else {
        searchResults = [RLSpecimen allObjects];
    }
    
    //Sort by type.
    if (sortType == RLLogSortTypeAToZ) {
        self.specimens = [searchResults sortedResultsUsingProperty:@"name" ascending:YES];
    }
    else if (sortType == RLLogSortTypeNearToFar) {
        self.specimens = [searchResults sortedResultsUsingProperty:@"distance" ascending:YES];
    }
    else if (sortType == RLLogSortTypeNewToOld) {
        self.specimens = [searchResults sortedResultsUsingProperty:@"created" ascending:YES];
    }
    else {
        self.specimens = searchResults;
    }
}

#pragma mark - IBAction

- (IBAction)sortTypeChange:(UISegmentedControl *)sender {
    if (sender == self.sortTypeSegmentedControl) {
        [self updateSpecimenWithNameSearchString:self.specimenSearchBar.text sortType:sender.selectedSegmentIndex];
        [self.specimenTableView reloadData];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.specimens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RLSpecimenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RLSpecimenTableViewCell class]) forIndexPath:indexPath];

    //Set cell.
    RLSpecimen *specimen = self.specimens[indexPath.row];
    cell.nameLabel.text = specimen.name;
    cell.categoryLabel.text = specimen.category ? specimen.category.name : RLUncategorized;
    if (specimen.distance < 0) {
        cell.distanceLabel.text = @"N/A";
    }
    else {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", specimen.distance / 1000];
    }
  
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RLSpecimen *deleteSpecimen = self.specimens[indexPath.row];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm] deleteObject:deleteSpecimen];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    
        [self updateSpecimenWithNameSearchString:self.specimenSearchBar.text sortType:self.sortTypeSegmentedControl.selectedSegmentIndex];
        [self.specimenTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    RLSpecimen *specimen = self.specimens[indexPath.row];
    RLAddNewEntryViewController *controller = [[RLAddNewEntryViewController alloc] initWithNibName:NSStringFromClass([RLAddNewEntryViewController class]) bundle:[NSBundle mainBundle]];
    [controller setSpecimen:specimen];
    
    //Clear title.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchBar resignFirstResponderWithSearchText:searchText];
    
    //When clear search text, need to update specimen.
    if (searchText.length == 0) {
        [self updateSpecimenWithNameSearchString:self.specimenSearchBar.text sortType:self.sortTypeSegmentedControl.selectedSegmentIndex];
        [self.specimenTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self updateSpecimenWithNameSearchString:searchBar.text sortType:self.sortTypeSegmentedControl.selectedSegmentIndex];
    [self.specimenTableView reloadData];
    [searchBar endEditing:YES];
}

@end
