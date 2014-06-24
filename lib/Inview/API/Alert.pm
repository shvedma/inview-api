use Dancer ':syntax';
use Dancer::Plugin::REST;

# dispatch to GET /alerts
get '/alerts' => sub {
  return status_ok('blerg!') if param('service_id');
  # return if no alerts
  # return Alerts;
  my $alerts = [{ alert => 'blah' }, { alert => 'foo' }];
 
  return status_ok($alerts);
};

# dispatch to GET /alerts/<ID>
get '/alerts/:alertid' => sub {
  # return if no Alerts;
  
  # return Alerts;
  my $alerts = { alert => param('alertid') };
 
  return status_ok($alerts);
};



