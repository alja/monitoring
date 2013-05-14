#!/usr/bin/env perl

use IO::Handle;

$log="/tmp/pg_dump.log";
open STDOUT, "> ", $log or die $!;
open STDERR, ">&STDOUT" or die $!;

# name of backup file
$dir="/mldb/sql_backup/";
$fname=$dir;
$fname .= "sql_dumpall_";
$fname .= `date +%F`; 
chomp($fname);
$fname .= ".gz";


system("date");

printf("\nBacking-up into file $fname ...\n");
$ENV{LD_LIBRARY_PATH}="/home/repository/MLrepository/pgsql_store/lib";
$ENV{PATH}="/home/repository/MLrepository/pgsql_store/bin:$ENV{PATH}";

print("time pg_dumpall | gzip > $fname \n");
system("time pg_dumpall | gzip > $fname");
print "\nBackuped file stat ...\n";
system("ls -l $fname");
system("du -h $fname");

printf("\nSpace left on partition:\n");
system("df -h $dir");

# mail
$subj = 'xrootd.t2-database-backup';
$add='amraktadel@ucsd.edu mtadel@ucsd.edu';
$cmd="cat $log | mail -s $subj baq $add"; 
` $cmd`;