#!perl
# vim:syntax=perl:tabstop=4:number:noexpandtab:

use Locale::TextDomain::OO::Extract::Xslate;
use Path::Tiny qw(path);
use Data::Dumper;

use Test::More;

my $expected = {
	'i-default::' => {
		'Book named \'{title}\'.' => {
			'reference' => {
				't/data/kolon/functions.tx:10' => undef,
				't/data/kolon/methods.tx:10' => undef,
			}
		},
		'Book named \'Moby Dick\'.' => {
			'reference' => {
				't/data/kolon/filters.tx:13' => undef,
			}
		},
		'' => {
			'msgstr' => {
				'nplurals' => 2,
				'plural' => 'n != 1'
			}
		},
		"Text with {variable}.\x{04}some context" => {
			'reference' => {
				't/data/kolon/methods.tx:15' => undef,
				't/data/kolon/functions.tx:15' => undef,
			}
		},
		'Page title' => {
			'reference' => {
				't/data/kolon/functions.tx:5' => undef,
				't/data/kolon/methods.tx:5' => undef,
				't/data/kolon/filters.tx:5' => undef,
			}
		},
		'Just some text' => {
			'reference' => {
				't/data/kolon/functions.tx:2' => undef,
				't/data/kolon/methods.tx:2' => undef,
				't/data/kolon/filters.tx:2' => undef,
			}
		},
		"Singular form with {variable1} and {variable2}.\x{00}Plural form with {variable1} and {variable2}!" => {
			'reference' => {
				't/data/kolon/methods.tx:17' => undef,
				't/data/kolon/functions.tx:17' => undef,
			}
		},
		"Text with umlauts: \x{e4}\x{f6}\x{fc}\x{df}." => {
			'reference' => {
				't/data/kolon/functions.tx:13' => undef,
				't/data/kolon/methods.tx:13' => undef,
				't/data/kolon/filters.tx:16' => undef,
			}
		},
		"Singular form with {variable}.\x{00}Plural form with {variable}!\x{04}Whole other context" => {
			'reference' => {
				't/data/kolon/methods.tx:19' => undef,
				't/data/kolon/functions.tx:19' => undef,
			}
		}
	}
};

my @files = (qw(
	t/data/kolon/functions.tx
	t/data/kolon/methods.tx
	t/data/kolon/filters.tx
));
my $extract = Locale::TextDomain::OO::Extract::Xslate->new();

for my $file ( map { path($_) } @files ) {
	my $fn = $file->relative( q{./} )->stringify;
	$extract->clear;
	$extract->filename($fn);
	$extract->extract;
}

my $got = $extract->lexicon_ref;
is_deeply( $got, $expected, "Succesful extraction from Kolon syntax templates with standard methods and filters" )
	or warn Dumper $got;


# separate test for custom user-provided function names
# with a couple of the original ones still in there just to check
$extract = Locale::TextDomain::OO::Extract::Xslate->new();
$expected = {
	'i-default::' => {
		'' => {
			'msgstr' => {
				'nplurals' => 2,
				'plural' => 'n != 1'
			}
		},
		'Page title' => {
			'reference' => {
				't/data/kolon/custom.tx:5' => undef,
			}
		},
		'Just some text' => {
			'reference' => {
				't/data/kolon/custom.tx:2' => undef,
			}
		},
		"Text with {variable}.\x{04}some context" => {
			'reference' => {
				't/data/kolon/custom.tx:19' => undef,
			}
		},
		"Text with umlauts: \x{e4}\x{f6}\x{fc}\x{df}." => {
			'reference' => {
				't/data/kolon/custom.tx:17' => undef,
				't/data/kolon/custom.tx:18' => undef,
			}
		},
		'Book named \'Moby Dick\'.' => {
			'reference' => {
				't/data/kolon/custom.tx:14' => undef,
			}
		},
	},
};
for my $file ( map { path($_) } 't/data/kolon/custom.tx' ) {
	my $fn = $file->relative( q{./} )->stringify;
	$extract->clear;
	$extract->filename($fn);

	# add our additional l10n functions
	$extract->addl_l10n_function_re(qr{ loc | i10n_me | whatever }x);

	$extract->extract;
}
my $got = $extract->lexicon_ref;
is_deeply( $got, $expected, "Succesful extraction from Kolon syntax templates with custom methods" )
	or warn Dumper $got;


# separate test for :cascade
$extract = Locale::TextDomain::OO::Extract::Xslate->new();
$expected = {
	'i-default::' => {
		'' => {
			'msgstr' => {
				'plural' => 'n != 1',
				'nplurals' => 2
			}
		},
		'The macro says: ' => {
			'reference' => {
				't/data/kolon/cascade/helpers.tx:1' => undef
			}
		},
		'My Template!' => {
			'reference' => {
				't/data/kolon/cascade/base.tx:4' => undef
			}
		},
		'My template body!' => {
			'reference' => {
				't/data/kolon/cascade/foo.tx:4' => undef
			}
		}
	}
};


@files = (qw(
	t/data/kolon/cascade/helpers.tx
	t/data/kolon/cascade/base.tx
	t/data/kolon/cascade/foo.tx
));
for my $file ( map { path($_) } @files ) {
	my $fn = $file->relative( q{./} )->stringify;
	$extract->clear;
	$extract->filename($fn);
	$extract->extract;
}
my $got = $extract->lexicon_ref;
is_deeply( $got, $expected, "Succesful extraction from Kolon syntax templates with :cascade" )
	or warn Dumper $got;


done_testing;
