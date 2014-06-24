package Inview::API;
use Dancer ':syntax';

use Inview::API::Service;
use Inview::API::Alert;

use Dancer::Plugin::REST;


our $VERSION = '0.1';

hook 'before' => sub {
  return halt(status_forbidden ("Bad user no cookie")) if (! session('user'));
};

get '/' => sub {
    template 'index';
};

true;
