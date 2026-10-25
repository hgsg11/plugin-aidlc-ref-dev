# Security review

What this review checks. Edit freely: this file is the whole checklist.

Check only the changed code and the paths it opens.

- **Access control**: every new or changed entry point checks
  authentication, and authorization for the specific object requested, not
  only the role. Deny by default; never trust client-supplied ownership.
- **Injection**: queries are parameterized, never built by string
  concatenation; shell commands and file paths are not built from input;
  output is encoded for its context (HTML, URL, JavaScript, terminal,
  spreadsheet).
- **Input validation**: type, length, range, and format are checked at the
  trusted boundary, including rules the client also enforces.
- **Secrets**: no hardcoded credentials or keys; secrets come from the
  environment or a secrets store and never reach logs, errors, or URLs.
- **Sensitive data**: passwords, tokens, and personal data are not logged or
  returned in error messages; errors do not expose stack traces or SQL.
- **Crypto and auth**: no custom cryptography; passwords hashed with a slow
  salted hash; cookies HttpOnly, Secure, and SameSite; tokens short-lived.
- **Server-side requests**: outbound URLs from input are allowlisted;
  internal network ranges and redirects are blocked.
- **Untrusted data**: no deserialization of untrusted objects; uploads are
  checked for type and size; archives and parsers have limits.
- **Abuse**: rate limits on authentication and expensive operations; timeouts
  on outbound calls.
- **Dependencies**: new dependencies are necessary, maintained, pinned, and
  free of known critical vulnerabilities.
- **Threats on new data flows**: for each new flow, consider spoofing,
  tampering, repudiation (security-relevant actions are logged), information
  disclosure, denial of service, and privilege escalation.
