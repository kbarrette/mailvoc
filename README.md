mailvoc
=======

Analyze your email vocabulary

Inspired by [a Radiolab episode](http://www.radiolab.org/blogs/radiolab-blog/2010/jul/26/secrets-of-success/),
this script analyzes an mbox file and plots the number of distinct words used in a message vs time.

Usage
-----
1. Clone this repo
2. Install
    - [HTML::Strip](http://search.cpan.org/dist/HTML-Strip/Strip.pm)
    - [Lingua::EN::Splitter](http://search.cpan.org/~splice/Lingua-EN-Segmenter-0.1/lib/Lingua/EN/Splitter.pm)
    - [Lingua::Stem](http://search.cpan.org/~snowhare/Lingua-Stem-0.84/lib/Lingua/Stem.pod)
    - [Mail::Box::Mbox](http://search.cpan.org/~markov/Mail-Box-2.102/lib/Mail/Box/Mbox.pod)
3. Dump your inbox into an mbox file
4. ```perl mailvoc.pl inbox.mbox```

