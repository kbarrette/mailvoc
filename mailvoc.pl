#!/usr/bin/perl
use strict;
use Date::Parse qw(str2time);
use HTML::Strip;
use Lingua::EN::Splitter qw(words);
use Lingua::Stem;
use List::MoreUtils qw(uniq);
use List::Util qw(first sum);
use Mail::Box::Mbox;
use POSIX qw(strftime);

$| = 1;
print "Setting up\n";

my $filename = $ARGV[0] || die "Please specify a filename";

# Setup
my $folder = new Mail::Box::Mbox(folder => $filename) || die "Problem opening $filename: $!";
my $stripper = new HTML::Strip;
my $stemmer = Lingua::Stem->new(-locale => "EN-US");
$stemmer->stem_caching({-level => 2});

my @messages = $folder->messages;
print "Parsing " . (scalar @messages) . " messages";

my %stems_by_date = [];
my $i = 0;
foreach my $message (@messages) {

  # Parse date
  my $date = $message->head->get("date");
  my $date_key = strftime("%Y-%m", localtime(str2time($date)));

  # Parse body and reject some junk if we can
  my $body = first {$_->isText} map {$_->decoded} $message->parts;
  my $filtered_body = join "\n", grep {$_ !~ /^\s*>/ && $_ !~ /^\s*On.*wrote:\s*$/} $body->lines;
  my $stripped = $stripper->parse($filtered_body);
  $stripper->eof;

  # Stem words from the body
  my $stems = $stemmer->stem(words($stripped));

  push @{$stems_by_date{$date_key}}, @$stems;

  print "." if ($i++ % (scalar @messages / 10) == 0);
}
print "\n";

# Gather stats
print "Compiling stats\n";
my @dates;
my @uniques;
my @totals;
foreach my $date (keys %stems_by_date) {
  push @dates, $date;
  push @uniques, scalar uniq @{$stems_by_date{$date}};
  push @totals, scalar @{$stems_by_date{$date}};
}

for(my $i; $i < $#dates; $i++) {
  print "$dates[$i]: $uniques[$i] unique of total $totals[$i]\n";
}
