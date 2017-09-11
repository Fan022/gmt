#!/bin/bash
#               GMT EXAMPLE 47
#               $Id$
#
# Purpose:      Illustrate use of gmtregress with different norms and types
# GMT modules:  gmtregress, psxy, pstext, subplot
# Unix progs:	rm
#

# Because all panels are almost identical we make a bash function that plots
# one panel.  It takes a few options that differ between panels.

export GMT_PPID=$$

function plot_one { # First 3-4 args are: -E -N -c [-Barg]
  gmt psxy -B+ghoneydew${4} data.txt -Sc0.05i -Gblue $3
  gmt psxy giants.txt -Sc0.05i -Gred   -N
  gmt psxy giants.txt -Sc0.1i  -W0.25p -N
  gmt regress data.txt -Fxm $1 $2 -T2.85/5.25/0.1 | gmt psxy -W2p	
}

gmt begin ex47 ps
  gmt which -Gl @hertzsprung-russell.txt
  # Allow outliers (commented out by #) to be included in the analysis:
  sed -e s/#//g hertzsprung-russell.txt > data.txt
  # Identify the red giants (outliers)
  grep '#' hertzsprung-russell.txt | sed -e s/#//g > giants.txt
  gmt subplot begin 4x3 -M0p -Fs2i/2i -R2.85/5.25/3.9/6.3 -JX-2i/2i -SRl+l"Log light intensity" -SCb+l"Log temperature"+tc -Bwesn -Bafg
  # L1 regressions
  plot_one -Ey -N1 -c1,1 +tL@-1@-
  plot_one -Er -N1 -c2,1
  plot_one -Eo -N1 -c3,1
  plot_one -Ex -N1 -c4,1
  #L2 regressions
  plot_one -Er -N2 -c1,2 +tL@-2@- 
  plot_one -Eo -N2 -c2,2
  plot_one -Ex -N2 -c3,2
  plot_one -Ey -N2 -c4,2
  #LMS regressions - also add labels on right side
  plot_one -Er -Nr -c1,3 +tLMS
  echo "Y ON X" | gmt pstext -F+cRM+jTC+a90 -N -Dj0.2i
  plot_one -Eo -Nr -c2,3
  echo "X ON Y" | gmt pstext -F+cRM+jTC+a90 -N -Dj0.2i
  plot_one -Ex -Nr -c3,3
  echo "ORTHOGONAL" | gmt pstext -F+cRM+jTC+a90 -N -Dj0.2i
  plot_one -Ey -Nr -c4,3
  echo "REDUCED MAJOR AXIS" | gmt pstext -F+cRM+jTC+a90 -N -Dj0.2i
  gmt subplot end
gmt end
rm -f data.txt giants.txt hertzsprung-russell.txt
