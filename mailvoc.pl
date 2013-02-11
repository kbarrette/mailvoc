#!/usr/bin/perl
use strict;
use Date::Parse qw(str2time);
use HTML::Strip;
use LWP::Simple qw(getstore);
use Lingua::EN::Splitter qw(words);
use Lingua::Stem;
use List::MoreUtils qw(uniq);
use List::Util qw(first sum);
use Mail::Box::Mbox;
use POSIX qw(strftime);
use URI::GoogleChart;

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
foreach my $date (sort keys %stems_by_date) {
  push @dates, $date;
  push @uniques, scalar uniq @{$stems_by_date{$date}};
  push @totals, scalar @{$stems_by_date{$date}};
}

# Build a chart
print "Building chart\n";
my @data = map {$uniques[$_] / ($totals[$_] || 1) * 100} (0 .. $#totals);

# Select every sixth date for labels
my $i = 0;
my @labels = grep {$i++ % 10 == 0} @dates;

my $chart = new URI::GoogleChart(
  "lines",
  600,
  500,
  data => \@data,
  min => 0,
  max => 100,
  range_round => 1,
  chxl => "0:|" . (join "||||||||||", @labels),
  range_show => "left",
  label => "% unique words",
  color => "blue",
  chxt => "x",
  encoding => "e",
);

print "Fetching chart\n";
my $status = getstore($chart, "chart.png");
if ($status == 200) {
  print "Chart saved in chart.png\n";
} else {
  print "Error getting chart: $status\n";
}
