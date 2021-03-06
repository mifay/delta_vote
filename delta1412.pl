#!/usr/bin/perl

# Copyright 2015 Michael Fayad
#
# This file is part of delta_vote.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

open LecteurDeFichier2014,"<input2014.txt" or die "E/S : $!\n";
open LecteurKmlHead,"<KmlHead.txt" or die "E/S : $!\n";
open LecteurKmlStyles,"<KmlStyles.txt" or die "E/S : $!\n";
open LecteurKmlFoot,"<KmlFoot.txt" or die "E/S : $!\n";
open RedacteurKML,">output.kml" or die $!;

while (my $Ligne = <LecteurKmlHead>)
{
   print RedacteurKML "$Ligne";
}

while (my $Ligne = <LecteurKmlStyles>)
{
   print RedacteurKML "$Ligne";
}

# Styles KML
my $Delta0a3    = "delta0to3_principal";
my $Delta4a6    = "delta4to6_principal";
my $Delta7a9      = "delta7to9_principal";
my $Delta10a12  = "delta10to12_principal";
my $Delta13plus  = "delta13plus_principal";
my $NegativeDelta0a3     = "negativedelta0to3_principal";
my $NegativeDelta4a6     = "negativedelta4to6_principal";
my $NegativeDelta7a9     = "negativedelta7to9_principal";
my $NegativeDelta10a12   = "negativedelta10to12_principal";
my $NegativeDelta13plus  = "negativedelta13plus_principal";

# 0 based indexes
my $PqVoteIdx2014 = 0;
my $PlqVoteIdx2014 = 4;
my $CaqVoteIdx2014 = -1;
my $QsVoteIdx2014 = 5;
my $PqVoteIdx2012  = 3;
my $PlqVoteIdx2012 = 2;
my $CaqVoteIdx2012 = 6;
my $QsVoteIdx2012  = 7;

my $PourcentageVotesPQ2014 = 0;
my $PourcentageVotesPLQ2014 = 0;
my $PourcentageVotesCAQ2014 = 0;
my $PourcentageVotesQS2014 = 0;
my $PourcentageAbst2014 = 0;

