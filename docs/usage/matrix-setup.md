# Matrix setup
Setup multiple versions of [Apache Ant](https://ant.apache.org) on multiple operating systems:

```yaml
jobs:
  test:
    name: Apache Ant ${{matrix.version}} on ${{matrix.platform}}
    runs-on: ${{matrix.platform}}
    strategy:
      matrix:
        platform: [macos-latest, ubuntu-latest, windows-latest]
        version: [1.9.x, latest]
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: temurin
          java-version: 17
      - uses: cedx/setup-ant@v1
        with:
          optional-tasks: true
          version: ${{matrix.version}}
      - run: ant -version
```
