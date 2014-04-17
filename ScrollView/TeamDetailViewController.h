//
//  TeamDetailViewController.h
//  ScrollView
//
//  Created by Apple on 05/04/14.
//  Copyright (c) 2014 Abhay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDetailViewController : UIViewController
{

    __weak IBOutlet UITableView *tblView;
    
    
    BOOL historyView;
    NSMutableDictionary *distResponse;
    
    // if selected==1 means upcoming or else passed clicked....
    int selected ;
    
    UIView *viewUpcoming;
    UIView *viewPassed;
}

@end
