//
//  ChessBoard.m
//  MyChess
//
//  Created by Admin on 10/12/17.
//  Copyright © 2017 dvphu. All rights reserved.
//

#import "ChessBoard.h"
#import "King.h"
#import "Queen.h"
#import "Bishop.h"
#import "Knight.h"
#import "Rook.h"
#import "Pawn.h"
#import "Checker.h"
#import "Movement.h"

@implementation ChessBoard {
    BaseChess *originChess;
    OnMovedState stateEmitter;
//    Checker *_checker;
    BaseChess *upperKing;
    BaseChess *belowKing;
    NSMutableArray *_positionsChanged;

    int originPosition;

    NSMutableArray *movements;
}
- (id)init {
    self = [super init];
    if (self) {
        _checker = [[Checker alloc] initWithBoard:self];
        _chessList = [self createChesses];
        _turn_by_team = BELOW_TEAM;
        _positionsChanged = [[NSMutableArray alloc] init];
        movements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setOnChessMovedStatus:(OnMovedState)state {
    stateEmitter = state;
}

- (NSMutableArray *)createChesses {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    BaseChess *upperLeftRook = [[Rook alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(0, 0)];
    [list addObject:upperLeftRook];
    [list addObject:[[Knight alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(1, 0)]];
    [list addObject:[[Bishop alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(2, 0)]];
    [list addObject:[[Queen alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(3, 0)]];
    upperKing = [[King alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(4, 0)];
    [list addObject:upperKing];
    [list addObject:[[Bishop alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(5, 0)]];
    [list addObject:[[Knight alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(6, 0)]];
    BaseChess *upperRightRook = [[Rook alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(7, 0)];
    [list addObject:upperRightRook];

    for (int col = 0; col < 8; col++) {
        [list addObject:[[Pawn alloc] initWithBoard:self team:UPPER_TEAM location:LOCATION(col, 1)]];
    }
    for (int i = 16; i < 48; i++) {
        [list addObject:[NSNull null]];
    }
    for (int col = 0; col < 8; col++) {
        [list addObject:[[Pawn alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(col, 6)]];
    }

    BaseChess *belowLeftRook = [[Rook alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(0, 7)];
    [list addObject:belowLeftRook];
    [list addObject:[[Knight alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(1, 7)]];
    [list addObject:[[Bishop alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(2, 7)]];
    [list addObject:[[Queen alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(3, 7)]];
    belowKing = [[King alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(4, 7)];
    [list addObject:belowKing];
    [list addObject:[[Bishop alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(5, 7)]];
    [list addObject:[[Knight alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(6, 7)]];
    BaseChess *belowRightRook = [[Rook alloc] initWithBoard:self team:BELOW_TEAM location:LOCATION(7, 7)];
    [list addObject:belowRightRook];

    [(King *) upperKing setLeftRook:upperLeftRook andRightRook:upperRightRook];
    [(King *) belowKing setLeftRook:belowLeftRook andRightRook:belowRightRook];
    return list;
}

- (BOOL)isEmptyAtLocation:(Location *)location {
    if (![location isValid]) return false;
    return _chessList[[location toIndex]] == (id) [NSNull null];
}

- (BOOL)hasEnemyAtLocation:(Location *)location myTeam:(int)myTeam {
    if (![location isValid]) return false;
    BaseChess *enemy = _chessList[[location toIndex]];
    return enemy != (id) [NSNull null] && [enemy team] != myTeam;
}

- (BaseChess *)chessAtLocation:(Location *)location {
    if (![location isValid]) return nil;
    BaseChess *chess = _chessList[[location toIndex]];
    return chess;
}

- (void)onDeselectedChess:(int)position {
    originChess = nil;
}

- (void)onMoveChessToPosition:(int)destinationPos {
    State state = Keep;
    if ([originChess moveToLocation:LOCATION_BY_INDEX(destinationPos)]) {
        state |= Move;

        //Eat
        if ([self hasEnemyAtLocation:LOCATION_BY_INDEX(destinationPos) myTeam:originChess.team]) {
            state |= Eat;
        }
        //Call move chess to destination
        [self changeGameTurn];

        //Check
        [_checker setLastEnemyMoved:originChess];
        if ([_checker isCheck]) {
            state |= Check;
            NSLog(@"Checked");
            if (originChess.team == UPPER_TEAM) {
                ((King *) belowKing).onCheck = true;
                _kingOnChecked = BELOW_TEAM;
            } else {
                ((King *) upperKing).onCheck = true;
                _kingOnChecked = UPPER_TEAM;
            }
            //Checkmate
            if ([_checker isCheckmate]) {
                state |= Checkmate;
                NSLog(@"Checkmate");
                _game_end = true;
            }
        } else{
            if (originChess.team == UPPER_TEAM) {
                ((King *) belowKing).onCheck = false;
                _kingOnChecked = -1;
            } else {
                ((King *) upperKing).onCheck = false;
                _kingOnChecked = -1;
            }
        }
//        //Pawn promotion
        if ([originChess isKindOfClass:[Pawn class]]) {
            if ([(Pawn *) originChess isEnPassant]) {
                state |= Pawn_EnPassant;
                int defeatEnemyAtIndex = [(Pawn *) originChess doEnPassant];

                [self doEnPassantToPawnIndex:defeatEnemyAtIndex];

            } else if ([(Pawn *) originChess isCanPromotion]) {
                state |= Pawn_Promotion;
                [(Pawn *) originChess setPromotionTo:[Queen class]];
            }
        }
        //Check Castling
        if ([originChess isKindOfClass:[King class]]) {
            if ([(King *) originChess doCastling]) {
                state |= Castling;

            }
        }
    }

    [self emitStateToView:state];
    //    [self printChessBoard];
}

- (void)doReset {

}

- (void)doRedo {

}

- (void)doUndo {
    Movement *lastMove = [movements lastObject];
    BaseChess *current = lastMove.B;
    BaseChess *pre = lastMove.A;
    NSLog(@"%@ - %@", current, pre);
    _chessList[lastMove.from] = pre;
    _chessList[lastMove.to]= current;
    [self setPositionChanged:lastMove.from];
    [self setPositionChanged:lastMove.to];

    [self emitStateToView:Move];

    [movements removeLastObject];
    [self printChessBoard];
}

-(void) emitStateToView:(State) state{
    stateEmitter(state, _positionsChanged);
    [_positionsChanged removeAllObjects];
    originChess = nil;
    originPosition = -1;
}

- (void)onSelectedChess:(int)position {
    originPosition = position;
    originChess = _chessList[position];
    for(Location *loc in [originChess getValidLocations]){
        NSLog(@"Location (%d, %d)", loc.x, loc.y);
    }
//    stateEmitter(Keep);
}

- (void)setPositionChanged:(int)position {
    [_positionsChanged addObject:@(position)];
}

- (void)moveChess:(BaseChess *)chess from:(int)origin to:(int)destination {
    _chessList[destination] = chess;
    _chessList[origin] = [NSNull null];
    [self setPositionChanged:origin];
    [self setPositionChanged:destination];
    NSLog(@"Move chess %@", NSStringFromClass([chess class]));
    [movements addObject:[[Movement alloc] initWithA:chess B:(id) [NSNull null] from:origin to:destination]];
}

- (void)doEnPassantToPawnIndex:(int)index {
    _chessList[index] = [NSNull null];
    [self setPositionChanged:index];
}

- (void)printChessBoard {
    for (int i = 0; i < COLLUMN_SIZE; i++) {
        BaseChess *chess1 = _chessList[0 + i * 8];
        BaseChess *chess2 = _chessList[1 + i * 8];
        BaseChess *chess3 = _chessList[2 + i * 8];
        BaseChess *chess4 = _chessList[3 + i * 8];
        BaseChess *chess5 = _chessList[4 + i * 8];
        BaseChess *chess6 = _chessList[5 + i * 8];
        BaseChess *chess7 = _chessList[6 + i * 8];
        BaseChess *chess8 = _chessList[7 + i * 8];

        NSLog(@"%@\t%@\t%@\t%@\t%@\t%@\t%@\t%@",
                chess1 != (id) [NSNull null] ? [chess1 toString] : @"   *    ",
                chess2 != (id) [NSNull null] ? [chess2 toString] : @"   *    ",
                chess3 != (id) [NSNull null] ? [chess3 toString] : @"   *    ",
                chess4 != (id) [NSNull null] ? [chess4 toString] : @"   *    ",
                chess5 != (id) [NSNull null] ? [chess5 toString] : @"   *    ",
                chess6 != (id) [NSNull null] ? [chess6 toString] : @"   *    ",
                chess7 != (id) [NSNull null] ? [chess7 toString] : @"   *    ",
                chess8 != (id) [NSNull null] ? [chess8 toString] : @"   *    ");
    }
}

//Function call when king moved
- (void)setKing:(BaseChess *)king {
    [_checker setKing:king];
}

- (void)changeGameTurn {
    _turn_by_team = 1 - _turn_by_team;
    _turn_counter += _turn_by_team == 0 ? 0 : 1;
    NSLog(@"Turn %d", _turn_counter);
}

@end
