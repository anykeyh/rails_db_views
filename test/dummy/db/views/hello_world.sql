 --!require required
SELECT 'HelloWorld' WHERE ( SELECT id FROM required ) IN (1)