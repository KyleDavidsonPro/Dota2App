//
//  AppDelegate.m
//  Dota2App
//
//  Created by Kyle Davidson on 10/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "HeroParser.h"
#import "Itemparser.h"
#import "PagedWelcome.h"
//#import "SHK.h"
//#import "SHKConfiguration.h"
//#import "SHKFacebook.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize heroNavStack, itemNavStack;
//@synthesize client = __client;


//STACKMOB SETTINGS
#define STACKMOB_ENABLE NO
#define DEVELOPER_FORCE_WELCOME NO
#define STACKMOB_KEY @"6586fffa-0b95-426c-8763-d30299599b40"
#define UseJSON YES

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // set the socialize api key and secret, register your app here: http://www.getsocialize.com/apps/
//    [Socialize storeConsumerKey:@"82c2299d-cd5c-40b7-995b-9dc70025178c"];
//    [Socialize storeConsumerSecret:@"a1444a54-d869-4fea-b2f6-3c7f3de4e7c8"];
//    [SZTwitterUtils setConsumerKey:@"u9do3dzYoItcDGMrqUy5A" consumerSecret:@"XMxHfK5XXnUhdSddUc0D6UVXnxhVH8ggxbthHCqhQtA"];
//    [SZFacebookUtils setAppId:@"201163993356091"];

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:85/ 255.0 green:0/ 255.0 blue:2/ 255.0 alpha:1.0]];
    
    // Nav stack hookups for ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        self.heroNavStack = [splitViewController.viewControllers objectAtIndex:1];
    }
    
    if(STACKMOB_ENABLE){
//         self.client = [[SMClient alloc] initWithAPIVersion:@"0" publicKey:STACKMOB_KEY];
//         SMCoreDataStore *coreDataStore = [self.client coreDataStoreWithManagedObjectModel:self.managedObjectModel];
//        self.managedObjectContext = [coreDataStore managedObjectContext];
    } else {
        self.managedObjectContext = [self offlineManagedObjectContext];
        
        if(UseJSON)
        {
            [[[HeroParser alloc] init] parse];
            [[[Itemparser alloc] init] parse];
        }
    }
    
    NSString *model = [[UIDevice currentDevice] model];
    //TODO WELCOME MESSAGE SCHEDULING LOGIC
    if ((![model isEqualToString:@"iPhone Simulator"] && ![model isEqualToString:@"iPad Simulator"]) || DEVELOPER_FORCE_WELCOME) {
        [self performSelector:@selector(showWelcomePager) withObject:nil afterDelay:0.1];
    }
    
    
    return YES;
}

- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
//    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
//    if ([scheme hasPrefix:prefix])
//        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}

- (void)showWelcomePager{
    PagedWelcome * welcome = [PagedWelcome new];
    welcome.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentModalViewController:welcome animated:YES];
    [welcome startAutoPaging];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //[SHKFacebook handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
     //[SHKFacebook handleWillTerminate];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.*/
 
- (NSManagedObjectContext *)offlineManagedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/*
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Dota2App" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Dota2App.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not- accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
