mailvoc
=======

Analyze your email vocabulary

![Chart](http://kbarrette.github.com/mailvoc/chart.png)

Inspired by [a Radiolab episode](http://www.radiolab.org/story/91960-vanishing-words/),
this script analyzes an mbox file and plots the number of distinct words used vs time.  This utility relies
on [Google Charts](https://developers.google.com/chart/).

Usage
-----
1. Clone this repo
2. Install
    - [HTML::Strip](http://search.cpan.org/dist/HTML-Strip/Strip.pm)
    - [LWP::Simple](http://search.cpan.org/~gaas/libwww-perl-6.04/lib/LWP/Simple.pm)
    - [Lingua::EN::Splitter](http://search.cpan.org/~splice/Lingua-EN-Segmenter-0.1/lib/Lingua/EN/Splitter.pm)
    - [Lingua::Stem](http://search.cpan.org/~snowhare/Lingua-Stem-0.84/lib/Lingua/Stem.pod)
    - [Mail::Box::Mbox](http://search.cpan.org/~markov/Mail-Box-2.102/lib/Mail/Box/Mbox.pod)
    - [URI::GoogleChart](http://search.cpan.org/dist/URI-GoogleChart/lib/URI/GoogleChart.pm)
3. Dump your sent mail into an mbox file
4. ```perl mailvoc.pl sent.mbox```

