//
//  AppDelegate.m
//  Norico
//
//  Created by 式正 鍋田 on 12/07/06.
//  Copyright (c) 2012年 Norimasa Nabeta. All rights reserved.
//

#import "AppDelegate.h"
#import "BookViewController.h"
#import "AuthorViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSLog(@"CoreData:1:didFinishLaunchingWithOptions");
    
    // CMU RECOMMANDED
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JVerse.sqlite"];    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[storeURL path]]){
        NSURL *defaultStoreURL =[[NSBundle mainBundle] URLForResource:@"JVerse" withExtension:@"sqlite"];
        if(defaultStoreURL){
            //[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NIL];
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:nil];
            NSLog(@"Copied data");
        }
    }
    else {
        NSLog(@"Already have the data");
    }
/*
    NSArray *viewControllers=self.window.rootViewController.childViewControllers;
    BookViewController *controller1 = (BookViewController *)[viewControllers objectAtIndex:0];
    controller1.managedObjectContext = self.managedObjectContext;
    AuthorViewController *controller2 = (AuthorViewController *)[viewControllers objectAtIndex:1];
    controller2.managedObjectContext = self.managedObjectContext;
  */

    /* cumbersome methods
    // Ray Wenderlich's tutorials
    // in the didFinishLaunchingWithOptions: section:
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController1 = [[tabBarController viewControllers] objectAtIndex:0];
    BookViewController *bookViewController = [[navigationController1 viewControllers] objectAtIndex:0];
    bookViewController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *navigationController2 = [[tabBarController viewControllers] objectAtIndex:0];
    AuthorViewController *authorViewController = [[navigationController2 viewControllers] objectAtIndex:0];
    authorViewController.managedObjectContext = self.managedObjectContext;
  */  
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist,
// it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
    // NSLog(@"managedObjectModel:1 %@", _managedObjectModel);
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JVerse" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    // NSLog(@"managedObjectModel:2 %@", _managedObjectModel);
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSLog(@"CoreData:2:persistentStoreCoordinator");
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JVerse.sqlite"];
    
    NSError *error = nil;
    // NSManagedObjectModel *check=[self managedObjectModel];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