while (my $Ligne = <LecteurDeFichier2014>)
{
   if($Ligne =~ /al, v;\d+;;(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);\d+;/)
   {
      my @VoteArr = ($3,$4,$5,$6,$7,$8,$9);
      my $SectionId = $1;
      my $TotalVotes = $10;
      my $NbElecteursInscrits = $2;

      if($TotalVotes ne 0)
      {      
         $PourcentageVotesPQ2014 = $VoteArr[$PqVoteIdx2014]/$NbElecteursInscrits;
         $PourcentageVotesPLQ2014 = $VoteArr[$PlqVoteIdx2014]/$NbElecteursInscrits;
         $PourcentageVotesCAQ2014 = 0;
         $PourcentageVotesQS2014 = $VoteArr[$QsVoteIdx2014]/$NbElecteursInscrits;
         $PourcentageAbst2014 = ($NbElecteursInscrits - $TotalVotes)/$NbElecteursInscrits;
      }
      else
      {
         $PourcentageVotesPQ2014 = 0;
         $PourcentageVotesPLQ2014 = 0;
         $PourcentageVotesCAQ2014 = 0;
         $PourcentageVotesQS2014 = 0;
         $PourcentageAbst2014 = 0;
      }
      
      my $PourcentageVotesPQ2012 = 0;
      my $PourcentageVotesPLQ2012 = 0;
      my $PourcentageVotesCAQ2012 = 0;
      my $PourcentageVotesQS2012 = 0;
      my $PourcentageAbst2012 = 0;
      open LecteurDeFichier2012,"<input2012.txt" or die "E/S : $!\n";
      while (my $Ligne2 = <LecteurDeFichier2012>)
      {
         if($Ligne2 =~ /^(.+);(\d+\.\d+);($SectionId);(.+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+)/)
         {
            my @VoteArr2 = ($5,$6,$7,$8,$9,$10,$11,$12);
            my $SectionId2 = $3;
            my $TotalVotes2 = 0;
            my $NbElecteursInscrits2 = $4;
            for(my $i = 0; $i < 8; ++$i)
            {
               $TotalVotes2 += $VoteArr2[$i];
            }
      
            if($4 ne 0)
            {
               $PourcentageVotesPQ2012 = $VoteArr2[$PqVoteIdx2012]/$NbElecteursInscrits2;
               $PourcentageVotesPLQ2012 = $VoteArr2[$PlqVoteIdx2012]/$NbElecteursInscrits2;
               $PourcentageVotesCAQ2012 = $VoteArr2[$CaqVoteIdx2012]/$NbElecteursInscrits2;
               $PourcentageVotesQS2012 = $VoteArr2[$QsVoteIdx2012]/$NbElecteursInscrits2;
               $PourcentageAbst2012 = ($NbElecteursInscrits2 - $TotalVotes2)/$NbElecteursInscrits2;
            }
            else
            {
               $PourcentageVotesPQ2012 = 0;
               $PourcentageVotesPLQ2012 = 0;
               $PourcentageVotesCAQ2012 = 0;
               $PourcentageVotesQS2012= 0;
               $PourcentageAbst2012 = 0;
            }
         }
      }
      close LecteurDeFichier2012;
      
      
      
      my $Delta = $PourcentageVotesPLQ2014 - $PourcentageVotesPLQ2012;      

      open LecteurGPS,"<GpsSv.txt" or die "E/S : $!\n";
      
      while (my $Ligne = <LecteurGPS>)
      {
         if($Ligne =~ /^$SectionId,\t\t\t\t\t\t\t\t\t(.+)$/)
         {
            my $StyleToUse = $Delta0a3; 
            if ($Delta < -0.13)
            {
               $StyleToUse = $NegativeDelta13plus;
            }
            elsif ($Delta < -0.10)
            {
               $StyleToUse = $NegativeDelta10a12;
            }                  
            elsif ($Delta < -0.07)
            {
               $StyleToUse = $NegativeDelta7a9;
            }     
            elsif ($Delta < -0.04)
            {
               $StyleToUse = $NegativeDelta4a6;
            }     
            elsif ($Delta < 0)
            {
               $StyleToUse = $NegativeDelta0a3;
            }     
            elsif ($Delta > 0.13)
            {
               $StyleToUse = $Delta13plus;
            }     
            elsif ($Delta > 0.10)
            {
               $StyleToUse = $Delta10a12;
            }     
            elsif ($Delta > 0.07)
            {
               $StyleToUse = $Delta7a9;
            }               
            elsif ($Delta > 0.04)
            {
               $StyleToUse = $Delta4a6;
            }     
            else
            {
               $StyleToUse = $Delta0a3;
            }                                   
            
            my $PourcentagesVotesStrPq2014 = sprintf("%.3f", $PourcentageVotesPQ2014);
            my $PourcentagesVotesStrPlq2014 = sprintf("%.3f", $PourcentageVotesPLQ2014);
            my $PourcentagesVotesStrCaq2014 = sprintf("%.3f", $PourcentageVotesCAQ2014);
            my $PourcentagesVotesStrQs2014 = sprintf("%.3f", $PourcentageVotesQS2014);
            my $PourcentagesStrAbst2014 = sprintf("%.3f", $PourcentageAbst2014);
            
            my $PourcentageVotesStrPq2012 = sprintf("%.3f", $PourcentageVotesPQ2012);
            my $PourcentageVotesStrPlq2012 = sprintf("%.3f", $PourcentageVotesPLQ2012);
            my $PourcentageVotesStrCaq2012 = sprintf("%.3f", $PourcentageVotesCAQ2012);
            my $PourcentageVotesStrQs2012 = sprintf("%.3f", $PourcentageVotesQS2012);  
            my $PourcentageStrAbst2012 = sprintf("%.3f", $PourcentageAbst2012);          
            
            print RedacteurKML "\t<Placemark><name>$SectionId</name><description>2012->2014\n$PourcentageVotesStrPq2012->$PourcentagesVotesStrPq2014 pour le PQ\n$PourcentageVotesStrPlq2012->$PourcentagesVotesStrPlq2014 pour le PLQ\n$PourcentageVotesStrCaq2012->$PourcentagesVotesStrCaq2014 pour la CAQ\n$PourcentageVotesStrQs2012->$PourcentagesVotesStrQs2014 pour QS\n$PourcentageStrAbst2012->$PourcentagesStrAbst2014 Abst\n</description><styleUrl>#$StyleToUse</styleUrl><Polygon><tessellate>1</tessellate><outerBoundaryIs><LinearRing><coordinates>$1</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>\n";
         }
      }
      
      $SectionId++;
      
      close LecteurGPS;
   }
}

while (my $Ligne = <LecteurKmlFoot>)
{
   print RedacteurKML "$Ligne";
}

close LecteurKmlHead;
close LecteurKmlStyles;
close LecteurKmlFoot;
close RedacteurKML;
close LecteurDeFichier2014;
