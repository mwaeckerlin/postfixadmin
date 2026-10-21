<?php

$CONF['configured'] = true;

$CONF['database_type'] = getenv('DATABASE_TYPE');
$CONF['database_host'] = getenv('DATABASE_HOST');
$CONF['database_user'] = getenv('DATABASE_USER');
$CONF['database_password'] = getenv('DATABASE_PASSWORD');
$CONF['database_name'] = getenv('DATABASE_NAME');
if (getenv('DATABASE_PORT')) {
    $CONF['database_port'] = getenv('DATABASE_PORT');
}
$CONF['setup_password'] = getenv('SETUP_PASSWORD');

if (getenv('ADMIN_EMAIL')) {
    $CONF['admin_email'] = getenv('ADMIN_EMAIL');
}
if (getenv('SMTP_SERVER')) {
    $CONF['smtp_server'] = getenv('SMTP_SERVER');
}
if (getenv('SMTP_PORT')) {
    $CONF['smtp_port'] = getenv('SMTP_PORT');
}

if (getenv('CREATE_MAILBOX_SUBDIRS')) {
    $CONF['create_mailbox_subdirs'] = preg_split('/\s+/', trim(getenv('CREATE_MAILBOX_SUBDIRS')));
}
if (getenv('CREATE_MAILBOX_SUBDIRS_PREFIX') !== false) {
    $CONF['create_mailbox_subdirs_prefix'] = getenv('CREATE_MAILBOX_SUBDIRS_PREFIX');
}
if (getenv('IMAP_HOST')) {
    $CONF['create_mailbox_subdirs_host'] = getenv('IMAP_HOST');
}
if (getenv('IMAP_PORT')) {
    $CONF['create_mailbox_subdirs_hostport'] = getenv('IMAP_PORT');
}
if (getenv('IMAP_OPTIONS')) {
    $CONF['create_mailbox_subdirs_hostoptions'] = preg_split('/\s+/', trim(getenv('IMAP_OPTIONS')));
}

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
