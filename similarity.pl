# Similarity.pl
# 
# given two ImageNet synsets, return the semantic distance between the
# respective concepts as judged by the Wu-Palmer distance in WordNet 3.0.
#
# $ARGV[0]: a string, the first synset
# $ARGV[1]: a string, the second synset
#
# $value: a string, the distance between the two synset concepts

use WordNet::QueryData;
use WordNet::Similarity::wup;

my $wn = WordNet::QueryData->new("/usr/share/wordnet/dict/");
my $measure = WordNet::Similarity::wup->new($wn);
my $sense1 = $wn->getSense(substr($ARGV[0],1),"n");
my $sense2 = $wn->getSense(substr($ARGV[1],1),"n");
my $value = $measure->getRelatedness($sense1,$sense2);
my ($error, $errorString) = $measure->getError();
die $errorString if $error;
print "$value\n";
