#!/usr/bin/perl

# 1st arg is the root of the source folder to mimic, will parse recursively all js file(s) and convert from leading to trailing comma convention
# 2nd arg is the root of the destination folder that will
use strict;
use warnings;
use Cwd qw(cwd);
#use lib "./build/jsb";
use Getopt::Long;       # command line arg helper
# Getopt DOCS --  http://www.vromans.org/johan/articles/getopt.html
#use FindJs; # must copy trunk/shell/build/jsb/*.pm into one of these include paths `perl -e "print qq(@INC)"`
use File::Basename;
use File::Find;
use File::Path qw(make_path);
use Digest::MD5;
use Term::ANSIColor qw(:constants);

# In Perl, you can't turn the buffering off, but you can get the same benefits by making the filehandle "hot".
# Whenever you print to a hot filehandle (STDOUT in our case), Perl flushes the buffer immediately.
# http://perl.plover.com/FAQs/Buffering.html
$| = 1;

# configure command line args parser
Getopt::Long::Configure('bundling'); #adds support for -fRu vs -f -r -u

my $help = 0;
my $recursive = 0;
my $unknown = 0;
my $mirror = 0;
my $verbose = 0;
my $debug = 0;
my $in;
my $out;
my $tplType;
my $ttlChanged = 0;

if ($#ARGV > 0){
    GetOptions(
       'i=s'   => \$in,     # read -i option as string into $file
       'o=s'   => \$out,    # read -o option as string into $file
       't=s'   => \$tplType,
       'r'     => \$recursive,
       'u'     => \$unknown,
       'm'     => \$mirror,
       'v'     => \$verbose,
       'h'     => \$help,
       'd'     => \$debug
    );
}

# figure as much out as we can for now
my $pwd = cwd; chomp($pwd);
print "* Current dir: $pwd\n" if $verbose;

# print usage
#qq~ http://www.tek-tips.com/viewthread.cfm?qid=1434394
if ($help || !$in || !$out){
    my $data = qq~
JavaScript Test Writer

USAGE: $0 [iortumvh]

    -i  Input file or folder to create a test for. Required.
    -o  Location to generate the new test files.  Required. 
        If the destination file already exists, the comment must include the MD5 checksum 
        the corresponds with the existing code.  If the checksum is missing or does not match, 
        then the file will not be modified.
    -r  Recursively process all subfolders if the input is a folder.  Default is false. 
        Automatically implies that the directory structure will be mirrored.
    -t  Template type to use instead of auto-detection. 
        The following values are supported: 
            'button', 'controller', 'form', 'generic', 'grid', 'menu', 'mixin', 'model', 'panel', 'store', 'tab', 'toolbar', 'tree', 'viewcontroller', 'window'
    -u  Write tests for types of classes that are not natively supported.  Default is false.
        If set to true, the default template type will be 'generic' unless otherwise specified 
        with the -t option.
    -m  Mirror the directory structure of the input folders into the output location.
        The input location must be a folder. TBD
    -v  Verbose output.  Warnings will always be printed.
    -h  This help message.
~;    
    print "$data";
    exit(0);
}

# processing recursively implies we need to mirror/create any missing sub-folders
if ($recursive){ $mirror = 1; }

print "Starting test generation:\n";
print "* Input:\t$in\n";
print "* Output:\t$out\n";
if ($verbose){
    if ($recursive){ print "* Recursive:\tYes\n"; }
    if ($tplType){ print "* Template:\t$tplType\n"; }
    if ($unknown){ print "* Unknown:\tYes\n"; }
    if ($mirror){ print "* Mirroring:\tYes\n"; }
    if ($verbose){ print "* Verbose:\tYes\n"; }
}

if ($mirror){
    mirror($in,$out);
}
main($in,$out);
print "\nTotal Files Modified: $ttlChanged\n";
print "\nDone:\n";

