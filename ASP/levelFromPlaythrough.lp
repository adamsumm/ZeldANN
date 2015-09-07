#const width=3.
#const steps=5.
actionpath(s,0,1).
actionpath(x,1,1).
actionpath(e,2,1).
actionpath(x,3,2).
actionpath(b,4,1).
actionpath(t,5,1).

doorpath(n,1,1).
doorpath(n,2,1).
doorpath(n,3,2).
doorpath(n,4,1).
doorpath(n,5,1).



roomTypes(R) :- freeRooms(R).
roomTypes(R) :- restrictedRooms(R).
freeRooms(x;e;ep;p;i;epi;pi).
restrictedRooms(s;b;t;k;ek;pk;epk;eipk).
doorTypes(n;b;l;k;t).
doorsOnlyOnPath(t,bigkey).
noRepeats(s;b;t).


xx(-width..width).
yy(0..width).
stepCount(0..steps).
tile((X,Y)) :- xx(X); yy(Y).
tile((0,-1)).

adj((X1,Y1),(X2,Y2)) :- 
    tile((X1,Y1));
    tile((X2,Y2));
    |X1-X2| + |Y1-Y2| == 1.
   
0 { room(T,R) : roomTypes(R) } 1 :- tile(T).
start((0,-1)).
%3 { room(T,R) : roomTypes(R), tile(T)}.

%0 { door(T0,T1,D) : doorTypes(D) } 1 :- adj(T0,T1) .
{ door(T0,T1,D) : doorTypes(D), room(T0,_), room(T1,_) }.
validDoor(T0,T1) :- door(T0,T1,D), room(T0,_), room(T1,_), adj(T0,T1), D != t.
validDoor(T0,T1) :- door(T0,T1,D), room(T0,_), room(T1,_), D == t, doorpath(D,C,_), chosenPath(T0,_,C).
validDoor(T0,T1) :- door(T0,T1,D), room(T0,_), room(T1,_), D == t, doorpath(D,C,_), chosenPath(T1,_,C).
validDoor(T0,T1) :- door(T0,T1,D), room(T0,_), room(T1,_), D == bigkey, doorpath(D,C,_), chosenPath(T0,_,C).
validDoor(T0,T1) :- door(T0,T1,D), room(T0,_), room(T1,_), D == bigkey, doorpath(D,C,_), chosenPath(T1,_,C).

:- door(T0,T1,_), not validDoor(T0,T1).
:- noRepeats(R), room(T1,R), room(T2,R), T1 != T2.
mismatch(T0,T1) :- door(T0,T1,_), not door(T1,T0,_).
:- mismatch(T0,T1).


%timesSeen(T,0,0)  :- room(T,_).
1 {timesSeen(T,C,RC) :  stepCount(RC)} 1 :- room(T,_),stepCount(C).

timesSeen(T,0,0) :- room(T,_), not start(T).
timesSeen(T,0,1) :- start(T).
timesSeen(T,C1,R1) :- chosenPath(T,_,C1), timesSeen(T,C0,R0), C0 + 1 = C1, R1 = R0 + 1.
timesSeen(T,C1,R1) :- not chosenPath(T,_,C1), timesSeen(T,C0,R0), C0 + 1 = C1, R1 = R0, C1 <= steps.




badRoom(T,R,C,RC,RC1) :- timesSeen(T,C,RC), room(T,R), actionpath(R,C,RC1), RC1 != RC,RC > 0.
:- badRoom(T,R,C,RC,RC1).

chosenPath(T,R,0) :- start(T), room(T,R) ,actionpath(R,0,_).
chosenPath(T1,R1,C1) :- chosenPath(T0,R0,C0), C1 = C0 + 1, actionpath(R1,C1,_), room(T1,R1), door(T0,T1,D), doorpath(D,C1,_).
:- chosenPath(T0,R1,C), chosenPath(T1,R2,C), T0 != T1.

completed :- chosenPath(T,_,steps).
:- not completed.

%reachable(T) :- start(T).
%reachable(T) :- reachable(T0), door(T0,T,D).
%:- not reachable(T), room(T,R).

%notDeadEnd(T) :- room(T,R), door(T,T1,D), doorTypes(D), tile(T1), T1 != T. 
%deadEnd :- room(T,R), R != b, R != t, not notDeadEnd(T).
%:- deadEnd.
#show room/2.
#show chosenPath/3.
#show door/3.