use Dancer ':syntax';
use Dancer::Plugin::REST;
use Dancer::Plugin::Chain;

# dispatch to GET /alerts
my $chain  = chain '/alerts' => sub {
  # return if no alerts :)
  
  # return Alerts;
  my $alerts = [{ alert => 'blah' }, { alert => 'foo' }];
 
  return status_ok($alerts);
};
get chain $chain;

# dispatch to GET /alerts/<ID>
get chain $chain, '/:alertid' => sub {
  # return if no Alerts;
  
  # return Alerts;
  my $alerts = { alert => param('alertid') };
 
  return status_ok($alerts);
};



