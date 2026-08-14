128 TAB: [fp#]                         \ decoder for fp#
1 ' [fp#]  ASCII E  ASCII D  install
1 ' [fp#]  ASCII e  ASCII d  install
2 ' [fp#]  ASCII 9  ASCII 0  install
3 ' [fp#]  ASCII +  +  C!
3 ' [fp#]  ASCII -  +  C!
4 ' [fp#]  ASCII .  +  C!

: #err   CRT       \ restore normal output
       ." Not a correctly formed fp#" ABORT   ;  \ fp# error handler

5 WIDE FSM: (fp#)
\ input:     |  other  |   dDeE    
|   digit  | + or -  |    dp    |
\ state:     -------------------------------------------------------
   ( 0 )       NOOP >6    NOOP >6     1+  >0    NOOP >6   1+     >1
   ( 1 )       NOOP >6    1+   >2     1+  >1    #err >6   #err   >6
   ( 2 )       NOOP >6    #err >6    NOOP >4    1+   >3   #err   >6
   ( 3 )       NOOP >6    #err >6     1+  >4    #err >6   #err   >6
   ( 4 )       NOOP >6    #err >6     1+  >5    #err >6   #err   >6
   ( 5 )       NOOP >6    #err >6    #err >6    #err >6   #err
   >6 ;

: skip-  DUP C@  ASCII - =  -  ;            \ skip a leading -
\ Environmental dependency: assumes "true" is -1

: <fp#>   ( $end $beg -- f)
         0 state< (fp#) !                   \ initialize state
         skip-                              \ ignore leading - sign
     1-  BEGIN   1+  DUP C@  [fp#]  (fp#)   \ run fsm
                 DDUP  <                    \ $end < $beg ?
                 state< (fp#) @   6 =  OR   \ terminated by error ?
         UNTIL   DDROP                
      \ clean up
         state< (fp#) @   6 <   ;           \ leave flag
