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

open LecteurDeFichier2012,"<input2012.txt" or die "E/S : $!\n";
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
my $PqVoteIdx2012 = 3;
my $PlqVoteIdx2012 = 2;
my $CaqVoteIdx2012 = 6;
my $QsVoteIdx2012 = 7;
my $PqVoteIdx2010  = 3;
my $PlqVoteIdx2010 = 1;
my $CaqVoteIdx2010 = 0;
my $QsVoteIdx2010  = 4;

my $PourcentageVotesPQ2012 = 0;
my $PourcentageVotesPLQ2012 = 0;
my $PourcentageVotesCAQ2012 = 0;
my $PourcentageVotesQS2012 = 0;
my $PourcentageAbst2012 = 0;

while (my $Ligne = <LecteurDeFichier2012>)
{
   if($Ligne =~ /^(.+);(\d+\.\d+);(\d+);(.+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+);(\d+)/)
   {
      my @VoteArr = ($5,$6,$7,$8,$9,$10,$11,$12);
      my $SectionId = $3;
      my $TotalVotes = 0;
      my $NbElecteursInscrits = $4;
      for(my $i = 0; $i < 8; ++$i)
      {
         $TotalVotes += $VoteArr[$i];
      }
      
      if($TotalVotes ne 0)
      {      
         $PourcentageVotesPQ2012 = $VoteArr[$PqVoteIdx2012]/$NbElecteursInscrits;
         $PourcentageVotesPLQ2012 = $VoteArr[$PlqVoteIdx2012]/$NbElecteursInscrits;
         $PourcentageVotesCAQ2012 = $VoteArr[$CaqVoteIdx2012]/$NbElecteursInscrits;
         $PourcentageVotesQS2012 = $VoteArr[$QsVoteIdx2012]/$NbElecteursInscrits;
         $PourcentageAbst2012 = ($NbElecteursInscrits - $TotalVotes)/$NbElecteursInscrits;
      }
      else
      {
         $PourcentageVotesPQ2012 = 0;
         $PourcentageVotesPLQ2012 = 0;
         $PourcentageVotesCAQ2012 = 0;
         $PourcentageVotesQS2012 = 0;
         $PourcentageAbst2012 = 0;
      }
      
      my $PourcentageVotesPQ2010 = 0;
      my $PourcentageVotesPLQ2010 = 0;
      my $PourcentageVotesCAQ2010 = 0;
      my $PourcentageVotesQS2010 = 0;
      my $PourcentageAbst2010 = 0;
      open LecteurDeFichier2010,"<input2010.txt" or die "E/S : $!\n";
      while (my $Ligne = <LecteurDeFichier2010>)
      {
         if($Ligne =~ /^(.+);(\d+\.\d+);($SectionId);(.+);(\d+);(\d+);(\d+);(\d+);(\d+);\d+;\d+/)
         {
            my @VoteArr2010 = ($5,$6,$7,$8,$9);
            my $TotalVotes2010 = 0;
            my $NbElecteursInscrits2010 = $4;
            for(my $i = 0; $i < 5; ++$i)
            {
               $TotalVotes2010 += $VoteArr2010[$i];
            }
            
            if($TotalVotes2010 ne 0)
            {      
               $PourcentageVotesPQ2010 = $VoteArr2010[$PqVoteIdx2010]/$NbElecteursInscrits2010;
               $PourcentageVotesPLQ2010 = $VoteArr2010[$PlqVoteIdx2010]/$NbElecteursInscrits2010;
               $PourcentageVotesCAQ2010 = $VoteArr2010[$CaqVoteIdx2010]/$NbElecteursInscrits2010;
               $PourcentageVotesQS2010 = $VoteArr2010[$QsVoteIdx2010]/$NbElecteursInscrits2010;
               $PourcentageAbst2010 = ($NbElecteursInscrits2010 - $TotalVotes2010)/$NbElecteursInscrits2010;               
            }
            else
            {
               $PourcentageVotesPQ2010 = 0;
               $PourcentageVotesPLQ2010 = 0;
               $PourcentageVotesCAQ2010 = 0;
               $PourcentageVotesQS2010 = 0;
               $PourcentageAbst2010 = 0;
            }
         }
      }
      close LecteurDeFichier2010;
      
      
      
      my $Delta = $PourcentageVotesQS2012 - $PourcentageVotesQS2010;      

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
            
            my $PourcentageVotesStrPq2012 = sprintf("%.3f", $PourcentageVotesPQ2012);
            my $PourcentageVotesStrPlq2012 = sprintf("%.3f", $PourcentageVotesPLQ2012);
            my $PourcentageVotesStrCaq2012 = sprintf("%.3f", $PourcentageVotesCAQ2012);
            my $PourcentageVotesStrQs2012 = sprintf("%.3f", $PourcentageVotesQS2012);
            my $PourcentageStrAbst2012 = sprintf("%.3f", $PourcentageAbst2012);
            
            my $PourcentageVotesStrPq2010 = sprintf("%.3f", $PourcentageVotesPQ2010);
            my $PourcentageVotesStrPlq2010 = sprintf("%.3f", $PourcentageVotesPLQ2010);
            my $PourcentageVotesStrCaq2010 = sprintf("%.3f", $PourcentageVotesCAQ2010);
            my $PourcentageVotesStrQs2010 = sprintf("%.3f", $PourcentageVotesQS2010);  
            my $PourcentageStrAbst2010 = sprintf("%.3f", $PourcentageAbst2010);          
            
            print RedacteurKML "\t<Placemark><name>$SectionId</name><description>2010->2012\n$PourcentageVotesStrPq2010->$PourcentageVotesStrPq2012 pour le PQ\n$PourcentageVotesStrPlq2010->$PourcentageVotesStrPlq2012 pour le PLQ\n$PourcentageVotesStrCaq2010->$PourcentageVotesStrCaq2012 pour la CAQ\n$PourcentageVotesStrQs2010->$PourcentageVotesStrQs2012 pour QS\n$PourcentageStrAbst2010->$PourcentageStrAbst2012 Abst\n</description><styleUrl>#$StyleToUse</styleUrl><Polygon><tessellate>1</tessellate><outerBoundaryIs><LinearRing><coordinates>$1</coordinates></LinearRing></outerBoundaryIs></Polygon></Placemark>\n";
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
close LecteurDeFichier2012;
