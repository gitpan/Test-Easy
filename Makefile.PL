use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Test::Easy',
    'VERSION_FROM'	=> 'Easy.pm',
    'PREREQ_PM'		=> { Exporter=>5.562, warnings=>0.00, strict=>0.00 },
    ($] >= 5.005 ? (
      AUTHOR     => 'Daniel Peder <Daniel.Peder@infoset.com>',
    ) : ()),
);

sub MY::postamble { q{

docs : README

README: Easy.pm
	pod2text --loose Easy.pm > README

xdist:
	[ -f MANIFEST ] && rm -f MANIFEST ; make realclean docs manifest tardist; perl Makefile.PL

}; }
