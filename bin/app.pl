#!/usr/bin/env perl
use Dancer;
use Inview::API;

use Plack::Builder;

my $app = sub {
    my $env     = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};

builder {
    enable "Auth::Basic", authenticator => sub {
        # stub to do authentication and authorisation - get cookie etc.
        # from InviewAuthen and InviewAuthz
        # makes sense to combine?

        # blah blah and eventually user from we get user id and company id 
        # my $ret = Oriel::Apache2::InviewSessionCache::get_session( $session );
        debug "HAHA working";
        session 'user' => 'blah'; 
        1;
        
    };
    $app;
};

dance;
