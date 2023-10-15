# Basic setup
Setup a specific version of [Apache Ant](https://ant.apache.org):

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: temurin
          java-version: 21
      - uses: cedx/setup-ant@v1
        with:
          optional-tasks: true
          version: 1.10.13
      - run: ant -version
```
