#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use open qw(:std :encoding(UTF-8));

sub unslop_prose {
    my ($text) = @_;
    $text =~ s/^(\s*(?:[-*]\s+)?)\*\*([^*\n]+)\*\*\s*—\s*([[:lower:]])/$1 . '**' . $2 . '.** ' . uc($3)/e;
    $text =~ s/\s+—\s+/, /g;
    $text =~ s/—\s*/, /g;
    $text =~ s/“/"/g;
    $text =~ s/”/"/g;
    $text =~ s/‘/'/g;
    $text =~ s/’/'/g;
    return $text;
}

sub unslop_line {
    my ($line) = @_;
    my $output = '';
    my $cursor = 0;
    my $length = length($line);

    while ($cursor < $length) {
        my $opener_start = index($line, '`', $cursor);
        if ($opener_start < 0) {
            $output .= unslop_prose(substr($line, $cursor));
            last;
        }

        my $opener_end = $opener_start;
        $opener_end++ while $opener_end < $length && substr($line, $opener_end, 1) eq '`';
        my $delimiter_length = $opener_end - $opener_start;
        my $search = $opener_end;
        my $closer_end = -1;

        while ($search < $length) {
            my $run_start = index($line, '`', $search);
            last if $run_start < 0;
            my $run_end = $run_start;
            $run_end++ while $run_end < $length && substr($line, $run_end, 1) eq '`';
            if ($run_end - $run_start == $delimiter_length) {
                $closer_end = $run_end;
                last;
            }
            $search = $run_end;
        }

        if ($closer_end < 0) {
            $output .= unslop_prose(substr($line, $cursor));
            last;
        }

        $output .= unslop_prose(substr($line, $cursor, $opener_start - $cursor));
        $output .= substr($line, $opener_start, $closer_end - $opener_start);
        $cursor = $closer_end;
    }

    return $output;
}

my $fence_character = '';
my $fence_length = 0;

while (<>) {
    if (!$fence_length && /^\s*(`{3,}|~{3,})/) {
        my $marker = $1;
        $fence_character = substr($marker, 0, 1);
        $fence_length = length($marker);
        print;
        next;
    }
    if ($fence_length) {
        if (/^\s*(`+|~+)\s*$/) {
            my $marker = $1;
            if (substr($marker, 0, 1) eq $fence_character && length($marker) >= $fence_length) {
                $fence_character = '';
                $fence_length = 0;
            }
        }
        print;
        next;
    }

    print unslop_line($_);
}
