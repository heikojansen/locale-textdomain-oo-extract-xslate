#!perl
# vim:syntax=perl:tabstop=4:number:noexpandtab:

use Locale::TextDomain::OO::Extract::Xslate;
use Path::Tiny qw(path);

use Test::More;

my $expected = {
	'i-default::' => {
		'Book named \'{title}\'.' => {
			'reference' => {
				't/data/kolon/functions.tx:10' => undef,
				't/data/kolon/methods.tx:10' => undef
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
				't/data/kolon/functions.tx:15' => undef
			}
		},
		'Page title' => {
			'reference' => {
				't/data/kolon/functions.tx:5' => undef,
				't/data/kolon/methods.tx:5' => undef
			}
		},
		'Just some text' => {
			'reference' => {
				't/data/kolon/functions.tx:2' => undef,
				't/data/kolon/methods.tx:2' => undef
			}
		},
		"Singular form with {variable1} and {variable2}.\x{00}Plural form with {variable1} and {variable2}!" => {
			'reference' => {
				't/data/kolon/methods.tx:17' => undef,
				't/data/kolon/functions.tx:17' => undef
			}
		},
		"Text with umlauts: \x{e4}\x{f6}\x{fc}\x{df}." => {
			'reference' => {
				't/data/kolon/functions.tx:13' => undef,
				't/data/kolon/methods.tx:13' => undef
			}
		},
		"Singular form with {variable}.\x{00}Plural form with {variable}!\x{04}Whole other context" => {
			'reference' => {
				't/data/kolon/methods.tx:19' => undef,
				't/data/kolon/functions.tx:19' => undef
			}
		}
	}
};

my @files = (qw( t/data/kolon/functions.tx t/data/kolon/methods.tx ));
my $extract = Locale::TextDomain::OO::Extract::Xslate->new();

for my $file ( map { path($_) } @files ) {
	my $fn = $file->relative( q{./} )->stringify;
	$extract->clear;
	$extract->filename($fn);
	$extract->extract;
}

is_deeply( $extract->lexicon_ref, $expected, "Succesful extraction from Kolon syntax templates" );

done_testing;