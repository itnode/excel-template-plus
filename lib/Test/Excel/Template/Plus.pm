
package Test::Excel::Template::Plus;

use strict;
use warnings;

use Test::Deep    ();
use Test::Builder ();

use Spreadsheet::ParseExcel;

require Exporter;

our $VERSION = '0.01';
our @ISA     = ('Exporter');
our @EXPORT  = qw(cmp_excel_files);

# get the testing singleton ...
my $Test = Test::Builder->new;

sub cmp_excel_files ($$;$) {
    my ($file1, $file2, $msg) = @_;
    
    my $excel1 = Spreadsheet::ParseExcel::Workbook->Parse($file1);
    my $excel2 = Spreadsheet::ParseExcel::Workbook->Parse($file2);

    ## NOTE:
    ## Clean out some data bits that 
    ## dont seem to actually matter. 
    ## This is not perfect, so there
    ## might be others when comparing 
    ## other xls files. This works for 
    ## me now though.

    foreach (qw/File Font/) {
        $excel1->{$_} = undef;
        $excel2->{$_} = undef;
    }

    my $worksheet_count_1 = scalar @{$excel1->{Worksheet}};
    my $worksheet_count_2 = scalar @{$excel2->{Worksheet}};    
    
    if ($worksheet_count_1 != $worksheet_count_2) {
        $Test->ok(0, $msg);
        return;
    }

    foreach my $i (0 .. $worksheet_count_1) {
        foreach (qw/DefRowHeight _Pos/) {
            $excel1->{Worksheet}->[$i]->{$_} = undef;
            $excel2->{Worksheet}->[$i]->{$_} = undef;
        }
    }

    if (Test::Deep::eq_deeply($excel1, $excel2)) {
        $Test->ok(1, $msg);
    }
    else {
        $Test->ok(0, $msg);        
    }
}


1;

__END__

=pod

=head1 NAME 

Test::Excel::Template::Plus - 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 CODE COVERAGE

I use L<Devel::Cover> to test the code coverage of my tests, below 
is the L<Devel::Cover> report on this module's test suite.

=head1 AUTHOR

Stevan Little E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut