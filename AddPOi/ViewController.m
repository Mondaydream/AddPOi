//
//  ViewController.m
//  AddPOi
//
//  Created by 黄鹏志 on 15/9/24.
//  Copyright © 2015年 黄鹏志. All rights reserved.
//

#import "ViewController.h"
#import "CABasicAnimation+poiViewAnimation.h"
#import "MainCell.h"
#import "CollectionViewCell.h"
#import "CDLineLayout.h"
#import "CustomView.h"
#import "NewCell.h"
#import "PoiInfo.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL _flag;
    CGPoint _pointBegin;
    CGFloat _height;
    NSIndexPath *_tempIndex;
    NSIndexPath *_endIndex;
    NSIndexPath *_lastInsertIndex;
    CustomView *_poiView;
    NSInteger _addCount;
    NSInteger _insertCount;
    NSInteger _number;
    NSMutableDictionary *_infodic;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *popText;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildPoiView];
    [self shakePoiView];
    [self addDataArray];
    _popText.hidden = YES;
    _tempIndex = [NSIndexPath indexPathForItem:100 inSection:0];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, _tableView.rowHeight, 0);
    _addCount = 1;
    _number = 1;
    _insertCount = 0;
    _infodic = [[NSMutableDictionary alloc] init];
    
    CDLineLayout *layout = [[CDLineLayout alloc] init];
    [_collectionView setCollectionViewLayout:layout];
    [self bulidNewPoiView];
}

//创建顶部poi视图
- (void)buildPoiView{
    _poiView = [[[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil] lastObject];
    _poiView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 120, 48, 240, 72);
    _poiView.tag = 10;
    _poiView.layer.cornerRadius = 5;
    _poiView.clipsToBounds = YES;
    [self.view addSubview:_poiView];
}
//tableview的数据源
- (void)addDataArray{
    NSDictionary *dic = @{@"Cell":@"mainCell",@"isAdd":@(NO)};
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 5; i++) {
        [_dataArray addObject:dic];
    }
}
//计算拖拽响应高度
- (void)calculateHeight{
    if (_dataArray.count * _tableView.rowHeight > _tableView.bounds.size.height) {
        _height = _tableView.center.y + _tableView.bounds.size.height / 2;
    }else{
        _height = _tableView.center.y - _tableView.bounds.size.height / 2 + _dataArray.count * _tableView.rowHeight;
    }
}

//更新poi视图的编号及创建新的poi视图
- (void)bulidNewPoiView{
    CDLineLayout *layout = (CDLineLayout *)_collectionView.collectionViewLayout;
    layout.block = ^(NSInteger midNo) {
        _poiView.topLabel.text = [NSString stringWithFormat:@"%ld", midNo + 1];
        _number = midNo + 1;
        if (_poiView == nil) {
            _poiView = [[[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil] lastObject];
            _poiView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 120, 48, 240, 72);
            _poiView.tag = 10;
            _poiView.layer.cornerRadius = 5;
            _poiView.clipsToBounds = YES;
            _poiView.topLabel.text = [NSString stringWithFormat:@"%ld", midNo + 1];
            [self poiViewAnimation:_poiView];
            [self.view addSubview:_poiView];
            _tempIndex = [NSIndexPath indexPathForRow:100 inSection:0];
            _popText.hidden = YES;
            _addCount++;
        }
    };
}

