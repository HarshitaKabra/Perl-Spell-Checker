#!/bin/perl

use strict;
use warnings;

use List::Util qw(min);
my %cache;
sub leven {
        my ($s, $t) = @_;
        return length($t) if !$s;
        return length($s) if !$t;
 
	 $cache{$s}{$t} //= # try commenting out this line to notice speed difference
        do {
                my ($s1, $t1) = (substr($s, 1), substr($t, 1));
 
                (substr($s, 0, 1) eq substr($t, 0, 1))
                        ? leven($s1, $t1)
                        : 1 + min(leven($s1, $t1),
                                  leven($s,  $t1),
                                  leven($s1, $t ));
        };
}


open(MFILE, "dictionary.txt")  or die "Can't open dictionary.txt: $!";

# Initialize dictionary hash table
my %dict = ();
my @array = <MFILE>;
my @values = ();
my $i=0;
while($i < $#array){
	chomp $array[$i];
	my $hs=$array[$i];
	my @chars=split("",$hs);
	my $character=$chars[0];
	if($i != 0){
		my $hs1=$array[$i-1];
		my @pre_char=split("",$hs1);
		my $char=$pre_char[0];
		
		my $res= $character eq $char;
		if($res != 1){
			$dict{$char} = [ @values ];
			@values = ();
		}
	}
	push @values, $array[$i];
	
	if($i == ($#array-1)){
		$dict{$character} = [ @values ];
	}
	$i++;
	
}
close MFILE or die "$!";

print "Enter the text: \n";
my $text = <STDIN>;
chomp $text;
$text = lc $text;

my @text=split(/[. ]+/,$text);

my %list2=();
my @values1=();


OUT: foreach my $word (@text){
	my @pree=split("",$word);
	my $fir=$pree[0];
IN: foreach my $q (@{$dict{$fir}}){
	$q =~ s/[^\w]//g;
	my $res8 = $q eq $word;
	if($res8 != 1){
		if(leven($q,$word) <= 2){
			push @values1, $q;
		}
		
		
	}else{
		@values1=();
		
		next OUT;
	}
}

	$list2{$word} = [ @values1 ];
	
	@values1 = ();
}


my $h;
my @ar1=();
if(!%list2){
	print "No misspelled word\n";
}


else{
	print "The misspled words are:\n";
	foreach my $keys (keys %list2){
		print "$keys : \n";
		my $count=1;
		
		my $len = length $keys;
		
		foreach my $r (@{$list2{$keys}}){
			my $thislen = length $r;
			my $difflen = $len - $thislen;
			if($difflen eq "0"){
				if($count ne "1"){
						
			
					print "$count";
					print " : $r\n";
					push(@ar1,($r));
					$count++;
					
					
						
				
				}
				else{
					print "Replacements of same length as $keys\n";
					print "$count";
					print " : $r\n";
					push(@ar1,($r));
					$count++;
				
				}
			}
			
		}
		print "\n\n";
		
		$h=$count;
		
		
		foreach my $r (@{$list2{$keys}}){
			my $thislen = length $r;
			my $difflen = $len - $thislen;
			if($difflen gt "0"){
				if($count ne $h){
						
			
					print "$count";
					print " : $r\n";
					$count++;
					push(@ar1,$r);
					
					
				
				}
				else{
					print "Replacements of length smaller than $keys\n";
					print "$count";
					print " : $r\n";
					$count++;
					push(@ar1,$r);
				}
			}
		}
		print "\n\n";
		
		$h=$count;
		
		
		foreach my $r (@{$list2{$keys}}){
			my $thislen = length $r;
			my $difflen = $len - $thislen;
			if($difflen lt "0"){
				if($count ne $h){
						
			
					print "$count";
					print " : $r\n";
					$count++;
					push(@ar1,$r);
					
					
				
				}
				else{
					print "Replacements of length greater than $keys\n\n";
					print "$count";
					print " : $r\n";
					$count++;
					push(@ar1,$r);
				}
			}
		}
		
		print "\n\n";
		
		
		
		
							
			
		if($count ne "1"){
			$count=0;
			
			print "***********************\n";
			print "Enter the number\n";
			
			$h = <STDIN>;
			chomp $h;
			print "***********************\n";
			foreach my $ar1(@ar1){
				$count++;
				
				if($h == $count){
					foreach my $text (@text){
						if($text eq $keys){
							$text = $ar1;
						}
					}
					last;
				}
			}
			@ar1=();
		}
		else{
			print "Can't find a similar word in dictionary ";
		}
	}
}		

print "The modified text is : \n";

foreach (@text){
	print "$_ ";
}	
	
								
				
			 	
	
		
	
	
	



