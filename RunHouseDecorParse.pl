#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use DBI;
use TableParse qw(parse);

my $db = 'animal_crossing';
my $host = 'localhost';
my $user = 'User';
my $pass = 'Password';

# DBI->trace(1);
# print "HERE\n";

my $dsn = "DBI:mysql:database=$db;host=$host";
my $dbh = DBI->connect( $dsn, $user, $pass, { RaiseError => 1 }) or die ( "Couldn't connect to database: " . DBI->errstr );

my $drop = "DROP TABLE IF EXISTS house_decor;";
my $create = <<'END';
CREATE TABLE house_decor (
id int(4) NOT NULL AUTO_INCREMENT,
name varchar(27) NOT NULL,
type varchar(9) NOT NULL,
theme varchar(10) NOT NULL,
PRIMARY KEY(id)
);
END

my $run_drop = $dbh->prepare($drop);
my $run_create = $dbh->prepare($create);
$run_drop->execute or die "SQL Error: $DBI::errstr\n";
$run_create->execute or die "SQL Error: $DBI::errstr\n";

my $query = "insert into house_decor (name, type, theme) values (?, ?, ?)";
my $statement = $dbh->prepare($query);

my @array = parse ('house_decor_list');
my $x = (scalar @array) - 1;
foreach my $i (0 .. $x) {
	$statement->execute($array[$i][0], $array[$i][1], $array[$i][2]) or die "SQL Error: $DBI::errstr\n";
# 	print "('$array[$i][0]', '$array[$i][1]', '$array[$i][2]'),\n";
}

$dbh->disconnect;
