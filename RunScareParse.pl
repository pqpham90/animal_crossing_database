#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use DBI;
use TableParse qw(parse run_parse);

my $db = 'animal_crossing';
my $host = 'localhost';
my $user = 'User';
my $pass = 'Password';

# DBI->trace(1);
# print "HERE\n";

my $dsn = "DBI:mysql:database=$db;host=$host";
my $dbh = DBI->connect( $dsn, $user, $pass, { RaiseError => 1 }) or die ( "Couldn't connect to database: " . DBI->errstr );

my $drop = "DROP TABLE IF EXISTS halloween;";
my $create = <<'END';
CREATE TABLE halloween (
id int(4) NOT NULL AUTO_INCREMENT,
species varchar(10) NOT NULL,
jock varchar(6) NOT NULL,
smug varchar(6) NOT NULL,
lazy varchar(6) NOT NULL,
cranky varchar(6) NOT NULL,
normal varchar(6) NOT NULL,
peppy varchar(6) NOT NULL,
snooty varchar(6) NOT NULL,
uchi varchar(6) NOT NULL,
PRIMARY KEY(id)
);
END

my $run_drop = $dbh->prepare($drop);
my $run_create = $dbh->prepare($create);
$run_drop->execute or die "SQL Error: $DBI::errstr\n";
$run_create->execute or die "SQL Error: $DBI::errstr\n";

run_parse("scare_list", 11);

my $query = "insert into halloween (species, jock, smug, lazy, cranky, normal, peppy, snooty, uchi) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
my $statement = $dbh->prepare($query);

my @array = parse ('scare_list');
my $x = (scalar @array) - 1;
foreach my $i (0 .. $x) {
	$statement->execute($array[$i][0], $array[$i][1], $array[$i][2], $array[$i][3], $array[$i][4], $array[$i][5], $array[$i][6], $array[$i][7], $array[$i][8]) or die "SQL Error: $DBI::errstr\n";
	# print "('$array[$i][0]', '$array[$i][1]', '$array[$i][2]', '$array[$i][3]', '$array[$i][4]', '$array[$i][5]', '$array[$i][6]', '$array[$i][7]', '$array[$i][8]'),\n";
}

$dbh->disconnect;

