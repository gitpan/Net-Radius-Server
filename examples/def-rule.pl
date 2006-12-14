#! /usr/bin/perl
#
# Sample rule configuration for Net::Radius::Server
#
# Copyright © 2006, Luis E. Muñoz
#
# This file defines a single rule that simply matches 'Access-Request'
# packets and returns 'Acces-Accept' responses.
#
# $Id: def-rule.pl,v 1.3 2006/11/13 15:42:26 lem Exp $
#
# DO NOT USE THIS EXAMPLE IN PRODUCTION - NO CREDENTIAL CHECKS ARE DONE

use strict;
use warnings;

use Net::Radius::Server::Rule;
use Net::Radius::Server::Base qw/:all/;
use Net::Radius::Server::Set::Simple;
use Net::Radius::Server::Match::Simple;

my @rules = ();

# Simple rule: Match Access-Request, return Access-Accept. No verification.
push @rules, Net::Radius::Server::Rule->new
    ({
	log_level => 4,
	match_methods => [ Net::Radius::Server::Match::Simple->mk
			   ( { code => 'Access-Request', 
			       description => 'Access-Packet',
			       log_level => 4 } ), 
			   ],
	set_methods => [
			Net::Radius::Server::Set::Simple->mk
			({
			    log_level => 4,
			    auto => 1,
			    code => 'Access-Accept',
			    result => NRS_SET_CONTINUE | NRS_SET_RESPOND,
			}),
			],
    });

# Match Accounting-Requests with an Accounting-Response
push @rules, Net::Radius::Server::Rule->new
    ({
	log_level => 4,
	match_methods => [ Net::Radius::Server::Match::Simple->mk
			   ( { code => 'Accounting-Request', 
			       description => 'Acct-Packet',
			       log_level => 4 } ), 
			   ],
	set_methods => [
			Net::Radius::Server::Set::Simple->mk
			({
			    log_level => 4,
			    auto => 1,
			    code => 'Accounting-Response',
			    result => NRS_SET_CONTINUE | NRS_SET_RESPOND,
			}),
			],
    });

# Return the rule set

\@rules;
