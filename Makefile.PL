use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Test::Easy',
    'VERSION_FROM'	=> 'Easy.pm',
    'PREREQ_PM'		=> { Exporter=>5.562, warnings=>0.00, strict=>0.00 },
);
