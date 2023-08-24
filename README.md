<div align="center">
	<h1>Matter-Plasma</h1>
</div>
<div align="center">
	<a href="https://github.com/lasttalon/matter-plasma/actions/workflows/ci.yaml">
		<img src="https://github.com/lasttalon/matter-plasma/actions/workflows/ci.yaml/badge.svg" alt="CI Status">
	</a>
  	<a href="https://lasttalon.github.io/matter-plasma/">
		<img src="https://github.com/lasttalon/matter-plasma/actions/workflows/docs.yaml/badge.svg" alt="Documentation">
	</a>
</div>
<br>

A [Plasma] middleware bridge for [Matter].

[plasma]: https://eryn.io/plasma/
[matter]: https://eryn.io/matter/

## Installation

This middleware can be installed with [Wally] by including it as a dependency in
your `wally.toml` file.

```toml
MatterPlasma = "lasttalon/matter-plasma@0.1.0"
```

## Building

Before building, you'll need to install all dependencies using [Wally].

You can then sync or build the project with [Rojo]. This repository contains
several project files with different builds of the project. The
`default.project.json` is the package build.

[rojo]: https://rojo.space/
[wally]: https://wally.run/

## Contributing

Contributions are welcome, please make a pull request! Check out our
[contribution] guide for further information.

Please read our [code of conduct] when getting involved.

[contribution]: CONTRIBUTING.md
[code of conduct]: CODE_OF_CONDUCT.md

## License

This middleware is free software available under the MIT license. See the
[license] for details.

[license]: LICENSE.md
