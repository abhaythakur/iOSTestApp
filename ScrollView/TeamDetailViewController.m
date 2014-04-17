//
//  TeamDetailViewController.m
//  ScrollView
//
//  Created by Apple on 05/04/14.
//  Copyright (c) 2014 Abhay. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "JSONKit.h"
#import "Utility.h"

@interface TeamDetailViewController ()

@end

@implementation TeamDetailViewController

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
    selected = 1;
    historyView = NO;
    int teamId = 1;
    NSString *post =
    [[NSString alloc] initWithFormat:@"TeamId=%d",teamId];
    
    NSURL *url = [NSURL URLWithString:@"http://api.phantomsoccer.com/mobapi.asmx/GetTeamsByIdWebService"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *data=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
   distResponse = [data objectFromJSONString];
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==0) {
//        return 1;
//    }
    return 2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
//{
//    return 30;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(indexPath.row==0)
    {
        return 150;
    }
    
//    return 1000;
//    NSArray *ary =nil;
//    if(selected==1)
//    {
        NSArray *aryDetail = [[distResponse valueForKey:@"data"] valueForKey:@"TeamDetail"];
        NSArray *ary = [[aryDetail objectAtIndex:0]valueForKey:@"TeamUpComing"];
//    }
//    else
//    {
        NSArray *ary1 = [[aryDetail objectAtIndex:0]valueForKey:@"TeamPassed"];
    //}
    if(ary>ary1)
    {
        return ary.count*110+70;

    }
    else
    {
        return ary1.count*110+70;
    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor blackColor]];
    
    UILabel *lblName = [[UILabel alloc] init];
    [lblName setFrame:CGRectMake(10,0,300,30)];
    [lblName setTextColor:[UIColor whiteColor]];
    if(section==0)
    {
        [lblName setText:@"Players"];
    }
    else
    {
        [lblName setText:@"History"];

    }
    [view addSubview:lblName];
    return view;
}
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if(indexPath.row==0)
    {
        cell = [self createTableCellForZeroIndex:indexPath];
    }
    else
    {
        cell = [self createTableCell:indexPath];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:218.00/256 green:214.00/256 blue:224.00/256 alpha:1.0]];
    return cell;
}
-(UITableViewCell*)createTableCellForZeroIndex:(NSIndexPath *)indexPath
{
    NSString * identifire=[NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell=(UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:identifire];
    
    if(cell == nil)
    {
        NSArray *aryDetail = [[distResponse valueForKey:@"data"] valueForKey:@"TeamDetail"];
        NSArray *ary = [[aryDetail objectAtIndex:0]valueForKey:@"PlayerInfo"];

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        
        UILabel *lblName = [[UILabel alloc] init];
        [lblName setFrame:CGRectMake(0,0,320,30)];
        [lblName setBackgroundColor:[UIColor blackColor]];
        [lblName setTextColor:[UIColor whiteColor]];
        [lblName setText:@"Players"];
        [cell addSubview:lblName];
        
        
        UIScrollView *scrol = [[UIScrollView alloc] init];
        [scrol setBackgroundColor:[UIColor clearColor]];
        [scrol setFrame:CGRectMake(0,30,320,140)];
        [scrol setContentSize:CGSizeMake(ary.count*110,140)];
        
        
        int x = 10;
        for(int i = 0;i<[ary count];i++)
        {
            NSString *strUrl = [NSString stringWithFormat:@"%@",[[ary objectAtIndex:i] valueForKey:@"picture"]];
            UIImageView *imgView = [[Utility shared]GetImageView:strUrl];
            [imgView setFrame:CGRectMake(x,0,100,100)];
            [scrol addSubview:imgView];
            
            UILabel *lblName = [[UILabel alloc] init];
            [lblName setFrame:CGRectMake(x,imgView.frame.origin.y+imgView.frame.size.height,100,30)];
            [lblName setTextColor:[UIColor whiteColor]];
            NSString *strName = [NSString stringWithFormat:@"%@",[[ary objectAtIndex:i] valueForKey:@"PlayerName"]];
            [lblName setFont:[UIFont systemFontOfSize:12]];
            [lblName setText:strName];
            [lblName setTextAlignment:NSTextAlignmentCenter];
            [scrol addSubview:lblName];
            x = x+105;
            
        }
        [cell addSubview:scrol];
    }
    return cell;
}

-(UITableViewCell*)createTableCell:(NSIndexPath *)indexPath
{
    NSString * identifire=[NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell=(UITableViewCell *)[tblView dequeueReusableCellWithIdentifier:identifire];
    
   //(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
        [cell setBackgroundColor:[UIColor blackColor]];
        
        if(!historyView)
        {
            UILabel *lblName = [[UILabel alloc] init];
            [lblName setFrame:CGRectMake(0,0,320,30)];
            [lblName setBackgroundColor:[UIColor blackColor]];
            [lblName setTextColor:[UIColor whiteColor]];
            [lblName setText:@"History"];
            [cell addSubview:lblName];
            
            UIButton *btnUpcoming = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnUpcoming setFrame:CGRectMake(10,40,150,30)];
            [btnUpcoming setBackgroundColor:[UIColor yellowColor]];
            [btnUpcoming setTitle:@"Upcomming" forState:UIControlStateNormal];
            [btnUpcoming addTarget:self action:@selector(btnUpcommingclicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnUpcoming];
            
            UIButton *btnPassed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btnPassed setFrame:CGRectMake(160,40,150,30)];
            [btnPassed setBackgroundColor:[UIColor redColor]];
            [btnPassed setTitle:@"Passesd" forState:UIControlStateNormal];
            [btnPassed addTarget:self action:@selector(btnPassedclicked:) forControlEvents:UIControlEventTouchUpInside];

            [cell addSubview:btnPassed];
            
          
         
            NSArray *aryDetail = [[distResponse valueForKey:@"data"] valueForKey:@"TeamDetail"];
            NSArray *ary = [[aryDetail objectAtIndex:0]valueForKey:@"TeamUpComing"];
            
            if(ary.count>0)
            {
                viewUpcoming = [self CreateHistroyView:ary];
                [viewUpcoming setBackgroundColor:[UIColor redColor]];
                [viewUpcoming setFrame:CGRectMake(10,80,300,aryDetail.count+110)];
                [cell addSubview:viewUpcoming];
            }
            
            NSArray *ary1 = [[aryDetail objectAtIndex:0]valueForKey:@"TeamPassed"];
            if(ary1.count>0)
            {
                viewPassed = [self CreateHistroyView:ary1];
                [viewPassed setBackgroundColor:[UIColor greenColor]];
                [viewPassed setFrame:CGRectMake(10,80,300,ary1.count+110)];
                [cell addSubview:viewPassed];
                [viewPassed setHidden:YES];
            }
        }
        else
        {
            if(selected==1)
            {
                [viewUpcoming setHidden:NO];
                [viewPassed setHidden:YES];
            }
            else
            {
                [viewUpcoming setHidden:YES];
                [viewPassed setHidden:NO];
            }
        }
    }
    return cell;
}

