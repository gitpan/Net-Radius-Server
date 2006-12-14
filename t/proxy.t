#!/usr/bin/perl

use Test::More tests => 30;

use IO::File;
use Net::Radius::Packet;
use Net::Radius::Server::Base qw/:set/;

# Init the dictionary for our test run...
BEGIN {
    my $fh = new IO::File "dict.$$", ">";
    print $fh <<EOF;
ATTRIBUTE	User-Name		1	string
ATTRIBUTE	User-Password		2	string
EOF

    close $fh;
};

END { unlink 'dict.' . $$; }

use_ok('Net::Radius::Server::Set::Proxy');

my $proxy = Net::Radius::Server::Set::Proxy->new({});
my $m_proxy = $proxy->mk();
is(ref($m_proxy), "CODE", "Factory returns a coderef/sub");

# Class hierarchy and contents
isa_ok($proxy, 'Exporter');
isa_ok($proxy, 'Class::Accessor');
isa_ok($proxy, 'Net::Radius::Server');
isa_ok($proxy, 'Net::Radius::Server::Set');
isa_ok($proxy, 'Net::Radius::Server::Set::Proxy');

can_ok($proxy, 'new');
can_ok($proxy, 'log');
can_ok($proxy, 'log_level');
can_ok($proxy, 'mk');
can_ok($proxy, '_set');
can_ok($proxy, 'set_server');
can_ok($proxy, 'result');
can_ok($proxy, 'server');
can_ok($proxy, 'port');
can_ok($proxy, 'secret');
can_ok($proxy, 'dictionary');
can_ok($proxy, 'timeout');
can_ok($proxy, 'tries');
can_ok($proxy, 'description');
like($proxy->description, qr/Net::Radius::Server::Set::Proxy/, 
     "Description contains the class");
like($proxy->description, qr/proxy\.t/, "Description contains the filename");
like($proxy->description, qr/:\d+\)$/, "Description contains the line");


diag(qq{
The following tests require access to a live RADIUS server.
Do you want to run this test? (Say "yes" if you do)

});

my $ans = <STDIN>;

if ($ans =~ m/(?i)yes/)
{
    diag(qq{

Please tell me the IP address of your real RADIUS server

});
    my $server = <STDIN>;

    diag(qq{

Please tell me the RADIUS shared secret to use

});
    my $secret = <STDIN>;

    diag(qq{

Please tell me the port where the RADIUS server listens

});
    my $port = <STDIN>;

    chomp($server);
    chomp($secret);
    chomp($port);

    diag(q{

Attempting a request that should fail

});

    # Build a request/reply pair and test it is ok
    my $req = new Net::Radius::Packet;
    my $rep = new Net::Radius::Packet;
    isa_ok($req, 'Net::Radius::Packet');
    isa_ok($rep, 'Net::Radius::Packet');

    $req->set_dict("dict.$$");
    $rep->set_dict("dict.$$");
    $req->set_code("Access-Request");
    $rep->set_code("Access-Reject");
    $req->set_identifier('42');
    $req->set_authenticator(substr('So long and thanks for all the fish', 
				   0, 16));
    $req->set_attr("User-Name" => 'FOO@MY.DOMAIN');
    $req->set_password('I_HOPE_THIS_IS_NOT_YOUR_PASSWORD', 
		       "secret-$$");

    $proxy->dictionary("dict.$$");
    $proxy->secret($secret);
    $proxy->server($server);
    $proxy->port($port);
    $proxy->timeout(2);
    $proxy->tries(3);
    is($m_proxy->({ request => $req, response => $rep, 
		    secret => "secret-$$" }), 
       NRS_SET_CONTINUE, "Failed RADIUS response");

    is($rep->code, 'Access-Reject', "Correct response from wrong packet");
    diag q{


Please review your RADIUS server detail file or logs. I tried to 
authenticate the user 'FOO@MY.DOMAIN' with no password. 

If you see evidence that the we sent the request, then you can consider
this test as succesful.

Press ENTER


};
    my $foo = <STDIN>;

    diag(qq{

Now please provide a valid username for this RADIUS server

});
    my $user = <STDIN>;

    diag(qq{

Please provide a valid password for this user (IT WILL ECHO)

});
    my $pass = <STDIN>;

    chomp($user);
    chomp($pass);

    diag(q{

Attempting a request that should succeed

});
    $req->set_attr("User-Name" => $user);
    $req->set_password($pass, "secret-$$");
    $proxy->result(NRS_SET_RESPOND);
    is($m_proxy->({ request => $req, response => $rep, 
		    secret => "secret-$$" }), 
       NRS_SET_RESPOND, "Correct RADIUS response");
    
    like($rep->code, qr/Access/, "Correct response for good credentials");
}
else
{
  SKIP: { skip 'No live RADIUS server supplied', 6 };
}
