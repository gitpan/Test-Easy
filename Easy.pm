package Test::Easy;

require 5.005_62;
use strict;
use warnings;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(
	TEST CODE RUN SKIP TODO
);
our $VERSION = '0.01';
our @TESTS;
our @SKIP_FILTERS;
our @TODO_FILTERS;

sub TEST ($$)	{ push @TESTS, [@_] }
sub SKIP ($;$)	{ push @SKIP_FILTERS, [qr{$_[0]},'SKIP '.$_[1]] }
sub TODO ($;$)	{ push @TODO_FILTERS, [qr{$_[0]},'TODO '.$_[1]] }
sub CODE (&)	{ $_[0] }
sub RUN ()
{
	my( $MySimpleTestObject, $MySimpleTestObjectIndex );
	printf "1..%d\n", scalar( @TESTS );
	RUN_LOOP: for( 
		$MySimpleTestObjectIndex=0;
		$MySimpleTestObjectIndex<=$#TESTS;
		$MySimpleTestObjectIndex++
		)
	{
		$MySimpleTestObject = $TESTS[$MySimpleTestObjectIndex];
		foreach ( @SKIP_FILTERS )
		{
			if( $MySimpleTestObject->[0] =~ $_->[0] )
			{
				#debug# print "# FILTER passed\n";
				$MySimpleTestObject->[0] .= ' # '.$_->[1]; # add SKIP/TODO token
				printf "ok %d - %s\n"
					, (1+$MySimpleTestObjectIndex)
					, $MySimpleTestObject->[0]
				;
				next RUN_LOOP;
			}
		}
		$MySimpleTestObject->[2] =
			(defined(eval{ &{$MySimpleTestObject->[1]} })&&!$@)?1:0;
		foreach ( @TODO_FILTERS )
		{
			#debug# printf "# FILTER: qr{%s} %s\n", @$_;
			if( $MySimpleTestObject->[0] =~ $_->[0] )
			{
				#debug# print "# FILTER passed\n";
				$MySimpleTestObject->[0] .= ' # '.$_->[1]; # add SKIP/TODO token
				last;
			}
		}
		if( $MySimpleTestObject->[2] )
		{
			printf "ok %d - %s\n"
				, (1+$MySimpleTestObjectIndex)
				, $MySimpleTestObject->[0]
			;
		}
		else
		{
			my $results = 'results: '.($@||'<undef>'); 
			$results =~ s{^}{\t#}gom;
			printf "not ok %d - %s\n%s\n"
				, (1+$MySimpleTestObjectIndex)
				, $MySimpleTestObject->[0]
				, $results
			;
		}
	}
}

package Test::Easy::Tools;

sub isUndef (*) { defined($_[0])?undef:1 }
sub isArrayRef (*) { (ref(shift())=~/^ARRAY.*/o)?$&:undef }
sub isHashRef (*) { (ref(shift())=~/^HASH.*/o)?$&:undef }
sub isCodeRef (*) { (ref(shift())=~/^CODE.*/o)?$&:undef }
sub isScalarRef (*) { (ref(shift())=~/^SCALAR.*/o)?$&:undef }

1;
__END__

=head1 NAME

Test::Easy - Much 'Easy' than 'Simple'.

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

Easy testing suite. No plans, no special testing logic.
Just give your TEST 'label', CODE {return 'defined value'} and RUN.
All other sub's are just tools to decide whether to return 'defined value' or not.

No plans at all. (Isn't it a bug if I forget to change number of plans?)
	
SKIPs and TODOs are based on regular expression matching TEST labels.
Just give your tests smart labels (/my/testing/group1) and enjoy.

NOTE 1: what's SKIPped will never be 'TODO'.

NOTE 2: both SKIP or TODO can be invoked from within CODE block to
reflect run-time or conditional options. But don't expect to SKIP 'my self' when the test just run.
(You can SKIP 'the other following tests' only)

All tests are RUN after the RUN call. (Offering new testing ideas.)
Order of tests remains same as they appeared within the script file. 
When died, it still reports usefull line numbers.

=head1 EXPORT

	TEST CODE RUN SKIP TODO
	
=head1 TODO

Test::Easy::Tools like isUndef, isTrue, isFalse, isArrayRef, etc... (some of them are already undocumented within this module)

=head1 AUTHOR

B<Daniel Peder>, <Daniel.Peder@InfoSet.COM>, <http://www.InfoSet.com>

=head1 COPYRIGHT

Copyright 2002 Daniel Peder.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Test::Tutorial>, L<Test::Simple>, L<Test::More>, L<perl>(1).

=cut
