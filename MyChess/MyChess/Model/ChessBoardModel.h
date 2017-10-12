//
//  ChessBoardModel.h
//  MyChess
//
//  Created by Admin on 10/3/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessModel.h"
#import "Constant.h"
#import "InteractionOnChessEvent.h"
#import "GameController.h"

typedef void (^OnChessAdded)(ChessModel*);
@interface ChessBoardModel : NSObject<InteractionOnChessEvent>

@property (nonatomic, strong) NSMutableArray* chessList;
-(void) addChess:(OnChessAdded)onChessAdded atPosition:(int) position;
@end
