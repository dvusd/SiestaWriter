#!/usr/bin/perl

# 1st arg is the root of the source folder to mimic, will parse recrusively all js file(s) and convert from leading to trailing comma convention
# 2nd arg is the root of the destination folder that will
use strict;
#use lib "./build/jsb";
use Getopt::Long;       # command line arg helper
# Getopt DOCS --  http://www.vromans.org/johan/articles/getopt.html
#use FindJs; # must copy trunk/shell/build/jsb/*.pm into one of these include paths `perl -e "print qq(@INC)"`
use File::Basename;
use Digest::MD5;

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
my $warnings = "";
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
my $pwd = `readlink -e "$0"`;     chomp($pwd);
$pwd =~ s#^(.*)/.*$#$1#g; # dirname($pwd)
#print "Current dir: $pwd\n";

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
            'button', 'controller', 'form', 'generic', 'grid', 'menu', 'model', 'panel', 'store', 'tab', 'toolbar', 'tree', 'window'
    -u  Write tests for types of classes that are not natively supported.  Default is false.
        If set to true, the default template type will be 'generic' unless otherwise specified 
        with the -t option.
    -m  Mirror the directory structure of the input folders into the output location. 
        The input location must be a folder. 
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
if ($warnings ne ""){
    print "\nWARNINGS:\n$warnings\n";
}
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
        $digest = $1;
        if (($digest eq "") || ($digest eq undef)){
            logWarn("Skipped $input: checksum missing.\n");
            return;
        }
        print "Checksum from comment:\t$digest\n" if $verbose;        
        # remove the multiline header comment before calculating the md5
        $block =~ s#^/\*.*?\*/\n##sg;
#        print "\nRemove comment:\n$block\n\n";
        $ctx->add($block);
        my $newDigest = $ctx->hexdigest;
        print "Checksum from code:\t$digest\n" if $verbose;
        if ($digest eq $newDigest){
            print "Values Match!\n" if $verbose;
        }
        # clear the data we loaded
        $ctx->reset;
        if ($digest ne $newDigest){
            logWarn("Skipped $input: checksums do not match. File has been modified.\n");
            return;
        }
    }
    
    print "Read: $input\n" if $verbose;
    
    open(FH, "<$input");
    $block = do { local $/; <FH> };
    close(FH);
    
    # attempt to strip out any multi-line comments, which may include docs/examples that have some of the syntax we are trying to match
    $block =~ s#/\*.*?\*/\n##sg;
    
    if($block !~ m/Ext\.define/){ next; }
    
    $block =~ m/Ext\.define\(['"](.*?)['"],/;
    $class = $1;
    print "\t* class: $class\n" if $verbose;
    
    if($block =~ m/extend\s*:\s*['"](.*?)['"]/){
        $extend = $1;
        print "\t* extends: $extend\n" if $verbose;
    }
    
    if($block =~ m/alias\s*:\s*['"](.*?)['"]/){
        $alias = $1;
        $alias =~ s/\widget\.//g;
        print "\t* alias: $alias\n" if $verbose;
    }    
    
    # check if the user specified a type to use
    if ($tplType){
        $type = $tplType;
    } else {
        # attempt to auto-detect the type of test template to use
        if ($extend =~ m/Ext\.data\.Model/){
            $type = 'model';
        } elsif (($extend =~ m/grid\.Panel/) || ($extend =~ m/Grid$/) || ($alias =~ m/grid$/)){
            $type = 'grid';
        } elsif (($extend =~ m/tree\.Panel/) || ($extend =~ m/Tree$/) || ($alias =~ m/tree$/)){
            $type = 'tree';
        } elsif (($extend =~ m/form\.Panel/) || ($extend =~ m/Form$/) || ($alias =~ m/form$/)){
            $type = 'form';
        } elsif (($extend =~ m/tab\.Panel/) || ($extend =~ m/Tab$/) || ($alias =~ m/tab$/)){
            $type = 'tab';
        } elsif (($extend =~ m/menu\.Menu/) || ($extend =~ m/Menu$/) || ($alias =~ m/menu$/)){
            $type = 'menu';
        } elsif (($extend =~ m/Toolbar$/) || ($alias =~ m/toolbar$/)){
            $type = 'toolbar';
        } elsif (($extend =~ m/Window$/) || ($alias =~ m/window$/)){
            $type = 'window';
        } elsif (($extend =~ m/Panel$/) || ($alias =~ m/panel$/)){
            $type = 'panel';
        } elsif (($extend =~ m/Button/) || ($alias =~ m/button$/)){
            $type = 'button';
        } elsif (($extend =~ m/Store/) || ($alias =~ m/store$/)){
            $type = 'store';
        } elsif ($extend =~ m/app\.Controller/){
            $type = 'controller';
        } else {
            if ($unknown){
                $type = 'generic';
            } else {
                logWarn("Skipped $class: unknown type.\n");
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
    # calculate the md5 hash w/o the header
    $ctx->add($str);
    $digest = $ctx->hexdigest;
    # add header; a timestamp would be nice but that means all files would change everytime the script is executed.
    $header = qq~/**
 * This code was auto-generated by $0.
 * If you modify the code in any way, this file will no longer be automatically updated.
 * Template: $type
 * Checksum: $digest
 */
~;
    
    print "Write: $output\n" if $verbose;
#    print "\n$str\n";
    open(FH,">$output");
    print FH "$header$str";
    close(FH);
    $ttlChanged++;
}

sub logWarn {
    my ($msg) = @_;
    print $msg if $verbose;
    $warnings .= $msg;
}

sub mirror {
    my ($input,$output) = @_;
    
    if(!-d "$input"){
        die "Invalid input folder for mirroring: '$input'";
    }
    print "#mirror($input, $output)\n" if $debug;
    
    my $rsyncExcludes = "excludes";
    my $rsync = "rsync -zacO '$input/' '$output/' --exclude-from='$pwd/$rsyncExcludes'";
    
    print "\nMirroring tree structure:\n$rsync\n" if $verbose;
    open(SYNC,"$rsync |");
    while(<SYNC>) {
        print $_;
    }
    close(SYNC);
    print "\n";
}

# END OF FILE
