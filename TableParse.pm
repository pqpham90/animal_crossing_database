#!/usr/bin/perl
package TableParse;

use strict;
use warnings FATAL => 'all';
use Exporter qw(import);

our @EXPORT_OK = qw(run_parse parse run_parse_pw parse_pw print_array);

sub run_parse {
	my @array = parse (shift);
	print_array (\@array, shift);
}


sub parse {
	my $filename = shift;
	my @data  = ();

	open(my $fh, $filename) or die "Could not open file '$filename' $!";
	while (my $row = <$fh>) {
		chomp $row;

		if (my @match = $row =~ /<td>([\w\s'.&!?\/-]+)<\/td>/ixg) {
			push (@data, \@match);
			# foreach my $x (@match) {
			# 	print "$x"
			# }
			# print "\n";
		}
		# print "$row\n"
	}
	close($fh) or die "can't close $filename: $!";

	return (@data);
}

sub run_parse_pw {
	my @array = parse_pw ('public_works_list');
	print_array (\@array, 24);
}

sub parse_pw {
	my $filename = shift;
	my @public_works = ();

	open(my $fh, $filename) or die "Could not open file '$filename' $!";
	while (my $row = <$fh>) {
		my $match;
		chomp $row;

		if (my @match = $row =~ /...([\w\s'()-]+)\s-\s([0-9,]+)\sBells\s?\(?([\w\s]+)?\)?/ixg) {
			# print "$match[0] $match[1]";
			if ($match[2]) {
				# print "$match[2]\n";
			}
			else {
				$match[2] = "Start";
				# print "\n";
			}

			push (@match, ("F", "T"));
			push (@public_works, \@match)
		}

		if ($row =~ />>>([\w\s'-]+)/ixg) {
			foreach my $public_work (@public_works) {
				if ($1 eq ${$public_work}[0]) {
					${$public_work}[3] = "T";
				}
			}
		}

		if ($row =~ /\+\+\+([\w\s'-()]+)/ixg) {
			foreach my $public_work (@public_works) {
				if ($1 eq ${$public_work}[0]) {
					${$public_work}[4] = "F";
				}
			}
		}
	}
	close($fh) or die "can't close $filename: $!";

	return @public_works;
}


sub print_array {
	my @array = @{my $red = shift};
	my $padding = shift;

	foreach my $row (@array) {
		my $output;
		foreach my $entry (@$row) {
			# print "$entry";
			$output .= sprintf("%-${padding}s", "$entry");
		}
		$output =~ s/\s+$//;
		print "$output\n";
	}
}
