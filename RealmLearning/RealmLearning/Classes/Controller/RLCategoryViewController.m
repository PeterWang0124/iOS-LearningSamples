//
//  RLCategoryViewController.m
//  RealmLearning
//
//  Created by PeterWang on 1/5/15.
//  Copyright (c) 2015 PeterWang. All rights reserved.
//

#import "RLCategoryViewController.h"

//Model
#import "RLCategory.h"

@interface RLCategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) RLMResults *categories;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation RLCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Init cell
    [self.categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.categories = [RLCategory allObjects];
    if (!self.categories.count) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        
        NSArray *defaultCategories = @[@"Birds", @"Mammals", @"Flora", @"Reptiles", @"Arachnids"];
        for (NSString *category in defaultCategories) {
            RLCategory *newCategory = [[RLCategory alloc] init];
            newCategory.name = category;
            [[RLMRealm defaultRealm] addObject:newCategory];
        }
        
        [[RLMRealm defaultRealm] commitWriteTransaction];
        self.categories = [RLCategory allObjects];
    }
    
    NSLog(@"category count : %zd", self.categories.count);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    //Set cell.
    RLCategory *category = self.categories[indexPath.row];
    cell.textLabel.text = category.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(RLCategoryViewController:didSelectedCategory:)]) {
        [self.delegate RLCategoryViewController:self didSelectedCategory:self.categories[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
