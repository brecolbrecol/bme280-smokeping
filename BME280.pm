package Smokeping::probes::BME280;

=head1 301 Moved Permanently

This is a Smokeping probe module. Please use the command 

C<smokeping -man Smokeping::probes::BME280>

to view the documentation or the command

C<smokeping -makepod Smokeping::probes::BME280>

to generate the POD document.

=cut

use strict;
#use base qw(Smokeping::probes::basefork); 
# or, alternatively
use base qw(Smokeping::probes::base);
use Carp;

sub pod_hash {
	return {
		name => <<DOC,
Smokeping::probes::BME280 - a skeleton for Smokeping Probes
DOC
		description => <<DOC,
This is a module intended to act as a temperature probe for BME280. 
See the L<smokeping_extend> document for more information.
DOC
		authors => <<'DOC',
 j <j@jorge.red>,
DOC
		see_also => <<DOC
L<smokeping_extend>
DOC
	};
}

sub new($$$)
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = $class->SUPER::new(@_);

    # no need for this if we run as a cgi
    unless ( $ENV{SERVER_SOFTWARE} ) {
	    my @measures = ping();

	    foreach my $measure (@measures)
	    {
		    print $measure . "\n";
	    }

    };

    return $self;
}

# This is where you should declare your probe-specific variables.
# The example shows the common case of checking the availability of
# the specified binary.

sub probevars {
	my $class = shift;
	return $class->_makevars($class->SUPER::probevars, {
		_mandatory => [ 'binary' ],
		binary => { 
		_doc => "The location of your bme280-smoke.py binary.",
		_example => '/usr/bin/bme280-smoke.py',
		_sub => sub { 
			my $val = shift;
        		return "ERROR: pingpong 'bme280-emoke.py' does not point to an executable"
        			unless -f $val and -x _;
			return undef;
		},
	},
	});
}

# Here's the place for target-specific variables

sub targetvars {
	my $class = shift;
	return $class->_makevars($class->SUPER::targetvars, {
		temperature => { _doc => "Measure temperature",
			         _example => 1,
		},
	});
}

sub ProbeDesc($){
    my $self = shift;
    return "BME280 temperature";
}

# this is where the actual stuff happens
# you can access the probe-specific variables
# via the $self->{properties} hash and the
# target-specific variables via $target->{vars}

# If you based your class on 'Smokeping::probes::base',
# you'd have to provide a "ping" method instead
# of "pingone"

sub ping ($){
    my $self = shift;
    my $target = shift;

#    my $binary = $self->{properties}{binary};
    # my $weight = $target->{vars}{weight}
    my $cmd = '/usr/bin/bme280-smoke.py';
    my $count = 5;
    $count = $self->pings($target) if defined $target; # the number of pings for this targets
#    $self->increment_rounds_count;

    # ping one target

    # execute a command and parse its output
    # you should return a sorted array of the measured latency times
    # it could go something like this:

    my @times;

    for (1..$count) {
            open(P, "$cmd 2>&1 |") or croak("fork: $!");
            while (<P>) {
                    /Temperature \(C\): (\d+\.\d+)/ and push @times, $1;
            }
            close P;
    }


    return @times;
}

# That's all, folks!

1;
