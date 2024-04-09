# Setup Ant
Set up your [GitHub Actions](https://docs.github.com/en/actions) workflow 
with a specific version of [Apache Ant](https://ant.apache.org).

## Getting started
If you haven't used GitHub Actions before, be sure to check out the [related documentation](https://docs.github.com/en/actions/quickstart), 
as it explains how to create and configure a workflow.

Setup Apache Ant in a workflow:

```yaml
steps:
  - uses: cedx/setup-ant@v2
  - run: ant -version
```

## Usage
- [Inputs](usage/inputs.md)
- [Basic setup](usage/basic_setup.md)
- [Matrix setup](usage/matrix_setup.md)
