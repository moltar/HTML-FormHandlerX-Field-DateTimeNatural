use Test::More;

BEGIN { use_ok('HTML::FormHandlerX::Field::DateTimeNatural'); }

my $dtn = HTML::FormHandlerX::Field::DateTimeNatural->new(name => 'dtn');

for ('today', 'yesterday', '5am yesterday') {
    $dtn->_set_input($_);
    $dtn->validate_field;
    ok !$dtn->has_errors, "Pass: $_";
}

for ('abracadabra', '25:00') {
    $dtn->_set_input($_);
    $dtn->validate_field;
    ok $dtn->has_errors, "Fail: $_";
}

$dtn = HTML::FormHandlerX::Field::DateTimeNatural->new(
    name => 'dtn',
    time_zone => 'UTC',
);
$dtn->_set_input('today');
ok $dtn->validate_field, 'Field is valid';
is $dtn->value->time_zone->name, 'UTC', 'Time Zone was set';



done_testing;
# eof
