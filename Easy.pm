package Test::Easy;

require 5.005_62;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
	TEST CODE RUN SKIP TODO
);

use vars qw( $VERSION );

	$VERSION = '1.01'; # $Revision: 1.8 $ #
	
our @TESTS;
our @SKIP_FILTERS;
our @TODO_FILTERS;

sub TEST ($$)	{ push @TESTS, [@_] }
sub SKIP ($;$)	{ push @SKIP_FILTERS, [qr{$_[0]},'SKIP '.$_[1]] }
sub TODO ($;$)	{ push @TODO_FILTERS, [qr{$_[0]},'TODO '.$_[1]] }
sub CODE (&)	{ $_[0] }
sub RUN ()
{
	my( $MyEasyTestObject, $MyEasyTestObjectIndex );
	printf "1..%d\n", scalar( @TESTS );
	RUN_LOOP: for( 
		$MyEasyTestObjectIndex=0;
		$MyEasyTestObjectIndex<=$#TESTS;
		$MyEasyTestObjectIndex++
		)
	{
		$MyEasyTestObject = $TESTS[$MyEasyTestObjectIndex];
		foreach ( @SKIP_FILTERS )
		{
			if( $MyEasyTestObject->[0] =~ $_->[0] )
			{
				#debug# print "# FILTER passed\n";
				$MyEasyTestObject->[0] .= ' # '.$_->[1]; # add SKIP/TODO token
				printf "\nok %d - %s\n"
					, (1+$MyEasyTestObjectIndex)
					, $MyEasyTestObject->[0]
				;
				next RUN_LOOP;
			}
		}
		
		# print header what we are going to test
		printf "\n# -> %d - %s\n"
			, (1+$MyEasyTestObjectIndex)
			, $MyEasyTestObject->[0]
		;

		# call the test
		$MyEasyTestObject->[2] =
			(defined(eval{ &{$MyEasyTestObject->[1]} })&&!$@)?1:0;
		foreach ( @TODO_FILTERS )
		{
			#debug# printf "# FILTER: qr{%s} %s\n", @$_;
			if( $MyEasyTestObject->[0] =~ $_->[0] )
			{
				#debug# print "# FILTER passed\n";
				$MyEasyTestObject->[0] .= ' # '.$_->[1]; # add SKIP/TODO token
				last;
			}
		}
		if( $MyEasyTestObject->[2] )
		{
			printf "ok %d - %s\n"
				, (1+$MyEasyTestObjectIndex)
				, $MyEasyTestObject->[0]
			;
		}
		else
		{
			my $results = 'results: '.($@||'<undef>'); 
			$results =~ s{^}{\t#}gom;
			printf "not ok %d - %s\n%s\n"
				, (1+$MyEasyTestObjectIndex)
				, $MyEasyTestObject->[0]
				, $results
			;
		}
	}
}

sub test::is_undef (*) { !defined($_[0]) ? 1 : undef }
sub test::is_true (*) { $_[0] ? 1 : undef }
sub test::is_false (*) { (defined($_[0]) && !$_[0] ) ? 1 : undef }
#sub test::isArrayRef (*) { (ref(shift())=~/^ARRAY.*/o)?$&:undef }
#sub test::isHashRef (*) { (ref(shift())=~/^HASH.*/o)?$&:undef }
#sub test::isCodeRef (*) { (ref(shift())=~/^CODE.*/o)?$&:undef }
#sub test::isScalarRef (*) { (ref(shift())=~/^SCALAR.*/o)?$&:undef }

1;
__END__

=head1 NAME

Test::Easy - Testing made absolute easy.

=head1 SYNOPSIS

	use Test::Easy;
	
	TEST 'this is my 1st test',
	CODE { return 'true if this test passed ok' }
	;
	
	TEST 'this is my 2nd test',
	CODE { return 'true if this test passed ok' }
	;
	
	TEST 'this is my bad test',
	CODE { return undef or die "this test failed" }
	;
	
	SKIP 'my 2nd test', 'just because ...';
	TODO 'my bad test', 'need it good one day ...';
	
	RUN;

=head1 DESCRIPTION

=head2 JUST ABOUT

Easy testing suite. No plans, no special testing logic.
Absolutely easy just like this:

	do { TEST 'label' => CODE { return 'defined value' } and RUN }
	
All other sub's should be just tools to decide whether to return 'defined' or undef value.

No plans at all. (Isn't it a bug if I forget to change number of plans?)
	
SKIPs and TODOs are based on regular expression matching TEST labels.
Just give your tests smart labels (/my/testing/group1) and enjoy.

NOTE 1: what's SKIPped will never be 'TODO'.

NOTE 2: both SKIP or TODO can be invoked from within CODE block to
reflect run-time or conditional options. But don't expect to SKIP 'my self' when the test just run.
(You can SKIP 'the other following tests' only)

All tests are run by the RUN call. (Offering new testing ideas.)
Order of tests remains same as they appeared within the script file. 
When died, it still reports usefull line numbers.

=head2 EXPORT

	TEST CODE RUN SKIP TODO
	
=head2 STYLE

	#style1
	
	TEST 'descriptive/label/of/what/to/test',
	CODE
	{
		return 'some_true_to_OK';
	};
	
	#style2
	
	TEST 'descriptive/label/of/what/to/test' => CODE
	{
		return test::is_true( 'some_true_to_OK' );
	};
	
	#style3
	
	TEST 'descriptive/label/of/what/to/test',
	CODE { return 'true if this test passed ok' }
	;

	
	
=head1 TODO

dirty way exported tools functions into dummy namespace `test::'

	test::is_undef
	test::is_true
	test::is_false

=head1 AUTHOR

B<Daniel Peder>, <DanPeder@CPAN.ORG>, <Daniel.Peder@InfoSet.COM>, <http://www.InfoSet.com>

=head1 COPYRIGHT

Copyright 2002 Daniel Peder.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 REVISION

	$Id: Easy.pm_rev 1.8 2003/12/12 09:03:33 root Exp $
	
=head2 HISTORY

	$Log: Easy.pm_rev $
	Revision 1.8  2003/12/12 09:03:33  root
	minor source code changes: use vars $VERSION
	distro changes: added t/use.t

	Revision 1.7  2002/12/07 12:30:23  root
	version 1.00 stable for release


=head1 SEE ALSO

L<Test::Tutorial>, L<Test::Simple>, L<Test::More>, L<perl>(1).

=cut
