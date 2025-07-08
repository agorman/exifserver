# test.t
use Test::More;
use Plack::Test;
use HTTP::Request::Common qw(GET);

my $app = do './app.psgi'; # Load your PSGI app

test_psgi $app, sub {
    my $cb = shift;
    my $req = HTTP::Request->new(GET => 'http://localhost/'); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 405, "Response code is 200"; # Assert the response code

    my $header = ['Content-Type' => 'application/json; charset=UTF-8'];
    my $data = {};
    my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new(POST => 'http://localhost/', $header, $encoded_data); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 400, "Response code is 400"; # Assert the response code

    my $header = ['Content-Type' => 'application/json; charset=UTF-8'];
    $data = {path => 't/img.jpg', options => []};
    my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new(POST => 'http://localhost/', $header, $encoded_data); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 400, "Response code is 400"; # Assert the response code

    my $header = ['Content-Type' => 'application/json; charset=UTF-8'];
    $data = {path => 't/img.jpg', options => {}, tags => {}};
    my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new(POST => 'http://localhost/', $header, $encoded_data); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 400, "Response code is 400"; # Assert the response code

    $data = {path => 'bar'};
    my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new(POST => 'http://localhost/', $header, $encoded_data); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 404, "Response code is 404"; # Assert the response code

    $data = {path => 't/img.jpg'};
    my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new(POST => 'http://localhost/', $header, $encoded_data); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 200, "Response code is 200"; # Assert the response code
    my $info = decode_json($res->content);
    is $info->{FileType}, 'JPEG', 'FileType is JPEG';

    $data = {path => 't/empty.jpg'};
    my $encoded_data = encode_json($data);
    my $req = HTTP::Request->new(POST => 'http://localhost/', $header, $encoded_data); # Construct HTTP request
    my $res = $cb->($req); # Send the request to the app
    is $res->code, 500, "Response code is 200"; # Assert the response code
    my $info = decode_json($res->content);
    is $info->{Error}, 'File is empty', 'Error reading file';
};

done_testing;