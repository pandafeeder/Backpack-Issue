use strict;
use List::Util qw/sum/;

open my $fh, '<', $ARGV[0];
my %data;
my $i;
my $first_line = <$fh>;
my ($all_count, $bag_volum) = split /\s/, $first_line;

while (<$fh>) {
  my ($v, $w) = split /\s/, $_;
  my $p = $v/$w;
  $data{$i} = [$v, $w, $p];
  $i++;
}

my @sorted = sort { $a->[2] <=> $b->[2] } values %data;
my @sorted_r = reverse @sorted;

sub iterator {
  my $i = -1;
  my @arr_internal = @_;
  sub { $i++; $arr_internal[$i] };
}

my $it = iterator(@sorted_r);
my @take;
sub cal {
  my ($left) = @_;
  while ($left > 0) {
    my $item = $it->();
    return unless defined $item;
    push @take, $item;
    $left -= $item->[1];
print "CURRENT ITEM WEIGHT: ",$item->[1],$/;
print "LEFT: ",$left,$/;
#print "-----\n";
    if ($left < 0) {
      pop @take;
      $left += $item->[1];
      last;
    }
  }
  cal ($left);
}
cal($bag_volum);

my @t_value; 
my @t_weight;

for my $item (@take) {
  push @t_value, $item->[0];
  push @t_weight, $item->[1];
}

print "#############\n";
print "sum of value: ";
print sum @t_value;
print $/;
print "sum of weight: ";
print sum @t_weight;
print $/;
print "count of items used: ";
print scalar @t_weight;