//给字体划线
- (NSMutableAttributedString *)createLine:(NSString *)string{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = NSMakeRange(0, string.length);
    [attStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range: range];
    return attStr;
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collect" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    if (![cell.secondLabel.text isEqual:@""]) {
        cell.secondLabel.text = @"";
    }
    if (indexPath.row == 0) {
        cell.secondLabel.text = @"东京";
    }
    return cell;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"mainCell"] ) {
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"深圳"];
        cell.detailLabel.text = [NSString stringWithFormat:@"深圳西路%ld号",indexPath.row + 1];
        if ([[_dataArray[indexPath.row] objectForKey:@"candle"] isEqualToString:@"notgo"]){
            cell.titleLabel.text = [NSString stringWithFormat:@"深圳"];
            cell.titleLabel.attributedText = [self createLine:cell.titleLabel.text];
            cell.detailLabel.text = [NSString stringWithFormat:@"深圳西路%ld号",indexPath.row + 1];
            cell.detailLabel.attributedText = [self createLine:cell.detailLabel.text];
        }
        return cell;
    }
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"addSpace"]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addSpace" forIndexPath:indexPath];
        return cell;
    }
    if ([[_dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"newCell"]){
        NewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newCell" forIndexPath:indexPath];
        PoiInfo *poi = [_dataArray[indexPath.row] objectForKey:@"poi"];
        cell.titleLabel.text = [NSString stringWithFormat:@"New Poi 第%ld次添加 编号:%ld",poi.addCount,poi.number];
        cell.detailLabel.text = @"东京";
        if ([[_dataArray[indexPath.row] objectForKey:@"candle"] isEqualToString:@"notgo"]){
            PoiInfo *poi = [_dataArray[indexPath.row] objectForKey:@"poi"];
            cell.titleLabel.text = [NSString stringWithFormat:@"New Poi 第%ld次添加 编号:%ld",poi.addCount,poi.number];
            cell.titleLabel.attributedText = [self createLine:cell.titleLabel.text];
            cell.detailLabel.text = @"东京";
            cell.detailLabel.attributedText = [self createLine:cell.detailLabel.text];
        }
        return cell;
    }
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_dataArray[indexPath.row]];
        if (![[dic objectForKey:@"candle"] isEqualToString:@"notgo"]) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [dic setValue:@"notgo" forKey:@"candle"];
            [_dataArray addObject:dic];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        }else{
            [dic setValue:@"go" forKey:@"candle"];
            [_dataArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_dataArray insertObject:dic atIndex:0];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        }
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataArray[indexPath.row] objectForKey:@"candle"] isEqualToString:@"notgo"]) {
        return @"Add \nback";
    }else{
        return @"Not \ngoing";
    }
}

