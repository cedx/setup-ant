# Basic setup
Set up a specific version of [Apache Ant](https://ant.apache.org):

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 21
      - uses: cedx/setup-ant@v2
        with:
          optional-tasks: true
          version: 1.10.14
      - run: ant -version
```
