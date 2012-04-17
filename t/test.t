use FindBin;
use lib "$FindBin::Bin/lib";
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

## time zone attribute tests
$dtn = HTML::FormHandlerX::Field::DateTimeNatural->new(name => 'dtn');
isa_ok $dtn->time_zone, 'DateTime::TimeZone::Floating';

$dtn = HTML::FormHandlerX::Field::DateTimeNatural->new(name => 'dtn', time_zone => 'UTC');
isa_ok $dtn->time_zone, 'DateTime::TimeZone::UTC';

$dtn = HTML::FormHandlerX::Field::DateTimeNatural->new(name => 'dtn', time_zone => DateTime::TimeZone::UTC->new);
isa_ok $dtn->time_zone, 'DateTime::TimeZone::UTC';

## time zone form inheritance tests
use_ok 'DateTimeNaturalTestForm';

my $dtntf = DateTimeNaturalTestForm->new();
isa_ok $dtntf, 'DateTimeNaturalTestForm';
ok ! $dtntf->time_zone, 'Form time zone not defined';
isa_ok $dtntf->field('datetimenatural')->time_zone, 'DateTime::TimeZone::Floating';

$dtntf = DateTimeNaturalTestForm->new(time_zone => 'UTC');
isa_ok $dtntf, 'DateTimeNaturalTestForm';
isa_ok $dtntf->time_zone, 'DateTime::TimeZone::UTC';
isa_ok $dtntf->field('datetimenatural')->time_zone, 'DateTime::TimeZone::UTC';

done_testing;
# eof
