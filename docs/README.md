# Setup Ant
Set up your [GitHub Actions](https://docs.github.com/en/actions) workflow 
with a specific version of [Apache Ant](https://ant.apache.org).

## Getting started
If you haven't used GitHub Actions before, be sure to check out the [related documentation](https://docs.github.com/en/actions/quickstart), 
as it explains how to create and configure a workflow.

Setup Apache Ant in a workflow:

```yaml
steps:
  - uses: cedx/setup-ant@v1
  - run: ant -version
```

## Usage
- [Inputs](usage/inputs.md)
- [Basic setup](usage/basic-setup.md)
- [Matrix setup](usage/matrix-setup.md)

> A sample workflow can be found in this [workflow.yaml](https://github.com/cedx/setup-ant/blob/main/example/workflow.yaml) file.

## See also
- [Learn GitHub Actions](https://docs.github.com/en/actions/learn-github-actions)
- [GitHub marketplace](https://github.com/marketplace/actions/setup-ant)
- [API reference](api/)
- [Code coverage](https://app.codecov.io/gh/cedx/setup-ant)
