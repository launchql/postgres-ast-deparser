-- Verify schemas/ast_helpers/procedures/policy_templates  on pg

BEGIN;

SELECT verify_function ('ast_helpers.policy_templates');

ROLLBACK;