sub main {
    my ($input,$output) = @_;
    my ($base, $dir, $ext);
    
    if ($verbose){
        print "-" x 80; #repeat a character 
        print "\nProcessing $input\n";
    }
    print "#main($input, $output)\n" if $debug;
    
    if(-f $input){
        parseFile($input,$output);
    }elsif(-d $input){
        opendir(DIR, $input);
        my (@names) = readdir(DIR);
        closedir(DIR);
        # Loop thru directory, handle files and directories   
        my $name;
        foreach $name (@names) {
            chomp($name);
            
            # Ignore ".", "..", and hidden files
            next if ($name =~ m/^\./);
            
            if (-f "$input/$name"){
                if($name =~ /\.js$/) {  # only cache .js files for processing later
                    print "#js: $name\n" if $debug;
                    ($base, $dir, $ext) = fileparse("$input/$name",'\..*');
                    print "#fileparse: $input/$name\n" if $debug;
                    print "\tbase: $base\n\tdir: $dir\n\text: $ext\n" if $debug;
                    $base = lc($base);
                    parseFile("$input/$name","$output/$base.t.js");
                }
            }
            # check for sub-folders if we are supposed process everything
            if ($recursive){                
                if (-d "$input/$name"){
                    main("$input/$name","$output/$name");
                }
            }
        }
    }else{
        die("$input is not a file or directory\n");
    }
}


