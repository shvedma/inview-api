package Inview::API;
use Dancer ':syntax';

use Inview::API::Service;
use Inview::API::Alert;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

true;
