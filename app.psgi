#!/usr/bin/perl
use strict;
use warnings;
use Plack::Request;
use JSON::XS;
use Image::ExifTool;
use Try::Tiny;

my $exifTool = Image::ExifTool->new;

# Adding allow_unknown so that binary data that can't be encoed
# is skipped instead of thowing an error.
my $json = JSON::XS->new->utf8->allow_unknown;

my $app = sub {
	my $env = shift;

	my $req = Plack::Request->new($env);

	if ($req->method ne "POST") {
		return error($req, 405, "Method not allowed");
	}

	my $req_body;
	my $error = try {
		$req_body = $json->decode($req->content);

		if (!exists $req_body->{path}) {
			return "Path required in request body";
		}

		# Set options to an empty hash ref if it doesn't exist.
		$req_body->{options} = {} unless $req_body->{options};

		# If tags have been sent by the user ensure that the Error tag is always returned.
		if ($req_body->{tags}) {
			push @{$req_body->{tags}}, "Error";
		}

		# Set tags to an empty array ref if it doesn't exist.
		$req_body->{tags} = [] unless $req_body->{tags};

		# Ensure options is the correct type
		if (ref $req_body->{options} ne 'HASH') {
			return "options must be an object";
		}

		# Ensure tags is the correct type
		if (ref $req_body->{tags} ne 'ARRAY') {
			return "tags must be an array";
		}

		# return nothing on success because anything returned is treated as an error
		return;
	} catch {
		return $_;
	};
	if ($error) {
		return error($req, 400, "Invalid JSON in request body: $error");
	}

	if (!-f $req_body->{path}) {
		return error($req, 404, "No such file: " . $req_body->{path});
	}

	my $all = $exifTool->ImageInfo($req_body->{path}, $req_body->{options}, $req_body->{tags});
	my $has_error = exists $all->{Error};
	
	# Append Group name to the tag name in for form group name/tag name
	if ($req_body->{format_groups}) {
		my $all_with_groups = {};
		# Iterate through the extracted tags and print the tag key, value, and group name
		foreach my $tag_key (keys %$all) {
			my $group = $exifTool->GetGroup($tag_key);
			if ($group) {
				if ($req_body->{format_groups} == 1) {
					$all_with_groups->{"$group:$tag_key"} = $all->{$tag_key};
				} else {
					$all_with_groups->{$group}->{$tag_key} = $all->{$tag_key};
				}
			}
		}

		$all = $all_with_groups;
	}

	my $res_body;
	$error = try {
		$res_body = $json->encode($all);

		# return nothing on success because anything returned is treated as an error
		return;
	} catch {
		return $_;
	};
	if ($error) {
	    return error($req, 400, "Error encoding JSON: $error");
	}

	my $res = $req->new_response(200);
	if ($has_error) {
		$res = $req->new_response(500);
	}

	$res->content_type('application/json; charset=utf-8');
	$res->body($res_body);
	return $res->finalize;
};

sub error {
	my ( $req, $code, $msg ) = @_;

	my $res = $req->new_response($code);
	$res->content_type('application/json; charset=utf-8');
	$res->body(sprintf('{"error":"%s"}', $msg));
	return $res->finalize;
};