sub parseFile {
    my ($input, $output) = @_;
    my ($block,$class,$alias,$extend,$tplFile,$type,$str,$header,$ctx,$digest);
    
    print "\n" if $verbose;
    print "#parseFile($input, $output)\n" if $debug;
    
    $ctx = Digest::MD5->new;
    # if the file already exists, check if it has been modified
    if (-e $output){
        open(FH, "<$output");
        $block = do { local $/; <FH> };
        close(FH);
        # read the original checksum
        $block =~ m/Checksum:\s(.*?)[\n]/;
        # capture group 1 value checksum
        $digest = $1;
        if ((!defined $digest) || ($digest eq "")){
            logWarn("Skipped $input: checksum missing.\n", YELLOW);
            return;
        }
        # remove carriage returns
        $digest =~ s#\r##g; # unclear why chomp($digest) is not working...
        # remove the multiline header comment before calculating the md5
        $block =~ s#^/\*.*?\*/[\r]?\n##sg;
        $block =~ s#\r##sg;
        # print "\nParsed Code:\n$block\n\n";
        $ctx->add($block);
        my $newDigest = $ctx->hexdigest;
        print "Checksum from comment:\t$digest\n" if $verbose;
        print "Checksum from code:\t$newDigest\n" if $verbose;
        if ($digest eq $newDigest){
            print "Checksums match!\n" if $verbose;
        }
        # clear the data we loaded
        $ctx->reset;
        if ($digest ne $newDigest){
            logWarn("Skipped $input: checksums do not match. File has been modified.\n", RED);
            return;
        }
    }
    
    print "Read: $input\n" if $verbose;
    
    open(FH, "<$input");
    $block = do { local $/; <FH> };
    close(FH);
    
    # attempt to strip out any multi-line comments, which may include docs/examples that have some of the syntax we are trying to match
    $block =~ s/\/\*(?:(?!\*\/).)*\*\/\n?//sg;
    
    if($block !~ m/Ext\.define/){ next; }
    
    $block =~ m/Ext\.define\(['"](.*?)['"],/;
    # capture group 1 value is the class
    $class = $1;
    print "\t* class: $class\n" if $verbose;
    
    if($block =~ m/extend\s*:\s*['"](.*?)['"]/){
        $extend = $1;
        print "\t* extends: $extend\n" if $verbose;
    } else {
        $extend = "";
        print "\t* extends: NONE\n" if $verbose;
    }
    
    if($block =~ m/alias\s*:\s*['"](.*?)['"]/){
        $alias = $1;
        $alias =~ s/\widget\.//g;
        print "\t* alias: $alias\n" if $verbose;
    } else {
        $alias = "";
        print "\t* alias: NONE\n" if $verbose;
    }
    
    # check if the user specified a type to use
    if ($tplType){
        $type = $tplType;
    } else {
        # attempt to auto-detect the type of test template to use
        if (($extend =~ m/data\.Model$/i) || ($extend =~ m/data\.TreeModel$/i)){
            $type = 'model';
        } elsif (($extend =~ m/grid\.Panel/i) || ($extend =~ m/Grid$/i) || ($alias =~ m/grid$/i)){
            $type = 'grid';
        } elsif (($extend =~ m/tree\.Panel/i) || ($extend =~ m/Tree$/i) || ($alias =~ m/tree$/i)){
            $type = 'tree';
        } elsif (($extend =~ m/form\.Panel/i) || ($extend =~ m/Form$/i) || ($alias =~ m/form$/i)){
            $type = 'form';
        } elsif (($extend =~ m/tab\.Panel/i) || ($extend =~ m/Tab$/i) || ($alias =~ m/tab$/i)){
            $type = 'tab';
        } elsif (($extend =~ m/menu\.Menu/i) || ($extend =~ m/Menu$/i) || ($alias =~ m/menu$/i)){
            $type = 'menu';
        } elsif (($extend =~ m/Toolbar$/i) || ($alias =~ m/toolbar$/i)){
            $type = 'toolbar';
        } elsif (($extend =~ m/Window$/i) || ($alias =~ m/window$/i)){
            $type = 'window';
        } elsif (($extend =~ m/Panel$/i) || ($alias =~ m/panel$/i)){
            $type = 'panel';
        } elsif (($extend =~ m/Button/i) || ($alias =~ m/button$/i)){
            $type = 'button';
        } elsif (($extend =~ m/Store/i) || ($alias =~ m/store$/i)) {
            $type = 'store';
        # assume that files with an alias of controller are View Controllers
        } elsif (($extend =~ m/\.ViewController/i) || ($alias =~ m/controller\./i)){
            $type = 'viewcontroller';
        # make sure to test ViewController BEFORE app controller b/c a ViewController may extend a shared controller class
        } elsif (($extend =~ m/\.Controller$/i)){
            $type = 'controller';
        } elsif ($extend =~ m/Mixin$/i){
            $type = 'mixin';
        } elsif (($extend =~ m/data\.field\./i)) {
            $type = 'datafield';
        } elsif (($extend =~ m/Ext\.field\./i) || ($extend =~ m/form\.field/i)) {
            $type = 'formfield';
        } else {
            if ($unknown){
                $type = 'generic';
            } else {
                logWarn("Skipped $class: unknown type.\n", CYAN);
                return;
            }
        }
    }
    print "\t* type: $type\n" if $verbose;
    
    $tplFile = "$pwd/tpl/$type.t.js";
    open(TPL, "<$tplFile") || die("Couldn't open template '$tplFile'!");
    $str = do { local $/; <TPL> }; # read the entire file contents; http://www.perlmonks.org/?node_id=287647
    close(TPL);
    
    # variable substituion
    $str =~ s/\$\{class\}/$class/g;
    $str =~ s/\$\{alias\}/$alias/g;
    $str =~ s/\$\{extend\}/$extend/g;
    # calculate the md5 hash before we prepend the header comment
    $ctx->add($str);
    $digest = $ctx->hexdigest;
    # add header; a timestamp would be nice but that means all files would change everytime the script is executed.
    $header = qq~/**
 * This code was auto-generated by $0.
 * If you modify the code in any way, this file will no longer be automatically updated.
 * Source: $input
 * Template: $type
 * Checksum: $digest
 */
~;

    print "Write: $output\n" if $verbose;
#    print "\n$str\n";
    # must set :raw so windows doesn't write CRLF line feeds
    open(FH, ">:raw", "$output") or die "Cannot open stream for writing: $!\n";
    print FH "$header$str";
    close(FH);
    $ttlChanged++;
}

sub logWarn {
    my ($msg, $color) = @_;
    print $color, $msg, RESET;
}

sub mirror {
    my ($input,$output) = @_;

    if(!-d "$input"){
        die "Invalid input folder for mirroring: '$input'";
    }
    print "#mirror($input, $output)\n" if $debug;
    
#    my $rsyncExcludes = "excludes";
#    my $rsync = "rsync -zacO '$input/' '$output/' --exclude-from='$pwd/$rsyncExcludes'";
    
#    print "\nMirroring tree structure:\n$rsync\n" if $verbose;
#    open(SYNC,"$rsync |");
#    while(<SYNC>) {
#        print $_;
#    }
#    close(SYNC);

    # iterate all files based on $input
    &File::Find::find( sub {
        # skip files
        if (-f $_) {
#            print "Skip file: $_\n" if $verbose;
            return;
        }
        print "Scanning $_\n" if $verbose;

        # strip off the input folder from the current folder to get the remaining path that must be replicated
        my $temp = $File::Find::name =~ s/$input//r;
        # remove any leading directory separator
        $temp =~ s/^\///;

        my $target = "$pwd/$output/$temp";
#        print "target: $target\n" if $verbose;
        # create the directory if it doesn't exist
        if (!-d $target) {
            mkdir( $target ) or die "Couldn't create target directory, $!";
            print "Mirrored: $target\n" if $verbose;
        }
    }, $input);

    print "Mirrored $! \n";
}

# END OF FILE
