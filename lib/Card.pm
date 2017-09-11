use utf8;
use feature 'postderef', 'signatures';
package Card {
  use Moose;

  has id => (
    is => 'ro',
    isa => 'Str',
    required => 1
  );

  no Moose;
  __PACKAGE__->meta->make_immutable;
}
package SuitedCard {
  use Moose;
  extends 'Card';
  has suite => (is => 'ro', isa => 'Str', required => 1);
  has rank => (is => 'ro', isa => 'Str', required => 1);

  has '+id' => (lazy => 1, default => sub ($self) {
    $self->rank . $self->suite;
  });

  no Moose;
  __PACKAGE__->meta->make_immutable;
}
package Deck {
  use Moose;
  use List::Util qw//;
  use feature 'postderef';

  has cards => (
    is => 'ro',
    isa => 'ArrayRef[Card]',
    # this attribute is lazy so subclasses can generate their
    # cards in f(x) of attributes (f.ex with_jokers)
    lazy => 1,
    builder => '_build_deck'
  );

  sub shuffle ($self) {
    CardStash->new(cards => [ List::Util::shuffle $self->cards->@* ]);
  }

  no Moose;
  __PACKAGE__->meta->make_immutable;
}
package CardStash {
  use Moose;
  use List::Util;

  has cards => (
    is => 'rw',
    isa => 'ArrayRef[Card]',
    traits => [ 'Array' ],
    handles => {
      card_count => 'count'
    }
  );

  sub take ($self, $num_of_cards) {
    
    my $cc = $self->card_count;
    die "Can't take $num_of_cards from stash of $cc" if ($cc < $num_of_cards);

    my @pick;
    push @pick, shift $self->cards->@* for (1..$num_of_cards);
    CardStash->new(cards => \@pick);
  }

  no Moose;
  __PACKAGE__->meta->make_immutable;
}
package ItalianDeck {
  use Moose;
  extends 'Deck';

  sub _build_deck ($self) {
    my @deck;
    foreach my $suite ('Coppe', 'Bastoni', 'Spade', 'Denari') {
      foreach my $rank (1..7, 'J', 'Q', 'K') {
        push @deck, SuitedCard->new(suite => $suite, rank => $rank);
      }
    }
    return \@deck;
  }

  no Moose;
  __PACKAGE__->meta->make_immutable;
}

package SpanishDeck {
  use Moose;
  extends 'Deck';

  sub _build_deck ($self) {
    my @deck;
    foreach my $suite ('Copas', 'Bastos', 'Espadas', 'Oros') {
      foreach my $rank (1..7, 'J', 'Q', 'K') {
        push @deck, SuitedCard->new(suite => $suite, rank => $rank);
      }
    }
    return \@deck;
  }

  no Moose;
  __PACKAGE__->meta->make_immutable;
}
package FrenchDeck {
  use Moose;
  extends 'Deck';

  sub _build_deck ($self) {
    my @deck;
    foreach my $suite ('♠', '♣', '♥', '♦') {
      foreach my $rank (1..10, 'J', 'Q', 'K') {
        push @deck, SuitedCard->new(suite => $suite, rank => $rank);
      }
    }
    return \@deck;
  }

  no Moose;
  __PACKAGE__->meta->make_immutable;
}
1;
