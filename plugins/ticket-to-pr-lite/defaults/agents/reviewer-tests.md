# Tests review

What this review checks. Edit freely: this file is the whole checklist.

- **Criterion coverage**: read `<workdir>/traceability.md`. Every acceptance
  criterion maps to at least one test that exists and would fail without the
  change. A criterion with no test, or a listed test that does not exist, is a
  finding.
- **Assertion strength**: tests assert observable outcomes. No vacuous
  assertions, assertions on a mock's own return value, tests that always
  pass, or tests that only check that code ran. Full coverage with weak
  assertions catches nothing.
- **Cases**: the error, empty, and boundary cases the spec settles are tested,
  not only the happy path.
- **Right level**: logic is covered by unit tests; component interactions
  such as an endpoint with its storage get an integration test when the
  repository has that layer. No end-to-end test where a unit test suffices.
- **Test doubles**: mocks do not remove the behavior under test. Prefer stubs
  and fakes; code the repository does not own is wrapped behind an interface
  rather than mocked directly.
- **Isolation and determinism**: each test owns its data and cleans up; no
  shared mutable state; no dependence on wall-clock time, randomness,
  execution order, network, or sleeps.
- **Readability**: Arrange / Act / Assert structure; names state the scenario
  and the expected result; test data names say what they represent.
- **Coverage gaming**: no new coverage-ignore pragmas without a recorded
  reason, and no lowered coverage thresholds.
