\ input:     |  other  |   dDeE    |   digit  | + or -  |    dp    |
\ state:     -------------------------------------------------------
   ( 0 )       NOOP >4    NOOP >4   +mant >0?   NOOP >4   1+     >1
   ( 1 )       NOOP >4    ?1+  >2   +mant >1?   #err >4   #err   >4
   ( 2 )       NOOP >4    #err >4   +exp  >3    1+   >3   #err   >4
   ( 3 )       NOOP >4    #err >4   +exp  >3?   #err >4   #err   >4  ;
