#! /usr/bin/perl
#Version=1.0.0.0
use strict;
use warnings;

my $mDEBUG = 1;

my $git_url = "https://github.com/adafruit";

#my $git_url = "https://github.com/sparkfun";
#my $doc_url = "https://github.com/sparkfun?page=1";
my $startdoc_url = $git_url . "?page=";
my $doc_url      = $startdoc_url;

# (1) quit unless we have the correct number of command-line args
my $num_args = $#ARGV + 1;
if ( $num_args != 1 ) {
    print "\nUsage: prepareMediaInfo.pl <path>\n";
    exit;
}

my $inputFilename = $ARGV[0];

#print "Hello, $inputFilename\n";
normalize( $inputFilename, "" );

#print "Startup \r\n";

sub normalize {
    my ( $file, $tmp ) = @_;
    print "Normalizing '$file'\n";

    open my $info, $file or die "Could not open $file: $!";

    my $linecount = 0;
    my $outfileSuffix = "General";
    my $outfileName = $file . "." . $outfileSuffix . ".txt";
    open(my $outfile, '>', $outfileName) or die "Could not open write file '$outfileName' $!";
    while ( my $line = <$info> ) {
        #print $line;

        #last if ++$linecount == 2;
        #if ( index($line, 'Video') != -1 ) {
        if ( $line =~ m/^General$/ ) {
            # General section
            $mDEBUG && print "General\n";
        }
        if ( $line =~ m/^Video$/ ) {
            # Video Codec section
            $outfileSuffix = "Video";
            $mDEBUG && print "$outfileSuffix\n";
            
            close $outfile;
            $outfileName = $file . "." . $outfileSuffix . ".txt";
            open($outfile, '>', $outfileName) or die "Could not open write file '$outfileName' $!";
        }
        elsif ( ($outfileSuffix eq "Video" && $line eq "\n" ) || ($line =~ m/^Audio$/) ) {
            # Audio Codec section
            $outfileSuffix = "Audio";
            $mDEBUG && print "$outfileSuffix\n";
            
            close $outfile;
            $outfileName = $file . "." . $outfileSuffix . ".txt";
            open($outfile, '>', $outfileName) or die "Could not open write file '$outfileName' $!";
        }
        elsif ( ($outfileSuffix eq "Audio" && $line eq "\n" ) || ($line =~ m/^Text$/) ) {
            # Sub Text section
            $outfileSuffix = "Text";
            $mDEBUG && print "$outfileSuffix\n";
            
            close $outfile;
            $outfileName = $file . "." . $outfileSuffix . ".txt";
            open($outfile, '>', $outfileName) or die "Could not open write file '$outfileName' $!";
        }
        
        print $outfile $line;
        
        ++$linecount;
    }

    close $outfile;
    close $info;

    #  use URI;
    #  return URI->new_abs($url, $base)->canonical;
}

sub init_browser {

    #  $browser = LWP::UserAgent->new;
    #  # ...And any other initialization we might need to do...
    #  return $browser;
}

exit;


