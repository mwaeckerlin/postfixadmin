<?php

$CONF['configured'] = true;

$CONF['database_type'] = getenv('DATABASE_TYPE');
$CONF['database_host'] = getenv('DATABASE_HOST');
$CONF['database_user'] = getenv('DATABASE_USER');
$CONF['database_password'] = getenv('DATABASE_PASSWORD');
$CONF['database_name'] = getenv('DATABASE_NAME');
$CONF['setup_password'] = getenv('SETUP_PASSWORD');

$CONF['emailcheck_resolve_domain'] = getenv('EMAILCHECK_RESOLVE_DOMAIN') ?: 'YES';

$CONF['default_aliases'] = array();
if (getenv('DEFAULT_ALIASES') && (getenv('DEFAULT_ALIASES_DOMAIN') || getenv('DEFAULT_ALIASES_ADDRESS'))) {
    $default_aliases = explode(' ', getenv('DEFAULT_ALIASES'));
    foreach ($default_aliases as $alias) {
        $CONF['default_aliases'][$alias] = getenv('DEFAULT_ALIASES_ADDRESS') ? getenv('DEFAULT_ALIASES_ADDRESS') : $alias . '@' . getenv('DEFAULT_ALIASES_DOMAIN');
    }
}

$CONF['aliases'] = getenv('ALIASES');
$CONF['mailboxes'] = getenv('MAILBOXES');
$CONF['maxquota'] = getenv('MAXQUOTA');
$CONF['domain_quota_default'] = getenv('DOMAIN_QUOTA_DEFAULT');

if (getenv('VACATION_DOMAIN')) {
    $CONF['vacation_domain'] = getenv('VACATION_DOMAIN');
}

$CONF['show_footer_text'] = getenv('FOOTER_TEXT') ? 'YES' : 'NO';
$CONF['footer_text'] = getenv('FOOTER_TEXT');
$CONF['footer_link'] = getenv('FOOTER_LINK');

if (getenv('WELCOME_TEXT')) {
    $CONF['welcome_text'] = getenv('WELCOME_TEXT');
}

if (getenv('SHOW_CUSTOM_DOMAINS')) {
    $CONF['show_custom_domains'] = explode(' ', getenv('SHOW_CUSTOM_DOMAINS'));
}
if (getenv('SHOW_CUSTOM_COLORS')) {
    $CONF['show_custom_colors'] = explode(' ', getenv('SHOW_CUSTOM_COLORS'));
}