#pragma mark - addSpace
//打开或关闭cell之间的空隙
- (void)addSpace:(NSIndexPath *)indexPath{
    NSIndexPath *path = nil;
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"mainCell"] || [[self.dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"newCell"]) {
        path = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
    }else{
        path = indexPath;
    }
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"isAdd"] boolValue]) {
        //close Space
        if ([[_dataArray[indexPath.row ] objectForKey:@"Cell"] isEqualToString:@"mainCell"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
            [dic setValue:@(NO) forKey:@"isAdd"];
            self.dataArray[(path.row - 1)] = dic;
        }else{
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
            [dic setValue:@(NO) forKey:@"isAdd"];
            self.dataArray[(path.row - 1)] = dic;
        }
        [self.dataArray removeObjectAtIndex:path.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[path]  withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }else{
        //  open Space
        if ([[_dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"newCell"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
            [dic setValue:@(YES) forKey:@"isAdd"];
            self.dataArray[(path.row - 1)] = dic;
        }else if([[_dataArray[indexPath.row] objectForKey:@"Cell"] isEqualToString:@"mainCell"]){
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
            [dic setValue:@(YES) forKey:@"isAdd"];
            self.dataArray[(path.row - 1)] = dic;
        }
       
        NSDictionary * addDic = @{@"Cell": @"addSpace",@"isAdd":@(YES),};
        [self.dataArray insertObject:addDic atIndex:path.row];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        _endIndex = path;
    }
}

#pragma mark - touchMovePoiView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    UITouch *touch = [touches anyObject];
    if (touch.view.tag == 10) {
        _flag = YES;
    }else{
        _flag = NO;
    }
    
    _pointBegin = [touch locationInView:_poiView];
   [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_flag) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPositon = [touch locationInView:_poiView];
    CGPoint viewPositon = _poiView.center;

    float offsetX = currentPositon.x - _pointBegin.x;
    float offsetY = currentPositon.y - _pointBegin.y;
    [_poiView setCenter:CGPointMake(viewPositon.x + offsetX, viewPositon.y + offsetY)];
    
    [self calculateHeight];
    if (viewPositon.y > (_tableView.center.y - _tableView.bounds.size.height / 2) && viewPositon.y < _height ) {
        NSIndexPath *fristPath = [_tableView indexPathForCell:_tableView.visibleCells[0]];
        
        NSIndexPath *path = [_tableView indexPathForRowAtPoint:CGPointMake(_poiView.center.x , _poiView.center.y - 175)];
        
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:fristPath.row + path.row  inSection:0];
        if (_tempIndex.row != 100 && _tempIndex.row < _dataArray.count - 1 && _tempIndex.row != lastPath.row ) {
            [self addSpace:_tempIndex];
        }
        if (lastPath.row != _tempIndex.row && lastPath.row < _dataArray.count ) {
            [self addSpace:lastPath];
            _tempIndex = lastPath;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint viewPositon = _poiView.center;
    CGRect rect = [self.tableView rectForRowAtIndexPath:_endIndex];
    CGPoint newPositon = [_poiView.superview convertPoint:viewPositon toView:_tableView];
    [self calculateHeight];
    
    if (viewPositon.y > (_tableView.center.y - _tableView.bounds.size.height / 2) && viewPositon.y < _height ) {
        _poiView.center = newPositon;
        [_tableView addSubview:_poiView];
        PoiInfo *newPoi = [[PoiInfo alloc] init];
                        newPoi.addCount = _addCount;
                        newPoi.number = _number;
        NSDictionary *dic = @{@"Cell": @"newCell",@"isAdd":@(NO),@"poi":newPoi};
        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
        NSDictionary *oldDic = _dataArray[_endIndex.row - 1];
        if ([[oldDic objectForKey:@"Cell"] isEqualToString:@"mainCell"]) {

            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
            [dic setValue:@(NO) forKey:@"isAdd"];
            _dataArray[_endIndex.row - 1] = dic;
        }
        if ([[oldDic objectForKey:@"Cell"] isEqualToString:@"newCell"]) {
           
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldDic];
            [dic setValue:@(NO) forKey:@"isAdd"];
            _dataArray[_endIndex.row - 1] = dic;
        }
        _dataArray[_endIndex.row] = mdic;
        
        [UIView animateWithDuration:0.40f animations:^{
           [_poiView setFrame:CGRectMake(rect.origin.x, rect.origin.y, [UIScreen mainScreen].bounds.size.width, _poiView.frame.size.height)];
            _poiView.transform = CGAffineTransformIdentity;
            _poiView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[_endIndex] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView insertRowsAtIndexPaths:@[_endIndex] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            _lastInsertIndex = _endIndex;
            [_poiView removeFromSuperview];
            _poiView = nil;
            NSMutableString *mstr = [NSMutableString stringWithString:_popText.text];
            [mstr replaceCharactersInRange:NSMakeRange(1, 1) withString:[NSString stringWithFormat:@"%ld",_addCount]];
            _popText.text = mstr;
            _popText.hidden = NO;
        }];
    }
}

#pragma mark - shakeAnimation
//进入页面的poiView抖动动画
- (void)shakePoiView{
    double delayTime = 2.5;
    dispatch_time_t shakeTime = dispatch_time(DISPATCH_TIME_NOW, delayTime);
    dispatch_after(shakeTime, dispatch_get_main_queue(), ^{
        [self poiViewAnimation:_poiView];
    });
}

- (void)poiViewAnimation:(UIView *)view{
    CALayer *layer = view.layer;
    CGPoint position = layer.position;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation = [animation animationWithPosition:position];
    [layer addAnimation:animation forKey:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
