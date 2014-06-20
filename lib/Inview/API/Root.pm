use Dancer ':syntax';
use Dancer::Plugin::REST;
use Dancer::Plugin::Chain;


my $chain  = chain '/services/:sid' => sub {
  return halt(status_not_found('Service '. param('sid').' not found')) unless param('sid') eq '123';

  # get Inview::Service object
  var 'sid' => param('sid');
  # TODO: return service object
  return status_ok({ sid => var('sid')});
};

get chain $chain;
