; FOO.PRO bjoshi 05/12/2001
; bjoshi@geocities.com
; 
; obfuscated IDL code!
;
; USAGE:
; at command prompt, type
;       idl foo.pro
; enjoy :)
;
; WHAT:
; my implementation of the hungry cow algorithm
;
; WHY:
; why not? mess around with the w, l, and s parameters
; to get different speeds/smoothness of scrolling
;

w=0.05 &                     l = 30  $
&  s = 3                     & g='o'+$
'ooooO'+                     'OOOOo'+$
'ooooo'+                     'ooooO'+$
'OOOOo'+                     'ooooO'+$
'OOOOO'+                     'ooooo'+$
'oOOoo'+                     'OOOoo'+$
'Ooooo'+                     'ooOOO'+$
'OOooo'+                     'oooo'  $
 & e='-'+                   '-----'+$
  '-----'+                 '-----'+$
   '-----'+               '-----'+$
    '-----'+             '-----'+$
    '-----'+             '-----'+$
    '-----'+             '-----'+$
   '-----'+               '-----'+$
   '--'   &               f0='(%'+$
   '"\x1B'+               '\x63\'+$
    'x0D\x'+             '0A\x1'+$
     'B[7m' +           '\x1B['+$
      '%dC\x'+         '28  \'+$
       'x29\x'+       '0D\x0'+$
        'A\x1B'+     '[%dC|'+$
         '..|--'+   '\x5C '+$
          '\x2D\'+ 'x4Doo'+$
          '!\x0D'+ '\x0A\'+$
         'x1B[%'+   'dC|\x'+$
       '20 |-'+       '-|\x0'+$
       'D\x0A'+       '\x1B['+$
        '%dC\x'+     '5COO\'+$
         'x2F||'+   '^\x1B'+$
        '[0m\x'+     '0D")' &$
       f1='(%'+       '"\x1B'+$
      '\x63\'+         'x0D\x'+$
      '0A\x1'+         'B[7m' +$
       '\x1B['+       '%dC\x'+$
         '28  \'+   'x29\x'+$
         '0D\x0'+   'A\x1B'+$
         '[%dC|'+   '^^|--'+$
        '\x5C '+     '\x2D\'+$
       'x4Doo'+       '!\x0D'+$
     '\x0A\'+           'x1B[%'+$
   'dC|\x'+               '20 |-'+$
  '-|\x0'+                 'D\x0A'+$
 '\x1B['+                  '%dC\x'+$
'5Coo\'+                    'x2F||'+$
'^\x1B'+                    '[0m\x'+$
 '0D")' &                   while 1$
  do begin                 for h=1$
  ,359,s do begin i=FIX(sin(!DPI $
      *(FLOAT(h)/180))*l)+ l $
       & print, FORMAT=f0,i $
        ,i,i,i & if ((h le $
          90) OR (h ge   $
           270)) then  $
             print,  $
          strmid(e,i-2, $
        /reverse_offset)+ $
      strmid(g,i) else print, $
    e & wait,w & if ((h le 90) $ 
   OR (h ge 270))   then  print, $
   FORMAT=f1,i,i,i,i else print, $
   FORMAT=f0,i,i,i,i  &  if ((h  $
   le  90)  OR (h  ge 270)) then $
   print,    strmid  (e ,  i-2,  $
   /reverse_offset) +strmid(g,i) $
   else    print,  e   &  wait,  w 
