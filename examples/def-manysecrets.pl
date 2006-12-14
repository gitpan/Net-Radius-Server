#! /usr/bin/perl
#
# Sample shared secret configuration for Net::Radius::Server
#
# Copyright © 2006, Luis E. Muñoz
#
# This file defines a 'secret' provider method that returns a shared
# secret for each NAS
#
# $Id: def-manysecrets.pl,v 1.1 2006/11/08 22:14:08 lem Exp $

use strict;
use warnings;

my $default = 'secret';		# Default secret

my $s = {
    '127.0.0.1'		=> 'secret1',
    '10.10.10.10'	=> 'anothersikrit',
};

sub { exists $s->{$_[0]->{peer_addr}} ? $s->{$_[0]->{peer_addr}} : $default }
