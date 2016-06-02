#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use DBI;
use TableParse qw(parse_pw run_parse_pw);

my $db = 'animal_crossing';
my $host = 'localhost';
my $user = 'User';
my $pass = 'Password';

# DBI->trace(1);
# print "HERE\n";

my $dsn = "DBI:mysql:database=$db;host=$host";
my $dbh = DBI->connect( $dsn, $user, $pass, { RaiseError => 1 }) or die ( "Couldn't connect to database: " . DBI->errstr );

my $drop = "DROP TABLE IF EXISTS public_work;";
my $create = <<'END';
CREATE TABLE public_work (
id int(4) NOT NULL AUTO_INCREMENT,
name varchar(34) NOT NULL,
cost mediumint(6) NOT NULL,
requirement varchar(44) NOT NULL,
permanent char(1) NOT NULL,
countable char(1) NOT NULL,
PRIMARY KEY(id)
);
END

my $run_drop = $dbh->prepare($drop);
my $run_create = $dbh->prepare($create);
$run_drop->execute or die "SQL Error: $DBI::errstr\n";
$run_create->execute or die "SQL Error: $DBI::errstr\n";

my $query = "insert into public_works (name, cost, requirement, permanent, countable) values (?, ?, ?, ?, ?)";
my $statement = $dbh->prepare($query);

my @array = parse_pw ('public_works_list');
my $x = (scalar @array) - 1;

foreach my $i (0 .. $x) {
	my $cost = $array[$i][1];
	$cost =~ s/,//g;
	$statement->execute($array[$i][0], $cost, $array[$i][2], $array[$i][3], $array[$i][4]) or die "SQL Error: $DBI::errstr\n";
	# print "('$array[$i][0]', '$cost', '$array[$i][2]', '$array[$i][3]', '$array[$i][4]'),\n";
}

$dbh->disconnect;
