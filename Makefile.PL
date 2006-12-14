use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile
    (
     NAME              => 'Net::Radius::Server',
     VERSION_FROM      => 'lib/Net/Radius/Server.pm', # finds $VERSION
     PREREQ_PM         => 
     {
	 'Class::Accessor'		=> 0.27,
	 'NetAddr::IP'			=> 4,
	 # Net::Radius - We need dynamic packet types
	 # and other recent niceties
	 'Net::Radius::Packet'		=> 1.51,
	 'Net::Radius::Dictionary'	=> 1.51,
	 # We use Net::Server as our server's engine
	 'Net::Server'			=> 0.94,
	 # Utilities and tests use this
	 'IO::Prompt'			=> 0,
     },
     EXE_FILES        => [ qw!
			   bin/nrsd
			   bin/rad-client
			   bin/pam-client
			   !],
     ($] >= 5.005 ?    
      (ABSTRACT_FROM  => 'lib/Net/Radius/Server.pm', 
       AUTHOR         => 'Luis E. Muñoz <luismunoz@cpan.org>') : ()),
     );
