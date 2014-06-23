use Dancer ':syntax';
use Dancer::Plugin::REST;
use Dancer::Plugin::Chain;

use Data::Dumper;
use JSON::XS;
# match /service/<SERVICE ID>

my $service_chain  = chain '/services/:sid' => sub {
    return halt(status_not_found('Service '. param('sid').' not found')) unless param('sid') eq '123';

    # get Inview::Service object
    # stash sid
    var 'sid' => param('sid');
};

# Graphs

# match /graphs
my $graph_chain = chain '/graphs' => sub {

    # get Inview graphs here;
    my $graphs = [
    {
      "sid"=> var('sid'),
      "id" => 'graph1',
      "label"=> "Ping Success/Latency",
      "url_png_small"=> "URL",
      "url_png_large"=> "URL",
      "url_js_small"=> "URL",
      "url_js_large"=> "URL",
      "url_js_custom"=> "URL"
    },
    {
      "sid"=> var('sid'),
      "id" => 'graph2',
      "label"=> "NBAR Download",
      "url_png_small"=> "URL",
      "url_png_large"=> "URL",
      "url_js_small"=> "URL",
      "url_js_large"=> "URL",
      "url_js_custom"=> "URL"
    }];

    var 'graphs' => $graphs;
    return status_ok($graphs);
};

# match /<GRAPH ID>
my $graph_chain_id = chain '/:gid' => sub {
    
    # graph from pre-loaded stash
    my @graph = map { $_ } 
                grep { $_->{id} eq param('gid') } 
                @{ var('graphs') };
    
    return halt(status_not_found('Graph id ' . param('gid') . ' not found'))
        unless @graph;
    
    var 'gid' => param('gid');
    
    return status_ok(@graph);
};

# match /data
my $graph_data = chain '/data' => sub {
    # get graph data here;
    my $data = { 'i am' => 'graph data for '. var('gid') };
    return status_ok($data);
};

# dispatch to GET /service/<SERVICE ID>/graphs
get chain $service_chain, $graph_chain;

# dispatch to GET /service/<SERVICE ID>/graphs/<GRAPH ID>
get chain $service_chain, $graph_chain, $graph_chain_id;

# dispatch to GET /service/<SERVICE ID>/graphs/<GRAPH ID>/data
get chain $service_chain, $graph_chain, $graph_chain_id, $graph_data;

# Thresholds

# match /check_thresholds
my $threshold_chain = chain '/check_thresholds' => sub {
    
    # Load Inview Threshlods;
    my $tlds = [
    {
      "sid"=> var('sid'),
      "id" => 't1',

    },
    {
      "sid"=> var('sid'),
      "id" => 't2',
    }];
    var 'tlds' => $tlds;
    return status_ok($tlds);
};

my $threshold_chain_id = sub {
  # thresholds from pre-loaded stash
  my @tld = map { $_ } 
            grep { $_->{id} eq param('tid') } 
            @{ var('tlds') };
  
  return halt(status_not_found('Threshold id ' . param('tid') . ' not found'))
      unless @tld;
  
  var 'tld' => @tld;
  var 'tid' => param('tid');

};

# matches /<THRESHOLD ID>
my $threshold_chain_id_get = chain '/:tid' => sub {           
    
  return status_ok(var('tld'));
};

my $threshold_chain_id_put = chain '/:tid' => sub {

  return status_unsupported_media_type("request occurred without application/json content type")
    unless (request->headers->content_type eq 'application/json');
  
  # TODO: serialise elegantly dammit!
  my $body = decode_json(request->body);
  for my $field(qw{ check_value failure_time }) {
    
    debug Dumper($body);
    return status_unprocessable_entity("Missing field $field") unless $body->{$field};
  }
  
  return status_unprocessable_entity("Bad check_value ". $body->{'check_value'} .". Allowed values are: 10, 15, 20, 25, 30 ")
    unless grep{ $body->{'check_value'} eq $_ } qw(10 15 20 25 30);

  # update threshold here 

  return status_ok(var('tid')); 
};

# dispatch to GET /service/<SERVICE ID>/check_thresholds
get chain $service_chain, $threshold_chain;

# dispatch to GET /service/<SERVICE ID>/check_thresholds/<THRESHOLD ID>
get chain $service_chain, $threshold_chain, $threshold_chain_id, $threshold_chain_id_get;

# dispatch to PUT /service/<SERVICE ID>/check_thresholds/<THRESHOLD ID>
put chain $service_chain, $threshold_chain, $threshold_chain_id, $threshold_chain_id_put;
