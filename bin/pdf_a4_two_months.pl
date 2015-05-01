#!/usr/bin/perl

=encoding UTF-8
=cut

=head1 DESCRIPTION

=cut

# common modules
use strict;
use warnings FATAL => 'all';
use feature 'say';
use utf8;
use open qw(:std :utf8);

use Carp;
use PDF::Create;
use Moment;
use boolean;

# global vars

# subs
sub create_pdf {
    my (%params) = @_;

    my $start_year_month = delete $params{start_year_month};
    my $file_name = delete $params{file_name};

    my ($year, $month) = $start_year_month =~ /^(\d{4})-(\d{2})$/a;
    my $day = Moment->new(
        year => $year,
        month => $month + 0,
        day => 1,
        hour => 0,
        minute => 0,
        second => 0,
    );

    my $pdf = PDF::Create->new(
        filename => $file_name,
    );

    my $a4 = $pdf->new_page('MediaBox' => $pdf->get_page_size('A4'));
    my $page = $a4->new_page;

    my $font = $pdf->font('BaseFont' => 'Helvetica');

    $page->set_width(0.2);
    my $max_x = 595;
    my $max_y = 842;

    my $padding_left_right = 80;
    my $padding_top = 170;
    my $square_side = int(($max_x - 2*$padding_left_right) / 7);

    $page->stringc(
        $font,
        20,
        int($max_x/2),
        $max_y - $padding_top + $square_side + $square_side/2,
        $start_year_month,
    );

    my $days_to_skip = $day->get_weekday_number( first_day => 'monday' ) - 1;
    my $skip_done = false;
    my $last_day = $day->get_month_end()->plus( day => 1)->get_month_end();

    WEEK:
    foreach my $i (1..11) {
        DAY:
        foreach my $j (1..7) {
            if (not $skip_done) {
                if ( $j <= $days_to_skip ) {
                    next DAY;
                }
            }
            $skip_done = true;

            draw_square(
                page => $page,
                x => $padding_left_right + ($j-1)*$square_side,
                y => $max_y - $padding_top - ($i-1)*$square_side,
                side => $square_side,
                font => $font,
                text => $day->get_day(),
            );
            $day = $day->plus( day => 1 );

            last WEEK if $day->cmp($last_day) != -1;
        }
    }

    $pdf->close;
}

sub draw_square {
    my (%params) = @_;

    my $page = delete $params{page};
    my $x = delete $params{x};
    my $y = delete $params{y};
    my $side = delete $params{side};
    my $font= delete $params{font};
    my $text = delete $params{text};

    $page->line($x, $y, $x+$side, $y);
    $page->line($x+$side, $y, $x+$side, $y+$side);
    $page->line($x+$side, $y+$side, $x, $y+$side);
    $page->line($x, $y+$side, $x, $y);

    $page->stringr($font, 10, $x+$side - 4, $y+$side - 10, $text);

    return false;
}

# main
sub main {

    my $start_year_month = $ENV{START_YEAR_MONTH};
    $start_year_month //= 'undef';

    if ($start_year_month !~ /^\d{4}-\d{2}$/a) {
        warn "Incorrect START_YEAR_MONTH. Expected YYYY-MM, for example 2015-04, but got $start_year_month.\n";
        exit 1;
    }

    create_pdf(
        start_year_month => $start_year_month,
        file_name => "/data/$start_year_month.pdf",
    );

    say "File `$start_year_month.pdf` is created.";

}
main();
