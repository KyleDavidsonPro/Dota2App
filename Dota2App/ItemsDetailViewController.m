//
//  ItemsDetailViewController.m
//  Dota2App
//
//  Created by Kyle Davidson on 29/12/2012.
//
//

#import "ItemsDetailViewController.h"
#import "DetailViewController.h"
#import "ItemCell.h"

@interface ItemsDetailViewController ()

@end

@implementation ItemsDetailViewController
@synthesize item = _item, manaCost,manaImage,lore,name;
@synthesize cost, description, cooldown, cooldownImage, image, tableView;
@synthesize overviewContainer, scrollView;

- (void)setItem:(Item *)item {
    if (_item != item) {
        _item = item;
    }
    
    if (_item) {
        [self configureView];
    }
}
#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_item) {
        [self configureView];
    }
    
    
	// Do any additional setup after loading the view.
    
    
}

-(void)configureView
{   //initially hide the table view
    self.tableView.hidden = YES;
    recipeCost = 0;
    
    if (![_item.components count]) {
        [_item mapItemComponents];
    }
    
    itemComponents = [_item.components allObjects];
    if (![itemComponents count] == 0) {
        self.tableView.hidden = NO;
        
        
        for (Item * componentItem in [_item.components allObjects]) {
            recipeCost += [componentItem.cost intValue];
        }
        if (recipeCost == [_item.cost intValue]) {
            recipeCost = 0;
        }
        else{
            recipeCost =  [_item.cost intValue]-recipeCost;
        }

        if (recipeCost < 0) {
            self.tableView.hidden = YES;
        }
        else{
            [self.tableView reloadData];
        }
    }
    
    
    self.name.text = _item.name;
    self.title = _item.name;
    
    self.image.image = [UIImage imageWithContentsOfFile:_item.imgPath];
    
    self.image.layer.shadowColor = [UIColor blackColor].CGColor;
    self.image.layer.shadowOffset = CGSizeMake(2, 2);
    self.image.layer.shadowOpacity = 1;
    self.image.layer.shadowRadius = 5.0;
    self.image.clipsToBounds = NO;
    
    self.lore.text = _item.lore;
    self.description.text = [_item.desc stringByReplacingOccurrencesOfString:@"<br />"withString:@""];
    self.manaCost.text = [NSString stringWithFormat:@"%@",_item.manaCost];
    self.cost.text = [NSString stringWithFormat:@"%@",_item.cost];
    self.cooldown.text = [NSString stringWithFormat:@"%@", _item.coolDown];
    
    CGSize maximumLabelSize = CGSizeMake(self.description.frame.size.width, FLT_MAX);
    
    CGSize descriptionExpectedLabelSize = [self.description.text sizeWithFont:self.description.font constrainedToSize:maximumLabelSize lineBreakMode:self.description.lineBreakMode];   
    
    //adjust the label the the new height.
    CGRect newFrame = self.description.frame;
    newFrame.size.height = descriptionExpectedLabelSize.height + 20;
    self.description.frame = newFrame;


    CGSize loreExpectedLabelSize = [self.lore.text sizeWithFont:self.lore.font constrainedToSize:maximumLabelSize lineBreakMode:self.lore.lineBreakMode];  
    self.lore.frame = CGRectMake(self.lore.frame.origin.x,self.description.frame.origin.y+self.description.frame.size.height + 8,self.lore.frame.size.width,self.lore.frame.size.height);
    CGRect newLoreFrame = self.lore.frame;
    newLoreFrame.size.height = loreExpectedLabelSize.height + 20;
    self.lore.frame = newLoreFrame;

    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, 
                                      self.lore.frame.origin.y + self.lore.frame.size.height+8,
                                      self.tableView.frame.size.width,
                                      [itemComponents count]* self.tableView.rowHeight+150);

    
    [self.scrollView setContentSize:CGSizeMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height)];
    
    
    if ([self.cooldown.text isEqualToString:@"0"]) {
        self.cooldown.hidden = true;
        self.manaCost.hidden = true;
        self.cooldownImage.hidden = true;
        self.manaImage.hidden = true;
    }
    else{
        self.cooldown.hidden = false;
        self.manaCost.hidden = false;
        self.cooldownImage.hidden = false;
        self.manaImage.hidden = false;
    }



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Del


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (recipeCost ==0) {
        return [itemComponents count];
    }else{
        return [itemComponents count] + 1;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{   //Fetch the hero
    NSLog(@"%d",indexPath.row);
    ItemCell *itemCell = (ItemCell *)cell;
    if (indexPath.row >= [itemComponents count]) {
        itemCell.cellTitleLabel.text = @"Recipe";
        itemCell.cellDetailLabel.text = [NSString stringWithFormat:@"%d",recipeCost];
        itemCell.cellImage.image = [UIImage imageNamed:@"Recipe_Scroll.png"];

        
    }else{
        NSLog(@"%d",[itemComponents count]);
        Item *itemComponent = [itemComponents objectAtIndex:[indexPath row]];
        itemCell.cellTitleLabel.text= itemComponent.name;
        itemCell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",itemComponent.cost];
        //cell.cellImage.image = [UIImage imageNamed:item.imgName];
        itemCell.cellImage.image = [UIImage imageWithContentsOfFile:itemComponent.imgPath];
        
        itemCell.cellImage.layer.shadowColor = [UIColor blackColor].CGColor;
        itemCell.cellImage.layer.shadowOffset = CGSizeMake(1,1);
        itemCell.cellImage.layer.shadowOpacity = 1;
        itemCell.cellImage.layer.shadowRadius = 1.0;
        itemCell.cellImage.clipsToBounds = NO;

    }
    itemCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
}






@end
