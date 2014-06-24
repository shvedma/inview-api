use Dancer ':syntax';
use Dancer::Plugin::REST;
use Dancer::Plugin::Chain;

use Data::Dumper;
use JSON::XS;

# match /service/<SERVICE ID>

my $service_link  = chain '/services/:sid' => sub {
    return halt(status_not_found('Service '. param('sid').' not found')) unless param('sid') eq '123';

    # get Inview::Service object
    # stash sid
    var 'sid' => param('sid');
};



# Graphs

# dispatch to GET /service/<SERVICE ID>/graphs

get chain $service_link, '/graphs' => sub {

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

    debug "matching BIG graphs";

    var 'graphs' => $graphs;
    return status_ok($graphs);
};

# match /graphs/<GRAPH ID>

my $graph_link  = chain '/graphs/:gid' => sub {        
  # return halt(status_not_found('Graph id ' . param('gid') . ' not found'))
  #   unless @graph;
    
  var 'gid' => param('gid');    
  return status_ok(var('gid'));
};

# dispatch to GET /service/<SERVICE ID>/graphs/<GRAPH ID>

get chain $service_link, $graph_link;

# match /data

my $graph_data = chain '/data' => sub {
    # get graph data here;
    my $data = { 'i am' => 'graph data for '. var('gid') };
    return status_ok($data);
};

# dispatch to GET /service/<SERVICE ID>/graphs/<GRAPH ID>/data

get chain $service_link, $graph_link, $graph_data;



# Thresholds

# dispatch to GET /service/<SERVICE ID>/check_thresholds

get chain $service_link, '/check_thresholds' => sub {
    
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


# dispatch to GET /service/<SERVICE ID>/check_thresholds/<THRESHOLD ID>

get chain $service_link, '/check_thresholds/:tid' => sub {           
  debug "Loading a threshold";
  
  return halt(status_not_found('Threshold '. param('tid').' not found')) unless param('tid') eq '123';
  var 'tid' => param('tid');
  return status_ok({ 'tid' => var('tid')});
};


# NB: would make sense to chain loading of threshold to updating it and only update if exists, 
# however that would imply validation on PUT only occuring after GETting of threshold, which
# to me makes no logical sense - what's the point of pre-loading item if request is wrong.
# TODO: maybe a fancy dispatch

# dispatch to PUT /service/<SERVICE ID>/check_thresholds/<THRESHOLD ID>

put chain $service_link, '/check_thresholds/:tid' => sub {

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

  # check if exists and update threshold: return unless 

  return status_ok(var('tid')); 
};
