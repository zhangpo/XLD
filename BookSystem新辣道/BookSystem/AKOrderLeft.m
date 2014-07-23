//
//  AKOrderLeft.m
//  BookSystem
//
//  Created by chensen on 14-1-12.
//
//

#import "AKOrderLeft.h"
#import "AKOrderRepastViewController.h"
#import "Singleton.h"
#import "AKOredrCell.h"

@interface AKOrderLeft ()

@end

@implementation AKOrderLeft
{
    NSMutableArray *_dataArray;
    UITableView *table;
}

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
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    [image setImage:[UIImage imageNamed:@"biaoti.jpg"]];
    [self.view addSubview:image];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (mydish:) name:@"postData" object:nil];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 280, 1024-50) style:UITableViewStylePlain];
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)mydish:(NSNotification *)center
{
    //    NSLog(@"%@",array);
    _dataArray=(NSMutableArray *)center.object;
//    [self data];
    [table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    
    AKOredrCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[AKOredrCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.name.text=@"";
    NSLog(@"%d",indexPath.row);
    NSLog(@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DES"]);
    if ([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CNT"]==nil) {
        cell.name.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DES"];
        cell.count.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"];
    }else
    {
        cell.name.text=[NSString stringWithFormat:@"--%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"DES"]];
        cell.count.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CNT"];
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
