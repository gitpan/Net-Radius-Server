#! /usr/bin/perl
#
# Sample shared secret configuration for Net::Radius::Server
#
# Copyright © 2006, Luis E. Muñoz
#
# This file defines a 'secret' provider method that returns a simple shared
# secret.
#
# $Id: def-secret.pl,v 1.1.1.1 2006/11/07 22:51:07 lem Exp $

use strict;
use warnings;

sub { 'secret' }
