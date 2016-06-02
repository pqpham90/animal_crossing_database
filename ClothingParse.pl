#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use TableParse qw(run_parse);

run_parse ('clothing_list', 21);
