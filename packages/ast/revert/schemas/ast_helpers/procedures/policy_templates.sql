-- Revert schemas/ast_helpers/procedures/policy_templates from pg

BEGIN;

DROP FUNCTION ast_helpers.policy_templates;

COMMIT;
