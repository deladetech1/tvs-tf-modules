# `postgresql-readonly-role`

A read-only login for **one** database, meant to be handed to the tenant who
owns it.

This is the credential a silo customer gets when they ask to see their own data.
It is deliberately neither the app's role nor the migrator's: both can write and
create, and a credential that leaves our control should be able to do neither.

| | |
|---|---|
| **can** | connect to one database, `USAGE` on the listed schemas, `SELECT` |
| **cannot** | write, create, take temp tables, reach any other database, or inherit from `tvs_app_<env>` |

`owner_role` matters more than it looks. Default privileges attach to whoever
**creates** a table, not to the schema — so it has to name the migrator. Get it
wrong and the grant covers today's tables and silently misses every one added by
the next migration, which reads as missing data rather than a missing grant.
