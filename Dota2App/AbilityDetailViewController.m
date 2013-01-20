//
//  AbilityDetailViewController.m
//  Dota2App
//
//  Created by Kyle Davidson on 29/12/2012.
//
//

#import "AbilityDetailViewController.h"
#import "QuartzCore/CALayer.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderedDictionary.h"

@interface AbilityDetailViewController (){
    OrderedDictionary * dynamicAbilityAttrributes;
}

@end

@implementation AbilityDetailViewController
@synthesize ability;
@synthesize titleLabel, descriptionLabel, mcLabel, cdLabel, abilityImage, videoWebView, overviewContainer;
@synthesize mcIcon, cdIcon, scrollView, videoButton,tableView;

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
	// Do any additional setup after loading the view.
    
    self.abilityImage.image = [UIImage imageWithContentsOfFile:ability.imagePath];
    
    self.abilityImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.abilityImage.layer.shadowOffset = CGSizeMake(2, 2);
    self.abilityImage.layer.shadowOpacity = 1;
    self.abilityImage.layer.shadowRadius = 5.0;
    self.abilityImage.clipsToBounds = NO;
    
    CAGradientLayer *makeGradient = [CAGradientLayer layer];
    makeGradient.frame = self.overviewContainer.bounds;
    makeGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:46/255.0 green:48/255.0 blue:48/255.0 alpha:1] CGColor],(id)[[UIColor colorWithRed:35/255.0 green:38/255.0 blue:38/255.0 alpha:1] CGColor], nil];
    [self.overviewContainer.layer insertSublayer:makeGradient atIndex:1];
    
    self.overviewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.overviewContainer.layer.shadowOffset = CGSizeMake(0,1);
    self.overviewContainer.layer.shadowOpacity = 1;
    self.overviewContainer.layer.shadowRadius = 1.0;
    self.overviewContainer.clipsToBounds = NO;
    
    [self configureView];
    
    //Stops the white flash prior to loading vids
    [self.videoWebView  loadHTMLString:@"<html><body style=\"background-color:black;\"></body></html>" baseURL:nil];
    [self performSelector:@selector(loadURL:) withObject:nil afterDelay:0.1];
}

-(void)loadURL:(id)sender{
    
    [self.videoWebView  stopLoading]; //stops the previous request (static black bg)
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.ability.videoUrl]];
    [self.videoWebView loadRequest:request];
    
}

- (void)configureView {
    
    //Set the title
    [self.titleLabel setText:self.ability.name];
    //Set the mana cost
    
    self.descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.descriptionLabel.numberOfLines = 0;
    
    NSString * descriptionString = [NSString stringWithFormat:@"%@\n\n%@",self.ability.lore,self.ability.notes];
    
    [self.descriptionLabel setText:descriptionString];
    [self.descriptionLabel sizeToFit];
    
    if ([ability.isPassive boolValue]) {
        [self.mcLabel setHidden:TRUE];
        [self.cdLabel setHidden:TRUE];
        [self.mcIcon setHidden:TRUE];
        [self.cdIcon setHidden:TRUE];
    }
    else{
        [self.mcLabel setText:self.ability.mc];
        [self.cdLabel setText:self.ability.cd];
    }
    
     NSDictionary * JSONDict = [NSJSONSerialization JSONObjectWithData: [self.ability.dynamic dataUsingEncoding:NSUTF8StringEncoding]
                                                                options: NSJSONReadingMutableContainers
                                                                  error: nil];
    
    
    dynamicAbilityAttrributes = [OrderedDictionary dictionaryWithDictionary:JSONDict];
    
    
   
    
    int keyCount = [[dynamicAbilityAttrributes allKeys] count];
    int tableheightCalculation = (keyCount * 44) + 40;
    CGRect f =   tableView.frame;
    tableView.backgroundView = nil;
    f.size.height = tableheightCalculation;
    f.origin.y = descriptionLabel.frame.origin.y+descriptionLabel.frame.size.height + 10;
    tableView.frame = f;    
    
    f = videoWebView.frame;
    f.origin.y = tableView.frame.origin.y+tableView.frame.size.height + 10;
    videoWebView.frame = f;
    
    CGSize s = scrollView.contentSize;
    s.height = tableView.frame.origin.y+tableView.frame.size.height + 10;
    scrollView.contentSize = s;
    
    //    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
    //        [self makeiPhoneGridWithDictionary:JSON];
    //    }
    //    else{
    //        [self makeiPadGridWithDictionary:JSON];
    //    }
}


- (NSString*)attribValueToString:(id)value{
    
    NSString * result;
    
    if([value isKindOfClass:[NSString class]]){
        result = [value copy];
    } else if([value isKindOfClass:[NSArray class]]){
        NSMutableString * sb = [NSMutableString string];
        
        for (id val in (NSArray*)value) {
            [sb appendFormat:@"%@, ",val];
        }
        
        if (![sb isEqualToString:@""]){
            NSRange lastComma = {sb.length-2,2};
            [sb deleteCharactersInRange:lastComma];
        }
        
        result = [sb copy];
        
    }
    
    return result;
    
}

- (void)createDynamicAbilitySource{
    
    
    
    //    {
    //        Ability = "No Target";
    //        Damage = Physical;
    //        "Max damage" =     (
    //                            150,
    //                            220,
    //                            290,
    //                            360
    //                            );
    //        "Max stun" =     (
    //                          "1.75",
    //                          "2.5",
    //                          "3.25",
    //                          4
    //                          );
    //        Radius = 175;
    //    }
    
    
    
}

