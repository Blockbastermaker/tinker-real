c
c
c     ###################################################
c     ##  COPYRIGHT (C)  2001  by  Jay William Ponder  ##
c     ##              All Rights Reserved              ##
c     ###################################################
c
c     ###############################################################
c     ##                                                           ##
c     ##  subroutine sincos  --  find sine and cosine of an angle  ##
c     ##                                                           ##
c     ###############################################################
c
c
c     "sincos" computes the sine and cosine of an angle value
c     specified in degrees
c
c     translated from a routine of the same name in the Cephes
c     Math Library Release 2.1
c
c
      subroutine sincos (angle,sine,cosine)
      implicit none
      integer ix,xsign
      integer ssign,csign
      real*8 angle,sine,cosine
      real*8 x,y,z,sx,cx,sz,cz
      real*8 table(0:91)
      data table /
     &   0.00000000000000000000d+0, 1.74524064372835128194d-2,
     &   3.48994967025009716460d-2, 5.23359562429438327221d-2,
     &   6.97564737441253007760d-2, 8.71557427476581735581d-2,
     &   1.04528463267653471400d-1, 1.21869343405147481113d-1,
     &   1.39173100960065444112d-1, 1.56434465040230869010d-1,
     &   1.73648177666930348852d-1, 1.90808995376544812405d-1,
     &   2.07911690817759337102d-1, 2.24951054343864998051d-1,
     &   2.41921895599667722560d-1, 2.58819045102520762349d-1,
     &   2.75637355816999185650d-1, 2.92371704722736728097d-1,
     &   3.09016994374947424102d-1, 3.25568154457156668714d-1,
     &   3.42020143325668733044d-1, 3.58367949545300273484d-1,
     &   3.74606593415912035415d-1, 3.90731128489273755062d-1,
     &   4.06736643075800207754d-1, 4.22618261740699436187d-1,
     &   4.38371146789077417453d-1, 4.53990499739546791560d-1,
     &   4.69471562785890775959d-1, 4.84809620246337029075d-1,
     &   5.00000000000000000000d-1, 5.15038074910054210082d-1,
     &   5.29919264233204954047d-1, 5.44639035015027082224d-1,
     &   5.59192903470746830160d-1, 5.73576436351046096108d-1,
     &   5.87785252292473129169d-1, 6.01815023152048279918d-1,
     &   6.15661475325658279669d-1, 6.29320391049837452706d-1,
     &   6.42787609686539326323d-1, 6.56059028990507284782d-1,
     &   6.69130606358858213826d-1, 6.81998360062498500442d-1,
     &   6.94658370458997286656d-1, 7.07106781186547524401d-1,
     &   7.19339800338651139356d-1, 7.31353701619170483288d-1,
     &   7.43144825477394235015d-1, 7.54709580222771997943d-1,
     &   7.66044443118978035202d-1, 7.77145961456970879980d-1,
     &   7.88010753606721956694d-1, 7.98635510047292846284d-1,
     &   8.09016994374947424102d-1, 8.19152044288991789684d-1,
     &   8.29037572555041692006d-1, 8.38670567945424029638d-1,
     &   8.48048096156425970386d-1, 8.57167300702112287465d-1,
     &   8.66025403784438646764d-1, 8.74619707139395800285d-1,
     &   8.82947592858926942032d-1, 8.91006524188367862360d-1,
     &   8.98794046299166992782d-1, 9.06307787036649963243d-1,
     &   9.13545457642600895502d-1, 9.20504853452440327397d-1,
     &   9.27183854566787400806d-1, 9.33580426497201748990d-1,
     &   9.39692620785908384054d-1, 9.45518575599316810348d-1,
     &   9.51056516295153572116d-1, 9.56304755963035481339d-1,
     &   9.61261695938318861916d-1, 9.65925826289068286750d-1,
     &   9.70295726275996472306d-1, 9.74370064785235228540d-1,
     &   9.78147600733805637929d-1, 9.81627183447663953497d-1,
     &   9.84807753012208059367d-1, 9.87688340595137726190d-1,
     &   9.90268068741570315084d-1, 9.92546151641322034980d-1,
     &   9.94521895368273336923d-1, 9.96194698091745532295d-1,
     &   9.97564050259824247613d-1, 9.98629534754573873784d-1,
     &   9.99390827019095730006d-1, 9.99847695156391239157d-1,
     &   1.00000000000000000000d+0, 9.99847695156391239157d-1 /
c
c
c     get the angle value in the range from 0 to 360 degrees
c
      x = angle
      xsign = 1
      if (x .lt. 0.0d0) then
          xsign = -1
          x = -x
      end if
      x = x - 360.0d0*int(x/360.0d0)
c
c     find nearest integer and residual of the angle value
c
      ix = nint(x)
      z = x - dble(ix)
      y = z * z
c
c     look up the sine and cosine of the nearest integer
c
      if (ix .le. 180) then
         ssign = 1
         csign = 1
      else
         ssign = -1
         csign = -1
         ix = ix - 180
      end if
      if (ix .gt. 90) then
         csign = -csign
         ix = 180 - ix
      end if
      sx = table(ix)
      cx = table(90-ix)
      if (ssign .lt. 0)  sx = -sx
      if (csign .lt. 0)  cx = -cx
c
c     find sine and cosine of residual angle to 5 decimal places
c
c     sz = 1.74531263774940077459d-2 * z
c     cz = 1.0d0 - 1.52307909153324666207d-4 * y
c
c     find sine and cosine of residual angle to 11 decimal places
c
c     sz = (-8.86092781698004819918d-7 * y
c    &        + 1.74532925198378577601d-2) * z
c     cz = 1.0d0 - (-3.86631403698859047896d-9 * y
c    &                 + 1.52308709893047593702d-4) * y
c
c     find sine and cosine of residual angle to 17 decimal places
c
      sz = ((1.34959795251974073996d-11 * y
     &        - 8.86096155697856783296d-7) * y
     &           + 1.74532925199432957214d-2) * z
      cz = 1.0d0 - ((3.92582397764340914444d-14 * y
     &                  - 3.86632385155548605680d-9) * y
     &                     + 1.52308709893354299569d-4) * y
c
c     combine the tabulated and calculated parts by trigonometry
c
      sine = sx*cz + cx*sz
      if (xsign .lt. 0)  sine = -sine
      cosine = cx*cz - sx*sz
      return
      end
