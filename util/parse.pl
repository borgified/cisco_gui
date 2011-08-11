#!/usr/bin/perl -w

use Switch;

open(INPUT,"S-USRC-CORE01.Config.Current.Running.txt");

my $interface_stanza=0;

while(defined(my $line = <INPUT>)){
	
	if($line=~/interface GigabitEthernet\d+\/\d+/){
		$interface_stanza=1;
		$blade=0;$port=0;$description="";@switchport=();$speed=0;
	}

	if($interface_stanza){
#we're inside interface stanza
		switch($line){
			case /interface GigabitEthernet\d+\/\d+/ {
				$line=~/interface GigabitEthernet(\d+)\/(\d+)/;$blade=$1; $port=$2;}
			case /\sdescription/ {
				$line=~/\sdescription (.*)/; $description=$1; }
			#case /\sswitchport (.*)/ 						{ push(@switchport,$1); }
			#case /\sspeed (.*)/ 							{ $speed=$1;}
			else											{ print "ignored: $line"; }	
		}
	}


	if($line=~/^!\r$/){
#we just ended a stanza
		if($interface_stanza){

			print "blade: $blade  port: $port\n";
			print "description: $description\n";
			print "switchport: @switchport\n";
			print "speed: $speed\n";

			print "end of interface stanza\n";
			$interface_stanza=0;

		}else{
			print "some stanza ended but not interface\n";
		}
	}

}
