use Test::Easy;


TEST 'test good',
CODE { return 1 }
;

our $SkipNotSkippedFlag = 0;
SKIP 'test skip', 'to check if skipped';
TEST 'test skip me',
CODE
{
	$SkipNotSkippedFlag = 1;
}
;

TEST 'check if "skip me" has been skipped',
CODE
{
	return undef if $SkipNotSkippedFlag;
}
;


TODO 'test bad', '"not ok" result expected';

TEST 'test bad for <undef>',
CODE 
{
	return undef;
}
;

TEST 'test bad for die()',
CODE { die "hard" }
;


RUN;