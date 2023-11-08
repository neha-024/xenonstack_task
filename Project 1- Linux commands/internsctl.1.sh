.TH internsctl 1 "10 June 2023" "0.1.0" "Custom Command"
.SH NAME 
"internsctl"
.SH SYNOPSIS
internsctl cpu getinfo |
.brinternsctl memory getinfo |
.brinternsctl user create <username> |
internsctl user list |
internsctl user list --sudo-only |
internsctl file getinfo <file-name> |
internsctl file getinfo [options] <file-name> 
.SH DESCRIPTION
Display cpu and memory information, create new user, list all users, list all users with sudo permissions, get file information, get specific  information of file.  
.SH OPTIONS
.TP
.BR \-\-size ", " \-s			print " " file " " size
.TP
.BR \-\-permissions ", " \-p		print " " file " " permissions
.TP
.BR \-\-owner ", " \-o			print " " file " " owner
.TP
.BR \-\-last-modified ", " \-m		print " " last " " modified " " date " " and " " time " " of " " the " " file
.SH BUGS
No known bugs. (However reach at krishnamandhane08@gmail.com in case of any errors and typos.)
.SH AUTHOR
Krishna Mandhane