-(void)btnUpcommingclicked:(UIButton*)Sender
{
    selected = 1;
    [viewPassed setHidden:YES];
    [viewUpcoming setHidden:NO];
    //[tblView setRowHeight:100];

    //[tblView reloadData];
}

-(void)btnPassedclicked:(UIButton*)sender
{
    selected = 2;
    [viewPassed setHidden:NO];
    [viewUpcoming setHidden:YES];
   // [tblView setRowHeight:1000];

   // [tblView reloadData];

}
-(UIView*)CreateHistroyView:(NSArray*)ary
{
    historyView = YES;
    UIView *viewMain = [[UIView alloc] init];
    int y = 0;
    for(int i=0;i<ary.count;i++)
    {
        UIView *container = [[UIView alloc] init];
        [container setFrame:CGRectMake(10,y,300,100)];
        [container setBackgroundColor:[UIColor whiteColor]];
       
        NSString *strUrl = [NSString stringWithFormat:@"%@",[[ary objectAtIndex:i] valueForKey:@"picture"]];
        UIImageView *imgView = [[Utility shared]GetImageView:strUrl];
        [imgView setFrame:CGRectMake(10,0,30,30)];
        [container addSubview:imgView];
        
       
        UILabel *lblName = [[UILabel alloc] init];
        [lblName setFrame:CGRectMake(10,40,200,30)];
        [lblName setBackgroundColor:[UIColor blackColor]];
        [lblName setTextColor:[UIColor yellowColor]];
        [lblName setText:[NSString stringWithFormat:@"%@",[[ary objectAtIndex:i] valueForKey:@"opponent"]]];
        [container addSubview:lblName];
        //Do some thing
        // Do some thing intrested
        
        [viewMain addSubview:container];

        y=y+110;
    }
    return viewMain;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
