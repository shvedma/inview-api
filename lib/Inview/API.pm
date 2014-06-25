package Inview::API;
use Dancer ':syntax';

use Inview::API::Service;
use Inview::API::Alert;

use Dancer::Plugin::REST;


our $VERSION = '0.1';

hook 'before' => sub {
  # this is not ideal but this is where we'll do auth and authorisation        
  # from InviewAuthen and InviewAuthz
  # makes sense to combine?

  # blah blah and eventually user from we get user id and company id 
  # my $ret = Oriel::Apache2::InviewSessionCache::get_session( $session );
  # and put it into dancer session;
  # if good - set up session.
  # if no session - try to do Inview-related authen and authz and then either
  # 403 or set up session.
  session 'user' => 'blah';
  return halt(status_forbidden ("Bad user no cookie")) if (! session('user'));
};

get '/' => sub {
    template 'index';
};

true;
