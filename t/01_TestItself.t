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

TEST 'test is_true' => CODE
{
	test::is_true( 1 )
	&& !defined( test::is_true( 0 ))
	&& !defined( test::is_true( '' ))
	&& !defined( test::is_true( undef ))
	|| return undef
};

TEST 'test is_false' => CODE
{
	test::is_false( 0 )
	&& test::is_false( '' )
	&& !defined( test::is_false( 1 ))
	&& !defined( test::is_false( undef ))
	|| return undef
};

TEST 'test is_undef' => CODE
{
	test::is_undef( undef )
	&& !defined( test::is_undef( 1 ))
	&& !defined( test::is_undef( 0 ))
	&& !defined( test::is_undef( '' ))
	|| return undef
};

RUN;
