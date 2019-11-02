#!/usr/bin/perl
# similarity.pl
# 
# given two ImageNet synsets, return the semantic distance between the
# respective concepts as judged by the Wu-Palmer distance in WordNet 3.0.
#
# $ARGV[0]: a string, the first synset
# $ARGV[1]: a string, the second synset
# $ARGV[2]: a string, the directory in which to write the result
#
# $value: a string, the distance between the two synset concepts

use WordNet::QueryData;
use WordNet::Similarity::wup;

my $wn = WordNet::QueryData->new("/usr/local/WordNet-3.0/dict/");
my $measure = WordNet::Similarity::wup->new($wn);
my $sense1 = $wn->getSense(substr($ARGV[0],1),"n");
my $sense2 = $wn->getSense(substr($ARGV[1],1),"n");
my $value = $measure->getRelatedness($sense1,$sense2);
my ($error, $errorString) = $measure->getError();
die $errorString if $error;
my $file = "$ARGV[2]/$ARGV[0].$ARGV[1].similarity";
open(FILE , "> $file") || die "problem opening $file\n";
print FILE "$value\n";
close(FILE)
