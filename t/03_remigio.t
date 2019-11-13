#!/usr/bin/env perl

use Test::Exception;
use Test::More;
use Card;
use feature 'postderef';

my $r = Remigio->new(
  player_names => [ 'John', 'Carrie' ],
);

cmp_ok($r->current_player->name, 'eq', 'John');
$r->next_turn;
cmp_ok($r->current_player->name, 'eq', 'Carrie');
$r->next_turn;
cmp_ok($r->current_player->name, 'eq', 'John');

use Data::Dumper;

print Dumper($r);


done_testing;