-(void)makeiPadGridWithDictionary: (NSDictionary*)badassDictionary{
    int gridSize = [badassDictionary count];
    int y = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height; //193 29
    
    NSArray * keys =[badassDictionary allKeys];
    
    for (int count = 0; count<gridSize; count++) {
        
        if (count%2 ==0){
            y+=29;
        }
        
        UILabel * gridLabel = [[UILabel alloc] init];
        
        if (count%2==0) {
            gridLabel.frame = CGRectMake(20,y,300,200);
        }
        else{
            gridLabel.frame = CGRectMake(392,y,300,200);
        }
        [gridLabel setBackgroundColor:[UIColor clearColor]];
        gridLabel.textColor = [UIColor colorWithRed:153 green:153 blue:153 alpha:1];
        
        gridLabel.lineBreakMode = UILineBreakModeWordWrap;
        gridLabel.numberOfLines = 0;
        gridLabel.text = [NSString stringWithFormat:@"%@: %@",[keys objectAtIndex:count],[badassDictionary valueForKey:[keys objectAtIndex:count]]];
        [gridLabel sizeToFit];
        [self.scrollView addSubview:gridLabel];
        [self.videoWebView setFrame:CGRectMake(self.videoWebView.frame.origin.x, gridLabel.frame.origin.y+gridLabel.frame.size.height+20, self.videoWebView.frame.size.width, self.videoWebView.frame.size.height)];
    }
    
    UILabel * loreLabel = [[UILabel alloc] init];
    [loreLabel setBackgroundColor:[UIColor clearColor]];
    loreLabel.textColor = [UIColor colorWithRed:153 green:153 blue:153 alpha:1];
    loreLabel.lineBreakMode = UILineBreakModeWordWrap;
    loreLabel.numberOfLines = 0;
    loreLabel.text = self.ability.lore;
    [loreLabel setFrame:CGRectMake(self.videoWebView.frame.origin.x, self.videoWebView.frame.origin.y+self.videoWebView.frame.size.height/1.5, 670, loreLabel.frame.size.height)];
    [loreLabel sizeToFit];
    
    [self.scrollView addSubview:loreLabel];
    [self.scrollView setContentSize:CGSizeMake(0, loreLabel.frame.origin.y + loreLabel.frame.size.height+100)];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dynamicAbilityAttrributes allKeys] count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DynamicAttribCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


-(NSString *)controller:(NSFetchedResultsController *)controller
sectionIndexTitleForSectionName:(NSString *)sectionName {
    return sectionName;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{   //Fetch the hero
    
    NSString * key = [dynamicAbilityAttrributes keyAtIndex:indexPath.row];
    NSString * value = [self attribValueToString:[dynamicAbilityAttrributes valueForKey:key]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[key lowercaseString] capitalizedString]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",value];
}


- (void)makeiPhoneGridWithDictionary: (NSDictionary*)badassDictionary {
    int gridSize = [badassDictionary count];
    int y = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height; //193 29
    
    NSArray * keys =[badassDictionary allKeys];
    
    UILabel * loreLabel = [[UILabel alloc] init];
    
    [loreLabel setBackgroundColor:[UIColor clearColor]];
    loreLabel.textColor = [UIColor colorWithRed:153 green:153 blue:153 alpha:1];
    
    loreLabel.lineBreakMode = UILineBreakModeWordWrap;
    loreLabel.numberOfLines = 0;
    loreLabel.text = self.ability.lore;
    
    [self.scrollView addSubview:loreLabel];
    
    for (int count = 0; count<gridSize; count++) {
        
        if (count%2 ==0){
            y+=29;
        }
        UILabel * gridLabel = [[UILabel alloc] init];
        
        gridLabel.frame = CGRectMake(20,y,300,200);
        [gridLabel setBackgroundColor:[UIColor clearColor]];
        gridLabel.textColor = [UIColor colorWithRed:153 green:153 blue:153 alpha:1];
        gridLabel.lineBreakMode = UILineBreakModeWordWrap;
        gridLabel.numberOfLines = 0;
        gridLabel.text = [NSString stringWithFormat:@"%@: %@",[keys objectAtIndex:count],[badassDictionary valueForKey:[keys objectAtIndex:count]]];
        [gridLabel sizeToFit];
        [self.scrollView addSubview:gridLabel];
        
        [loreLabel setFrame:CGRectMake(20, gridLabel.frame.origin.y+gridLabel.frame.size.height+20, 280, loreLabel.frame.size.height)];
        [loreLabel sizeToFit];
        
        [self.videoWebView setFrame:CGRectMake(self.videoWebView.frame.origin.x, gridLabel.frame.origin.y+gridLabel.frame.size.height+20, self.videoWebView.frame.size.width, self.videoWebView.frame.size.height)];
    }
    [self.scrollView setContentSize:CGSizeMake(0, loreLabel.frame.origin.y + loreLabel.frame.size.height+100)];
}



#pragma mark -
#pragma mark UIWebViewDelegate
//To check if youtube try to show the overview page of m.youtube.com or the current movie
//if the user click on the youtube logo this method stop loading the mobile page
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *urlRequest = [request URL];
    
    if ([[urlRequest absoluteString] isEqualToString:self.ability.videoUrl]) {
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
