#!/usr/bin/env perl

use Test::Exception;
use Test::More;
use Card;
use feature 'postderef';

foreach $deck_type ('FrenchDeck', 'SpanishDeck', 'ItalianDeck') {
  my $deck = $deck_type->new;

  { 
    my $orig = join ',', map { $_->id } $deck->cards->@*;
  
    my $s1 = $deck->shuffle;
    my $d1 = join ',', map { $_->id } $s1->cards->@*;
  
    cmp_ok($d1, 'ne', $orig, 'Cards were shuffled');
  
    my $s2 = $deck->shuffle;
    my $d2 = join ',', map { $_->id } $s2->cards->@*;
   
    cmp_ok($d2, 'ne', $orig, 'Cards were reshuffled');
    cmp_ok($d1, 'ne', $d2  , 'Cards were reshuffled differently from first attempt');
  }

  my $stack = $deck->shuffle;
  my $initial_count = $stack->card_count;
  
  my $hand1 = $stack->take(5);
  cmp_ok($hand1->card_count, '==', 5);
  cmp_ok($stack->card_count, '==', $initial_count - 5);
  
  my $hand2 = $stack->take(10);
  cmp_ok($hand2->card_count, '==', 10);
  cmp_ok($stack->card_count, '==', $initial_count - 5 - 10);
  
  throws_ok sub {
    my $hand3 = $stack->take(100);
  }, qr/Can't take/;
  
  my $hand4 = $stack->take( $stack->card_count );
  cmp_ok($hand4->card_count, '==', $initial_count - 5 - 10);
  cmp_ok($stack->card_count, '==', 0);
  
  throws_ok sub {
    my $hand5 = $stack->take(1);
  }, qr/Can't take/;
}

done_testing;
